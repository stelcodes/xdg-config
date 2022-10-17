#!/usr/bin/bash

if [[ ! $UID -eq 0 ]]; then
  echo "Script should be runned under root!" 1>&2
  exit 1
fi

SWAP_DIR=/swap
HIBEFILE=hibernation

HIBERFILE_PATH=${SWAP_DIR}/${HIBEFILE}

FS_TYPE=$(mount | grep " on / " | awk '{print $5}')

if [[ "${FS_TYPE}" != 'btrfs' ]]; then
  echo "Only 'btrfs' filesystem supported" 1>&2
  exit 1
fi

ZRAM_SIZE=$(zramctl -no DISKSIZE | sed -e 's%\s%%g')

ZRAM_SIZE_INT=$(echo ${ZRAM_SIZE} | sed -e 's%[a-zA-Z\s]%%')
ZRAM_SIZE_SUFF=$(echo ${ZRAM_SIZE} | sed -e 's%[0-9]%%g' -e 's%$%ib%')

RAM_SIZE=$(free -gt | grep ^Mem | awk '{print $2}')

HIBERFILE_SIZE=$(( ZRAM_SIZE_INT*2 ))
HIBERFILE_SIZE=$(( HIBERFILE_SIZE+RAM_SIZE ))

btrfs subvolume show ${SWAP_DIR} > /dev/null 2>&1
if [[ ! $? -eq 0 ]]; then
  btrfs subvolume create "${SWAP_DIR}"
fi

if [[ ! -e ${HIBERFILE_PATH} ]]; then
  touch "${HIBERFILE_PATH}"
  chattr +C "${HIBERFILE_PATH}"
  fallocate --length ${HIBERFILE_SIZE}${ZRAM_SIZE_SUFF} ${HIBERFILE_PATH}
  chmod 600 ${HIBERFILE_PATH}
  mkswap ${HIBERFILE_PATH}
fi

if [[ ! -e /etc/dracut.conf.d/resume.conf ]]; then
  echo 'add_dracutmodules+=" resume "' > /etc/dracut.conf.d/resume.conf
  dracut -f
fi

RESUME_UUID=$(findmnt -no UUID -T ${SWAP_DIR})

grep /etc/default/grub -e "resume=UUID=${RESUME_UUID}" -q > /dev/null 2>&1

if [[ ! $? -eq 0 ]]; then
  curl "https://raw.githubusercontent.com/osandov/osandov-linux/master/scripts/btrfs_map_physical.c" > /tmp/btrfs_map_physical.c
  gcc -O2 -o /tmp/btrfs_map_physical /tmp/btrfs_map_physical.c
  chmod +x /tmp/btrfs_map_physical

  PAGESIZE=$(getconf PAGESIZE)
  RESUME_OFFSET=$(/tmp/btrfs_map_physical ${HIBERFILE_PATH} | sed -n 2p | awk '{print $9}')
  RESUME_OFFSET=$(( RESUME_OFFSET / PAGESIZE ))

  cp /etc/default/grub /etc/default/grub.bak

  GRUB_ARGS="resume=UUID=${RESUME_UUID} resume_offset=${RESUME_OFFSET}"

  grubby --args="${GRUB_ARGS}" --update-kernel=ALL
fi

SYSTEMD_ENVFILE=/etc/sysconfig/hibernation

if [[ ! -e ${SYSTEMD_ENVFILE} ]]; then
cat > ${SYSTEMD_ENVFILE} <<EOF
HIBERFILE=${HIBERFILE_PATH}
EOF
fi

mkdir -p /etc/systemd/system/systemd-{logind,hibernate}.service.d/

SYSTEMD_OVERRIDES="
/etc/systemd/system/systemd-logind.service.d/override.conf
/etc/systemd/system/systemd-hibernate.service.d/override.conf
"

for override in ${SYSTEMD_OVERRIDES}; do
  [[ -e ${override} ]] && continue
  cat > ${override} <<EOF
[Service]
Environment=SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK=1
EOF
done

cat > /etc/systemd/system/hibernate-pre.service <<EOF
[Unit]
Description=Enable swap file and disable zram before hibernate
Before=systemd-hibernate.service

[Service]
User=root
Type=oneshot
EnvironmentFile=${SYSTEMD_ENVFILE}
ExecStart=/bin/bash -c "/usr/sbin/swapon \$HIBERFILE && /usr/sbin/swapoff /dev/zram0"

[Install]
WantedBy=systemd-hibernate.service
EOF

cat > /etc/systemd/system/hibernate-resume.service <<EOF
[Unit]
Description=Disable swap after resuming from hibernation
After=hibernate.target

[Service]
User=root
Type=oneshot
EnvironmentFile=${SYSTEMD_ENVFILE}
ExecStart=/usr/sbin/swapoff \$HIBERFILE

[Install]
WantedBy=hibernate.target
EOF

systemctl daemon-reload
systemctl enable hibernate-pre.service

cd /tmp

rpm -q setools-console > /dev/null 2>&1
if [[ ! $? -eq 0 ]]; then
  dnf install setools-console -y
fi

if [[ -z "$(sesearch -A -s systemd_sleep_t -t unlabeled_t -c dir -p search)" ]]; then
  SELINUX_TEMP=$(mktemp)
  cat > ${SELINUX_TEMP} <<EOL

module systemd_sleep 1.0;

require {
    type unlabeled_t;
    type systemd_sleep_t;
    class dir search;
}

#============= systemd_sleep_t ==============
allow systemd_sleep_t unlabeled_t:dir search;
EOL

  chown root:root ${SELINUX_TEMP}
  checkmodule -M -m -o ${SELINUX_TEMP}.mod ${SELINUX_TEMP}
  semodule_package -o ${SELINUX_TEMP}.pp -m ${SELINUX_TEMP}.mod
  semodule -i ${SELINUX_TEMP}.pp
  semodule -e systemd_sleep
fi

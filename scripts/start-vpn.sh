#!/usr/bin/env bash

# ls | bb -i '(->> *input* (map #(str/split % #"\.")) (map #(str (str/replace (subs (first %) 0 5) "-" "_") "=" (str/join "." %))) (str/join "\n") (println))'

ch_ae=ch-ae-01.protonvpn.com.udp.ovpn
ch_ar=ch-ar-01.protonvpn.com.udp.ovpn
ch_at=ch-at-01.protonvpn.com.udp.ovpn
ch_au=ch-au-01.protonvpn.com.udp.ovpn
ch_be=ch-be-01.protonvpn.com.udp.ovpn
ch_bg=ch-bg-01.protonvpn.com.udp.ovpn
ch_ca=ch-ca-01.protonvpn.com.udp.ovpn
ch_cl=ch-cl-01.protonvpn.com.udp.ovpn
ch_co=ch-co-01.protonvpn.com.udp.ovpn
ch_cy=ch-cy-01a.protonvpn.com.udp.ovpn
ch_cz=ch-cz-01.protonvpn.com.udp.ovpn
ch_de=ch-de-01.protonvpn.com.udp.ovpn
ch_dk=ch-dk-01.protonvpn.com.udp.ovpn
ch_ee=ch-ee-01.protonvpn.com.udp.ovpn
ch_es=ch-es-01.protonvpn.com.udp.ovpn
ch_fi=ch-fi-01.protonvpn.com.udp.ovpn
ch_fr=ch-fr-01.protonvpn.com.udp.ovpn
ch_gr=ch-gr-01.protonvpn.com.udp.ovpn
ch_hk=ch-hk-01.protonvpn.com.udp.ovpn
ch_hu=ch-hu-01.protonvpn.com.udp.ovpn
ch_ie=ch-ie-01.protonvpn.com.udp.ovpn
ch_il=ch-il-01.protonvpn.com.udp.ovpn
ch_in=ch-in-01.protonvpn.com.udp.ovpn
ch_it=ch-it-01.protonvpn.com.udp.ovpn
ch_jp=ch-jp-01.protonvpn.com.udp.ovpn
ch_kr=ch-kr-01.protonvpn.com.udp.ovpn
ch_lt=ch-lt-01.protonvpn.com.udp.ovpn
ch_lu=ch-lu-01.protonvpn.com.udp.ovpn
ch_lv=ch-lv-01.protonvpn.com.udp.ovpn
ch_md=ch-md-01.protonvpn.com.udp.ovpn
ch_mx=ch-mx-01.protonvpn.com.udp.ovpn
ch_my=ch-my-01.protonvpn.com.udp.ovpn
ch_nl=ch-nl-01.protonvpn.com.udp.ovpn
ch_no=ch-no-01.protonvpn.com.udp.ovpn
ch_nz=ch-nz-01.protonvpn.com.udp.ovpn
ch_pe=ch-pe-01.protonvpn.com.udp.ovpn
ch_pl=ch-pl-01.protonvpn.com.udp.ovpn
ch_pt=ch-pt-01.protonvpn.com.udp.ovpn
ch_rs=ch-rs-01.protonvpn.com.udp.ovpn
ch_sg=ch-sg-01.protonvpn.com.udp.ovpn
ch_si=ch-si-01.protonvpn.com.udp.ovpn
ch_sk=ch-sk-01.protonvpn.com.udp.ovpn
ch_tr=ch-tr-01.protonvpn.com.udp.ovpn
ch_tw=ch-tw-01.protonvpn.com.udp.ovpn
ch_ua=ch-ua-01.protonvpn.com.udp.ovpn
ch_uk=ch-uk-01.protonvpn.com.udp.ovpn
ch_us=ch-us-01.protonvpn.com.udp.ovpn
is_at=is-at-01.protonvpn.com.udp.ovpn
is_be=is-be-01.protonvpn.com.udp.ovpn
is_br=is-br-01.protonvpn.com.udp.ovpn
is_ca=is-ca-01.protonvpn.com.udp.ovpn
is_cr=is-cr-01.protonvpn.com.udp.ovpn
is_de=is-de-01.protonvpn.com.udp.ovpn
is_dk=is-dk-01.protonvpn.com.udp.ovpn
is_es=is-es-01.protonvpn.com.udp.ovpn
is_fr=is-fr-01.protonvpn.com.udp.ovpn
is_ge=is-ge-01a.protonvpn.com.udp.ovpn
is_hk=is-hk-01.protonvpn.com.udp.ovpn
is_hu=is-hu-01.protonvpn.com.udp.ovpn
is_ie=is-ie-01.protonvpn.com.udp.ovpn
is_il=is-il-01.protonvpn.com.udp.ovpn
is_it=is-it-01.protonvpn.com.udp.ovpn
is_lu=is-lu-01.protonvpn.com.udp.ovpn
is_nl=is-nl-01.protonvpn.com.udp.ovpn
is_no=is-no-01.protonvpn.com.udp.ovpn
is_ru=is-ru-01.protonvpn.com.udp.ovpn
is_uk=is-uk-01.protonvpn.com.udp.ovpn
is_us=is-us-01.protonvpn.com.udp.ovpn
is_za=is-za-01.protonvpn.com.udp.ovpn
se_ar=se-ar-01.protonvpn.com.udp.ovpn
se_au=se-au-01.protonvpn.com.udp.ovpn
se_br=se-br-01.protonvpn.com.udp.ovpn
se_ca=se-ca-01.protonvpn.com.udp.ovpn
se_ee=se-ee-01.protonvpn.com.udp.ovpn
se_eg=se-eg-01.protonvpn.com.udp.ovpn
se_es=se-es-01.protonvpn.com.udp.ovpn
se_fi=se-fi-01.protonvpn.com.udp.ovpn
se_fr=se-fr-01.protonvpn.com.udp.ovpn
se_hk=se-hk-01.protonvpn.com.udp.ovpn
se_jp=se-jp-01.protonvpn.com.udp.ovpn
se_kh=se-kh-01.protonvpn.com.udp.ovpn
se_kr=se-kr-01.protonvpn.com.udp.ovpn
se_lt=se-lt-01.protonvpn.com.udp.ovpn
se_md=se-md-01.protonvpn.com.udp.ovpn
se_nl=se-nl-01.protonvpn.com.udp.ovpn
se_no=se-no-01.protonvpn.com.udp.ovpn
se_nz=se-nz-01.protonvpn.com.udp.ovpn
se_ph=se-ph-01.protonvpn.com.udp.ovpn
se_pt=se-pt-01.protonvpn.com.udp.ovpn
se_ro=se-ro-01.protonvpn.com.udp.ovpn
se_ru=se-ru-01.protonvpn.com.udp.ovpn
se_sg=se-sg-01.protonvpn.com.udp.ovpn
se_tw=se-tw-01.protonvpn.com.udp.ovpn
se_us=se-us-01.protonvpn.com.udp.ovpn
se_vn=se-vn-01.protonvpn.com.udp.ovpn

config="$HOME/vpn/$is_us"

if [[ -e "$@" ]]; then
  config="$@"
fi

echo "Starting openvpn with config $config"
sudo openvpn --config $config --auth-user-pass /secrets/protonvpn

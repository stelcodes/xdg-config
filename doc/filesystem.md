Default fedora server 35 setup is creating an LVM volume called root that is just 16GiB. I quickly hit the limit and started getting "no more space" errors from rsync. Here's how you add more space to that root partition.

As root, look at the LVM volume group with `vgdisplay` and check the `Free / PE Size` field to see if you have any free room in the volume group. If you do, look at your logical volumes with `lgdisplay` and check the `LV name` and `VG name` fields. One of these will be the volume you want. Fedora called the main volume group `fedora_<hostname>` and the main logical volume `root` by default.

Then you can resize the logical volume with `lvextend -L+<num>G /dev/<volume_group>/<logical_volume>`. Then run `lvdisplay` again and check that the `LV Size` changed.

After that you'll need to extend the filesystem. Fedora Server uses XFS by default. With XFS you can run `xfs_growfs /dev/<volume_group>/<logical_volume>`. Now run `df -h` and confirm the filesystem has expanded.

https://www.rootusers.com/lvm-resize-how-to-increase-an-lvm-partition/


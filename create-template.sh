#!/bin/sh

# Set Work Dir - This should be the pve iso storage location.
# The .img file would be downloaded in this directory.
work_dir="{Replace:path-to-image-storage-volumne}/template/iso"
# Image Download Url
image_download_url="https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
# This Image should be available in $image_storage
image_name="{Replace:image-name}"
image_storage="{Replace:image-storage-name}"


vm_id=9999
vm_name="{Replace:template-vm-name}"
vm_storage="{Replace:template-vm-storage}"

curr_dir=$(pwd)
cd $work_dir

wget -nc -O $image_name.original $image_download_url
cp $image_name.original $image_name
virt-customize -a $image_name --install qemu-guest-agent,ca-certificates,curl,gnupg,lsb-release
virt-customize -a $image_name --firstboot $curr_dir/firstboot.sh
qm create $vm_id --name $vm_name --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk $vm_id $image_name $vm_storage 
qm set $vm_id --scsihw virtio-scsi-pci --scsi0 $vm_storage:$vm_id/vm-$vm_id-disk-0.raw
qm set $vm_id --boot c --bootdisk scsi0
qm set $vm_id --ide2 $vm_storage:cloudinit
# qm set $vm_id --serial0 socket --vga serial0
qm set $vm_id --agent enabled=1
qm template $vm_id
rm $image_name

cd $curr_dir

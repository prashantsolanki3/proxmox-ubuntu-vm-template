#!/bin/sh

set -o allexport
. $1
set +o allexport

curr_dir=$(pwd)
cd $work_dir
# Check if the VM exists
if qm list | grep -q 'running' | grep -q $vm_id; then
    # Shutdown the VM
    echo "Shutting down VM $vm_id"
    qm shutdown $vm_id
fi

echo "Downloading image $image_name"
wget -q -O $image_name $image_download_url
echo "Completed downloading image $image_name"

echo "Installing qemu-guest-agent"
virt-customize -a $image_name --install qemu-guest-agent

# Wait for the VM to shutdown
echo "Checking if VM $vm_id is shutdown"
while qm list | grep -q 'running' | grep -q $vm_id; do
    echo "Waiting for VM $vm_id to shutdown"
    sleep 1
done

if qm list | grep -q 'stopped' | grep -q $vm_id; then
    echo "Destroying VM $vm_id"
    qm destroy $vm_id
fi

if ! qm list | grep -q $vm_id; then
    echo "Creating VM $vm_id"
    qm create $vm_id --name $vm_name --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
    qm importdisk $vm_id $image_name $vm_storage 
    qm set $vm_id --scsihw virtio-scsi-pci --scsi0 $vm_storage:vm-$vm_id-disk-0
    qm set $vm_id --boot c --bootdisk scsi0
    qm set $vm_id --ide2 $vm_storage:cloudinit
    qm set $vm_id --serial0 socket --vga serial0
    qm set $vm_id --agent enabled=1
    qm template $vm_id
fi

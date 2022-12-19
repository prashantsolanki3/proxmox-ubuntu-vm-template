# Create ubuntu vm template in proxmox

Note: Clone the repo to your **proxmox host** with access to the storage with vm images.

# Prerequisites 


```apt-get install libguestfs-tools```


```sh

git clone https://github.com/prashantsolanki3/proxmox-ubuntu-vm-template.git

cd proxmox-ubuntu-vm-template/

# Make the file executable
chmod +x ./create-template.sh

cp .env.sample .env

# Populate the .env file with your values
nano .env

# Update the values with `{Replace:*}`

# Run the script
bash -x ./create-template.sh

```



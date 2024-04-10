resource "proxmox_virtual_environment_file" "debian_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"

  source_file {
    path      = "https://cdimage.debian.org/images/cloud/bookworm/20240211-1654/debian-12-genericcloud-amd64-20240211-1654.qcow2"
    file_name = "debian-12-genericcloud-amd64-20240211-1654.img"
  }
}

resource "proxmox_virtual_environment_file" "rocky_linux_minimal" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"

  source_file {
    path      = "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2"
    file_name = "CentOS-Stream-GenericCloud-9-latest.x86_64.img"
  }
}
#https://dl.rockylinux.org/pub/rocky/9.3/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2
data "local_file" "ssh_public_key" {
  filename = "./terraform_rsa.pub"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<EOF
#cloud-config
package_upgrade: true
packages:
  - qemu-guest-agent
timezone: Europe/Berlin
users:
  - default
  - name: joachim
    groups: [users, admin, sudo]
    shell: /bin/bash
    lock-passwd: true
    ssh_authorized_keys:
      - ${trimspace(data.local_file.ssh_public_key.content)}
    sudo: ALL=(ALL) NOPASSWD:ALL
runcmd:
    - apt update
    - apt install -y qemu-guest-agent net-tools
    - timedatectl set-timezone Europe/Berlin
    - systemctl enable qemu-guest-agent
    - systemctl start qemu-guest-agent
    - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "cloud-config.yaml"
  }
}

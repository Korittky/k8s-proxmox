
#resource "proxmox_virtual_environment_file" "debian_cloud_image" {
#  content_type = "iso"
#  datastore_id = "local"
#  node_name    = "pve"

#  source_file {
#    path      = "https://cdimage.debian.org/images/cloud/bookworm/20240211-1654/debian-12-genericcloud-amd64-20240211-1654.qcow2"
#    file_name = "debian-12-genericcloud-amd64-20240211-1654.img"
#  }
#}

#resource "proxmox_virtual_environment_file" "open_suse" {
#  content_type = "iso"
#  datastore_id = "local"
#  node_name    = "pve"

#  source_file {
    # We must override the file extension to bypass the validation code
    # in the Proxmox VE API.
#    file_name = "openSUSE-Leap-15.6.x86_64-1.0.0-NoCloud-Build3.311.img"
#    path      = "/var/lib/vz/template/iso/openSUSE-Leap-15.6.x86_64-1.0.0-NoCloud-Build3.311.img"
#  }
#
#}

#https://dl.rockylinux.org/pub/rocky/9.3/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2
#https://download.opensuse.org/distribution/leap/15.5/iso/openSUSE-Leap-15.5-NET-x86_64-Build491.1-Media.iso
#https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2
#https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.6/images/openSUSE-Leap-15.6.x86_64-NoCloud.qcow2
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

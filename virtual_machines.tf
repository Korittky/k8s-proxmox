resource "proxmox_virtual_environment_vm" "k8s_cp_01" {
  name        = "k8s-cp-01"
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   = "pve"

  cpu {
    type = "host"
    cores = 2
  }

  memory {
    dedicated = 6144
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }


  disk {
    datastore_id = "local-zfs"
#    file_id      = proxmox_virtual_environment_file.open_suse.id
#    datastore_id = "local-lvm"
#    file_id      = "local:iso/openSUSE-Leap-15.6.x86_64-1.0.0-NoCloud-Build3.311.img"
    file_id      = "local:iso/debian-12-genericcloud.img"
    interface    = "scsi0"
    size         = 22
  }

  serial_device {} # The Debian cloud image expects a serial port to be present

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id      = "local-zfs"
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}

resource "proxmox_virtual_environment_vm" "k8s_worker_01" {
  name        = "k8s-worker-01"
  description = "Managed by Terraform"
  tags        = ["terraform"]
  node_name   ="pve"

  cpu {
    type = "host"
    cores = 1
  }

  memory {
    dedicated = 2048
  }

  
  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-zfs"
#    file_id      = proxmox_virtual_environment_file.open_suse.id
#    file_id      = "local:iso/openSUSE-Leap-15.6.x86_64-1.0.0-NoCloud-Build3.311.img"
    file_id      = "local:iso/debian-12-genericcloud.img"
    interface    = "scsi0"
    size         = 22
  }

  serial_device {} # The Debian cloud image expects a serial port to be present

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id      = "local-zfs"
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}

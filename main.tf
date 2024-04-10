terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.52.0"
    }
  }
}

provider "proxmox" {
    endpoint = "https://proxmoxve:8006/"
    insecure = true
}

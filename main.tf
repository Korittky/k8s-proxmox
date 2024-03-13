terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.48.1"
    }
  }
}

provider "proxmox" {
    endpoint = "https://proxmoxve:8006/"
    insecure = true
}

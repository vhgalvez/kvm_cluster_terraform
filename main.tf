terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "kube_network" {
  name      = "kube_network"
  mode      = "nat"
  addresses = ["10.17.3.0/24"]
}

resource "libvirt_pool" "volumetmp" {
  name = var.cluster_name
  type = "dir"
  path = "/var/lib/libvirt/images/${var.cluster_name}"
}

resource "libvirt_volume" "base" {
  name   = "${var.cluster_name}-base"
  source = var.base_image
  pool   = libvirt_pool.volumetmp.name
  format = "qcow2"
}

locals {
  vm_instances = merge([
    for vm_type, config in var.vm_count : {
      for i in range(config.count) : "${vm_type}-${i + 1}" => {
        cpus   = config.cpus
        memory = config.memory
        type   = vm_type
      }
    }
  ]...)
}

resource "libvirt_volume" "vm_disk" {
  for_each       = locals.vm_instances
  name           = "${each.key}.qcow2"
  base_volume_id = libvirt_volume.base[each.value.type].id
  pool           = libvirt_pool.volumetmp.name
  format         = "qcow2"
}

resource "libvirt_domain" "vm" {
  for_each = locals.vm_instances

  name   = each.key
  vcpu   = each.value.cpus
  memory = each.value.memory * 1024  // Convert MB to KB

  network_interface {
    network_id = libvirt_network.kube_network.id
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    listen_address = "0.0.0.0"
  }
}

output "ip_addresses" {
  value = { for k, vm in libvirt_domain.vm : k => vm.network_interface[0].addresses[0] if length(vm.network_interface[0].addresses) > 0 }
}
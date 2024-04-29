terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.10.0"
    }
  }
}

# Provider configuration
provider "libvirt" {
  uri = "qemu:///system"
}

# Network resource
resource "libvirt_network" "kube_network" {
  name      = "kube_network"
  mode      = "nat"
  addresses = ["10.17.3.0/24"]
}

# Pool resource
resource "libvirt_pool" "volumetmp" {
  name = var.cluster_name
  type = "dir"
  path = "/var/lib/libvirt/images/${var.cluster_name}"
}

# Volume resource
resource "libvirt_volume" "base" {
  for_each = var.vm_count
  name     = "${each.key}-${var.cluster_name}-base"
  source   = var.base_image
  pool     = libvirt_pool.volumetmp.name
  format   = "qcow2"
}

# Local variable for VM instances
locals {
  vm_instances = { for k, v in var.vm_count : 
                   for idx in range(v.count) : 
                   "${k}-${idx}" => { 
                     cpus = v.cpus, 
                     memory = v.memory 
                   }
                 }
}

# Domain resource
resource "libvirt_domain" "vm" {
  for_each = locals.vm_instances

  name     = "${each.key}-${var.cluster_name}"
  vcpu     = each.value.cpus
  memory   = each.value.memory

  network_interface {
    network_id     = libvirt_network.kube_network.id
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.base[split("-", each.key)[0]].id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}

# Template file data source
data "template_file" "vm-configs" {
  for_each = locals.vm_instances

  template = file("${path.module}/configs/machine-${split("-", each.key)[0]}-config.yaml.tmpl")

  vars = {
    ssh_keys   = jsonencode(var.ssh_keys),
    name       = split("-", each.key)[0],
    host_name  = "${each.key}.${var.cluster_name}.${var.cluster_domain}",
    strict     = true,
    pretty_print = true
  }
}

# CT config data source
data "ct_config" "vm-ignitions" {
  for_each = data.template_file.vm-configs
  content  = each.value.rendered
}

# Output IP addresses
output "ip_addresses" {
  value = { for k, vm in libvirt_domain.vm : k => vm.network_interface[0].addresses[0] }
}
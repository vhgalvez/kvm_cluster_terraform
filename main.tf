# main.tf
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
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Move locals definition above resources that use it
locals {
  vm_instances = merge([
    for k, v in var.vm_count : {
      for i in range(v.count) : "${k}-${i + 1}" => {
        cpus   = v.cpus
        memory = v.memory
      }
    }
  ]...)# Define the libvirt_ignition resource
resource "libvirt_ignition" "ignition" {
  for_each = local.vm_instances # Fix here

  name    = "${each.key}-ignition"
  pool    = libvirt_pool.volumetmp.name
  content = data.ct_config.vm-ignitions[each.key].rendered
}

# Define the libvirt_volume for vm disks
resource "libvirt_volume" "vm_disk" {
  for_each       = local.vm_instances # Fix here
  name           = "${each.key}-${var.cluster_name}.qcow2"
  base_volume_id = libvirt_volume.base[each.key].id
  pool           = libvirt_pool.volumetmp.name
  format         = "qcow2"
}# Define the libvirt_ignition resource
resource "libvirt_ignition" "ignition" {
  for_each = local.vm_instances # Fix here

  name    = "${each.key}-ignition"
  pool    = libvirt_pool.volumetmp.name
  content = data.ct_config.vm-ignitions[each.key].rendered
}

# Define the libvirt_volume for vm disks
resource "libvirt_volume" "vm_disk" {
  for_each       = local.vm_instances # Fix here
  name           = "${each.key}-${var.cluster_name}.qcow2"
  base_volume_id = libvirt_volume.base[each.key].id
  pool           = libvirt_pool.volumetmp.name
  format         = "qcow2"
}
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
  for_each = local.vm_instances
  name     = "${each.key}-base"
  source   = var.base_image
  pool     = libvirt_pool.volumetmp.name
  format   = "qcow2"
}

resource "libvirt_domain" "vm" {
  for_each = local.vm_instances

  name   = each.key
  vcpu   = each.value.cpus
  memory = each.value.memory

  network_interface {
    network_id     = libvirt_network.kube_network.id
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.base[each.key].id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}

# Define the libvirt_ignition resource
resource "libvirt_ignition" "ignition" {
  for_each = toset(keys(var.vm_count)) # Fix here

  name    = "${each.key}-ignition"
  pool    = libvirt_pool.volumetmp.name
  content = data.ct_config.vm-ignitions[each.key].rendered
}

# Define the libvirt_volume for vm disks
resource "libvirt_volume" "vm_disk" {
  for_each       = toset(keys(var.vm_count)) # Fix here
  name           = "${each.key}-${var.cluster_name}.qcow2"
  base_volume_id = libvirt_volume.base[each.key].id
  pool           = libvirt_pool.volumetmp.name
  format         = "qcow2"
}

# Adjust ordering: Move data.template_file.vm-configs after locals.vm_instances
data "template_file" "vm-configs" {
  for_each = local.vm_instances

  template = file("${path.module}/configs/machine-${split("-", each.key)[0]}-config.yaml.tmpl")

  vars = {
    ssh_keys     = jsonencode(var.ssh_keys),
    name         = each.key,
    host_name    = "${each.key}.${var.cluster_name}.${var.cluster_domain}",
    strict       = true,
    pretty_print = true
  }
}

# Define the ct_config data source
data "ct_config" "vm-ignitions" {
  for_each = data.template_file.vm-configs

  content = each.value.rendered
}

# Define the output for ip addresses
output "ip_addresses" {
  value = { for k, vm in libvirt_domain.vm : k => vm.network_interface[0].addresses[0] }
}
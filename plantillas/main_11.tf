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

provider "ct" {}

resource "libvirt_network" "kube_network" {
  name      = "kube_network"
  mode      = "nat"
  addresses = ["10.17.3.0/24"]
}

resource "libvirt_pool" "volumetmp" {
  name = "vms"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_volume" "base" {
  for_each = var.vm_definitions

  name   = "${each.key}-base"
  pool   = libvirt_pool.volumetmp.name
  format = "qcow2"
}

data "template_file" "vm-configs" {
  for_each = var.vm_definitions

  template = file("${path.module}/configs/machine-${each.key}-config.yaml.tmpl")

  vars = {
    ssh_keys     = jsonencode(var.ssh_keys),
    name         = each.key,
    host_name    = "${each.key}.${var.cluster_name}.${var.cluster_domain}",
    strict       = true,
    pretty_print = true
  }
}

data "ct_config" "vm-ignitions" {
  for_each = var.vm_definitions

  content = data.template_file.vm-configs[each.key].rendered
}

resource "libvirt_ignition" "ignition" {
  for_each = var.vm_definitions

  name    = "${each.key}-ignition"
  pool    = libvirt_pool.volumetmp.name
  content = data.ct_config.vm-ignitions[each.key].rendered
}

resource "libvirt_volume" "vm_disk" {
  for_each = var.vm_definitions

  name           = "${each.key}-${var.cluster_name}.qcow2"
  base_volume_id = libvirt_volume.base[each.key].id
  pool           = libvirt_pool.volumetmp.name
  format         = "qcow2"
}

resource "libvirt_domain" "vm" {
  for_each = var.vm_definitions

  name   = "${each.key}-${each.value.count}"
  vcpu   = each.value.cpus
  memory = each.value.memory

  network_interface {
    network_id     = libvirt_network.kube_network.id
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  coreos_ignition = libvirt_ignition.ignition[each.key].id

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}

output "ip-addresses" {
  value = {
    for key, machine in libvirt_domain.vm :
    key => machine.network_interface.0.addresses[0]
    if length(machine.network_interface.0.addresses) > 0
  }
}
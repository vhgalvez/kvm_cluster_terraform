# main.tf
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.0"
    }
    ct = {
      source = "poseidon/ct"
      version = "0.10.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "kube_network" {
  name = "kube_network"
  mode = "nat"
  addresses = ["10.17.3.0/24"]
}

resource "libvirt_pool" "volumetmp" {
  name = var.cluster_name
  type = "dir"
  path = "/var/lib/libvirt/images/${var.cluster_name}"
}

resource "libvirt_volume" "base" {
  for_each = var.vm_count

  name   = "${each.key}-${var.cluster_name}-base"
  source = var.base_image
  pool   = libvirt_pool.volumetmp.name
  format = "qcow2"
}

resource "libvirt_domain" "vm" {
  for_each = var.vm_count
  name     = "${each.key}-${var.cluster_name}"
  vcpu     = var.virtual_cpus
  memory   = var.virtual_memory

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

data "template_file" "vm-configs" {
  for_each = var.vm_count
  template = file("${path.module}/configs/${each.key}-config.yaml.tmpl")

  vars = {
    ssh_keys = jsonencode(var.ssh_keys)
    hostname = "${each.key}.${var.cluster_domain}"
  }
}

data "ct_config" "vm-ignitions" {
  for_each = data.template_file.vm-configs
  content  = each.value.rendered
}

output "ip_addresses" {
  value = { for name, vm in libvirt_domain.vm : name => vm.network_interface[0].addresses[0] }
}

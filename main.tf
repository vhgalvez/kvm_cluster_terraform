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
  for_each = locals.vm_instances
  name     = "${each.key}.qcow2"
  base_volume_id = libvirt_volume.base[each.key].id
  pool     = libvirt_pool.volumetmp.name
  format   = "qcow2"
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
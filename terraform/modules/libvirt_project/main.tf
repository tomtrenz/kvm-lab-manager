resource "libvirt_pool" "working" {
  name = var.storage_pool_name
  type = "dir"
  target = { path = "${var.storage_root}/projects/${var.project_id}/runs/${var.run_id}" }
}

locals {
  disks = merge([
    for vm_name, vm in var.vm_definitions : {
      for disk_name, disk in vm.disks :
      "${vm_name}.${disk_name}" => merge(disk, { vm_name = vm_name, disk_name = disk_name })
    }
  ]...)
}

resource "libvirt_volume" "overlay" {
  for_each = local.disks
  name = "${var.domain_name_prefix}-${each.value.vm_name}-${each.value.disk_name}.qcow2"
  pool = libvirt_pool.working.name
  capacity = each.value.capacity
  target = { format = { type = "qcow2" } }
  backing_store = {
    path = each.value.backing_store
    format = { type = each.value.backing_format }
  }
}

resource "libvirt_domain" "vm" {
  for_each = var.vm_definitions
  name = "${var.domain_name_prefix}-${each.key}"
  type = "kvm"
  memory = each.value.memory
  memory_unit = "MiB"
  vcpu = each.value.vcpu
  autostart = var.autostart
  running = var.start_domains
  os = { type = "hvm" }
  devices = {
    disks = [
      for disk_name, disk in each.value.disks : {
        source = {
          volume = {
            pool = libvirt_pool.working.name
            volume = libvirt_volume.overlay["${each.key}.${disk_name}"].name
          }
        }
        target = { dev = disk.target_dev, bus = disk.bus }
      }
    ]
    interfaces = [
      for network in each.value.networks : merge(
        { model = { type = "virtio" } },
        try(network.bridge, null) != null ? { source = { bridge = { bridge = network.bridge } } } : {},
        try(network.network_name, null) != null ? { source = { network = { network = network.network_name } } } : {},
        try(network.mac, null) != null ? { mac = { address = network.mac } } : {}
      )
    ]
  }
}

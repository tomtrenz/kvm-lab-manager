provider "libvirt" {
  uri = var.libvirt_uri
}

module "libvirt_project" {
  source = "./modules/libvirt_project"
  libvirt_uri = var.libvirt_uri
  project_id = var.project_id
  checkpoint_id = var.checkpoint_id
  run_id = var.run_id
  storage_root = var.storage_root
  storage_pool_name = var.storage_pool_name
  domain_name_prefix = var.domain_name_prefix
  vm_definitions = var.vm_definitions
  checkpoint_disks = var.checkpoint_disks
  autostart = var.autostart
  start_domains = var.start_domains
  connection_timeout = var.connection_timeout
  tags = var.tags
}

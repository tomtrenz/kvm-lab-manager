variable "libvirt_uri" { type = string; sensitive = true }
variable "project_id" { type = string }
variable "checkpoint_id" { type = string }
variable "run_id" { type = string }
variable "storage_root" { type = string }
variable "storage_pool_name" { type = string }
variable "domain_name_prefix" { type = string }
variable "vm_definitions" {
  type = map(object({
    memory = number
    vcpu = number
    disks = map(object({ path = string, backing_store = string, backing_format = string, capacity = number, target_dev = string, bus = string }))
    networks = list(object({ bridge = optional(string), network_name = optional(string), mac = optional(string) }))
  }))
}
variable "checkpoint_disks" { type = map(string) }
variable "autostart" { type = bool }
variable "start_domains" { type = bool }
variable "connection_timeout" { type = number }
variable "tags" { type = map(string) }

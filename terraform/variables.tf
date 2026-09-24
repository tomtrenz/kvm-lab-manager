variable "libvirt_uri" { type = string; sensitive = true }
variable "project_id" { type = string; validation { condition = can(regex("^[A-Za-z0-9][A-Za-z0-9_.-]{0,127}$", var.project_id)); error_message = "Invalid project_id." } }
variable "checkpoint_id" { type = string; validation { condition = can(regex("^[A-Za-z0-9][A-Za-z0-9_.-]{0,127}$", var.checkpoint_id)); error_message = "Invalid checkpoint_id." } }
variable "run_id" { type = string; validation { condition = can(regex("^[A-Za-z0-9][A-Za-z0-9_.-]{0,127}$", var.run_id)); error_message = "Invalid run_id." } }
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
variable "checkpoint_disks" { type = map(string); default = {} }
variable "autostart" { type = bool; default = false }
variable "start_domains" { type = bool; default = false }
variable "connection_timeout" { type = number }
variable "tags" { type = map(string); default = {} }

output "working_pool" { value = libvirt_pool.working.name }
output "domains" { value = { for key, domain in libvirt_domain.vm : key => domain.name } }
output "overlay_volumes" { value = { for key, volume in libvirt_volume.overlay : key => volume.name } }

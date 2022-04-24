output "vm_web_addresses" {
  description = "The docker instance addresses on the admin interface"
  value = module.vm_web.admin_adresses
}

output "vm_media_addresses" {
  description = "The docker instance addresses on the admin interface"
  value = module.vm_media.admin_adresses
}

output "vm_internal_addresses" {
  description = "The docker instance addresses on the admin interface"
  value = module.vm_internal.admin_adresses
}
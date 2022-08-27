output "tsig-secret" {
  value = base64encode(random_password.password.result)
}
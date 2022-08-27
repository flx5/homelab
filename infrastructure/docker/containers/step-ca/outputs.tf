output "traefik_config" {
  value = templatefile("${path.module}/ingress.yml", {
    host = docker_container.step-ca.name
    fqdn = var.fqdn
  })
}

output "backup" {
  value = {
    pre =  "docker container stop ${docker_container.step-ca.name}"
    post = "docker container start ${docker_container.step-ca.name}"

    vm_folders = [ for folder in [ var.config_dir ] : folder.path if folder.backup ]
  }
}

output "root_ca" {
  value = data.tls_certificate.ca_cert.certificates[0].cert_pem
}
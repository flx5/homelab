# If DNS is blocking terraform run terraform apply --target module.bind9 to make sure the dns server is configured properly
# TODO Since this seems to be problematic (terraform fails to check the dns records when the bind9 server isn't available)
# TODO It might be better to just drop the dns provider and use "uploaded" zone files...
module "bind9" {
  providers = {
    docker = docker.web
  }

  source = "./containers/bind9"
  server_ip = var.docker_web_host
  public_domain = var.base_domain
}


provider "dns" {
  update {
    server        = var.docker_web_host
    key_name      = "home."
    key_algorithm = "hmac-sha256"
    key_secret    = module.bind9.tsig-secret
  }
}

# Internal DNS

resource "dns_a_record_set" "nas" {
  zone = "home."
  name    = "nas"
  addresses = [
    var.hypervisor_host
  ]
  ttl = 300
}

resource "dns_a_record_set" "dns_web" {
  for_each = module.web.internal_hostnames

  zone = "home."
  name    = trimsuffix(each.value, ".home")
  addresses = [
    var.docker_web_host
  ]
  ttl = 300
}

resource "dns_a_record_set" "dns_media" {
  for_each = module.media.hostnames

  zone = "home."
  # Trimming the base domain is a workaround until the services using that domain have been migrated...
  name    = trimsuffix(trimsuffix(each.value, ".home"), ".${var.base_domain}")
  addresses = [
    var.docker_media_host
  ]
  ttl = 300
}

resource "dns_a_record_set" "dns_internal" {
  for_each = module.internal.hostnames

  zone = "home."
  name    = trimsuffix(each.value, ".home")
  addresses = [
    var.docker_internal_host
  ]
  ttl = 300
}

# Split Head DNS because Speedport doesn't support hairpin nat (and I want to be able to access these services without internet!)

resource "dns_a_record_set" "dns_web_loopback" {
  for_each = module.web.hostnames

  zone    = "${var.base_domain}."
  name    = trimsuffix(each.value.url, ".${var.base_domain}")
  addresses = [
    var.docker_web_host
  ]
  ttl = 300
}

# TODO Remove once not used by services anymore...
resource "dns_a_record_set" "dns_media_nat_hairpin" {
  for_each = module.media.hostnames
  
  zone    = "${var.base_domain}."
  name    = trimsuffix(each.value, ".${var.base_domain}")
  addresses = [
    var.docker_media_host
  ]
}

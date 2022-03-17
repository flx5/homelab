variable "ssh_id" {
  type = string
}

variable "networks" {
  type = object({
    admin_network = object({
      id = string
      domain = string
    })
    internet_network = object({
      id = string
      domain = string
    })
  })
}

variable "docker_ip" {
  type = string
}
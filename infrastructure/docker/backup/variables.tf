variable "docker_host" {
  type        = string
}

variable "docker_user" {
  type        = string
}

variable "backup" {
  type = list(object({
    backup_pre = string
    backup_post = string
  }))
}
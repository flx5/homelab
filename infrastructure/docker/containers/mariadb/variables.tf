variable "network" {
  type        = string
}

variable "username" {
  type        = string
}

variable "password" {
  type = string
  sensitive   = true
}

variable "root_password" {
  type        = string
  sensitive   = true
}

variable "database" {
  type        = string
}

variable "name" {
  type        = string
}

variable "command" {
  type = list(string)
  default = null
}
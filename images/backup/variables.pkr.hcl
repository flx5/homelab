variable "password" {
  type =  string
  sensitive = true
}

variable "username" {
  type =  string
}

variable "dsa_private" {
  type =  string
  sensitive = true
}

variable "ecdsa_private" {
  type =  string
  sensitive = true
}

variable "ed25519_private" {
  type =  string
  sensitive = true
}

variable "rsa_private" {
  type =  string
  sensitive = true
}

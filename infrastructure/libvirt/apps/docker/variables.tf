variable "name" {
  type = string
}

variable "memory" {
  type = string
  default = 2048
}

variable "pool_name" {
  type = string
}

variable "ssh_id" {
  type = string
}

variable "ssh_backup_id" {
  type = string
}

variable "base_disk" {
  type = string
}

variable "domain" {
  type = string
}

variable "network" {
  type = string
}

variable "address" {
  type = string
}

variable "mac" {
  type = string
}


variable "spice_address" {
  type = string
}

variable "block_devices" {
  type = list(string)
  default = []
}

variable "data_pool_name" {
  type = string
}

variable "mounts" {
  type = list(list(string))

  default = []
}

variable "files" {
  type = list(object({
    path = string
    content = string
  }))

  default = []
}

variable "packages" {
  type = list(string)

  default = []
}

variable "pci_devices" {
  type = list(object({
    name = string
    host = object({
      bus = string
      slot = string
    })
    guest = object({
      bus = string
      slot = string
    })
  }))

  default = []
}

variable "usb_devices" {
  type = list(object({
    name = string
    guest = object({
      port = string
    })
    vendor = string
    product = string
  }))

  default = []
}

variable "use_ich9_controller" {
  type = bool
  default = false
}

variable "data_size" {
  type = number

  # Method calls (pow) are not allowed here, so set to zero.
  default = 0
}

variable "bridge" {
  type = string
  default = ""
}

variable "bridge_mac" {
  type = string
  default = ""
}
variable "key_pair" {
  type    = string
  default = "slurm"
}

variable "ubuntu_jammy_image_id" {
  type = string
  default = "b83723d6-13a0-4a9e-9e91-ca85ce10cfef"
}

variable "ubuntu_generic_image_id" {
  type = string
  default = "b83723d6-13a0-4a9e-9e91-ca85ce10cfef"
}

variable "mini_flavor_id" {
  type = string
  default = "6c315b7a-86fc-4e53-987a-529769db992d"
}

variable "slurm_flavor_id" {
  type = string
  default = "6186e4c3-3f02-4ecf-bf68-2088ad10d11b"
}

variable "compute_instances_count" {
  type = number
  default = 1
}

variable "volume_size" {
  type = number
  default = 100
}

variable "volume_type" {
  type = string
  default = "ceph"
}

variable "ipv6_external_network" {
  type = string
  default = "3f1c6c34-2be9-44b3-9f21-c3e031ab8e5c"
}

variable "quobyte_network" {
  type = string
  default = "1a6b0612-ce39-4fa1-b24b-620ccee3c103"
}

variable "slurm_subnet_cidr" {
  type = string
  default = "192.168.155.0/24"
}

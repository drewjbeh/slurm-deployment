variable "region" {
  type    = string
  default = "RegionOne"
}

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

variable "default_flavor_id" {
  type = string
  default = "736b1189-1daf-46f1-ac2c-a9661f6f2b29"
}

variable "slurm_flavor_id" {
  type = string
  default = "a696ef69-3493-4dcd-b573-75cdf58fa087"
}

variable "compute_instances_count" {
  type = number
  default = 2
}

variable "volume_size" {
  type = number
  default = 200
}

variable "volume_type" {
  type = string
  default = "ceph"
}

variable "external_network" {
  type = string
  default = "8f5b0e5e-e3bf-4b53-b680-30bc593213eb" # ID for internet network
  #default = "3f1c6c34-2be9-44b3-9f21-c3e031ab8e5c" # ID for MWN network
}

variable "quobyte_network" {
  type = string
  default = "1a6b0612-ce39-4fa1-b24b-620ccee3c103"
}

variable "slurm_subnet_cidr" {
  type = string
  default = "192.168.155.0/24"
}

variable "region" {
  type = string
  default = "RegionTwo"
}

variable "key_pair" {
  type    = string
  default = "slurm"
}

variable "ubuntu_jammy_image_id" {
  type = string
  default = "de745356-afed-483b-8726-dc329390fd4d"
}

variable "ubuntu_generic_image_id" {
  type = string
  default = "760212aa-71c9-4d78-abd9-d71c6777700d"
}

variable "mini_flavor_id" {
  type = string
  default = "0081036a-c935-4810-8044-d68b87f299db"
}

variable "slurm_flavor_id" {
  type = string
  default = "8503f7d9-7307-4429-9576-d3e58ca16024"
}

variable "compute_instances_count" {
  type = number
  default = 7
}

variable "volume_size" {
  type = number
  default = 1000
}

variable "volume_type" {
  type = string
  default = "ceph"
}

variable "ipv6_external_network" {
  type = string
  default = "1f4c65ef-dd53-4d85-b2d0-1fd1a178522c"
}

variable "slurm_subnet_cidr" {
  type = string
  default = "192.168.155.0/24"
}

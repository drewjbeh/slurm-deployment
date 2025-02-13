variable "key_pair" {
  type    = string
  default = "slurm"
}

variable "ubuntu_jammy_image_id" {
  type = string
  default = "5f5a9f1c-2666-4eeb-a58c-0339378176c2"
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

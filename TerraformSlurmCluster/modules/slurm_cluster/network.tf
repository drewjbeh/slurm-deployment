resource "openstack_networking_network_v2" "slurm_net" {
  name           = "slurm_cluster_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "slurm_subnet" {
  network_id = openstack_networking_network_v2.slurm_net.id
  cidr       = var.slurm_subnet_cidr
}

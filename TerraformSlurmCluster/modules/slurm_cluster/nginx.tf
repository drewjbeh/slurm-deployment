resource "openstack_compute_instance_v2" "nginx" {
  name            = "nginx"
  image_id        = var.os_image_id
  flavor_id       = var.default_flavor_id
  key_pair        = var.key_pair
  security_groups = [
    openstack_networking_secgroup_v2.external_access.name,
    openstack_networking_secgroup_v2.slurm_compute.name,
    openstack_networking_secgroup_v2.nginx.name
  ]

   network {
    uuid  = var.external_network
  }

  network {
    uuid  = openstack_networking_network_v2.slurm_net.id
  }

  depends_on = [openstack_networking_subnet_v2.slurm_subnet]
}

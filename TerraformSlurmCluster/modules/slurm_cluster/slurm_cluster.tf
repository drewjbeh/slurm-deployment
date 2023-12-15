resource "openstack_compute_instance_v2" "terraform-slurm-controller" {
  name            = "slurm-controller"
  image_id        = var.os_image_id
  flavor_id       = var.slurm_flavor_id
  key_pair        = var.key_pair
  security_groups = [
    openstack_networking_secgroup_v2.external_access.name,
    openstack_networking_secgroup_v2.slurm_master.name,
    openstack_networking_secgroup_v2.prometheus_node_exporter.name,
    openstack_networking_secgroup_v2.beegfs.name,
    openstack_networking_secgroup_v2.nfs_ganesha.name
  ]

  network {
    uuid = var.external_network
  }

  network {
    uuid = openstack_networking_network_v2.slurm_net.id
  }

  depends_on = [openstack_networking_subnet_v2.slurm_subnet]
}

resource "openstack_compute_instance_v2" "terraform-slurm-compute" {
  count           = var.compute_instances_count
  name            = "slurm-compute-${count.index + 1}"
  image_id        = var.os_image_id
  flavor_id       = var.slurm_flavor_id
  key_pair        = var.key_pair
  security_groups = [
    openstack_networking_secgroup_v2.external_access.name,
    openstack_networking_secgroup_v2.slurm_compute.name,
    openstack_networking_secgroup_v2.prometheus_node_exporter.name,
    openstack_networking_secgroup_v2.beegfs.name,
    openstack_networking_secgroup_v2.nfs_ganesha.name
  ]

  network {
    uuid = var.external_network
  }

  network {
    uuid = openstack_networking_network_v2.slurm_net.id
  }

  depends_on = [openstack_networking_subnet_v2.slurm_subnet]
}
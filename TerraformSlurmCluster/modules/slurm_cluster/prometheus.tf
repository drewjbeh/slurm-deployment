resource "openstack_blockstorage_volume_v3" "prometheus_bootable_volume" {
  region      = "RegionOne"
  name        = "prometheus-compute-bootable-volume"
  size        = 20
  volume_type = "ceph"
  image_id    = var.os_image_id
}

resource "openstack_compute_instance_v2" "prometheus-server" {
  name            = "prometheus-server"
  image_id        = var.os_image_id
  flavor_id       = var.default_flavor_id
  key_pair        = var.key_pair
  security_groups = [
    openstack_networking_secgroup_v2.external_access.name,
    openstack_networking_secgroup_v2.slurm_compute.name,
    openstack_networking_secgroup_v2.prometheus.name
  ]

   network {
    uuid  = var.external_network
  }

  network {
    uuid  = openstack_networking_network_v2.slurm_net.id
  }

  depends_on = [
    openstack_networking_subnet_v2.slurm_subnet,
    openstack_blockstorage_volume_v3.prometheus_bootable_volume
]

  block_device {
        uuid                  = openstack_blockstorage_volume_v3.prometheus_bootable_volume.id
        source_type           = "volume"
        boot_index            = 0
        destination_type      = "volume"
        delete_on_termination = true
      }
 }

resource "openstack_blockstorage_volume_v3" "grafana_bootable_volume" {
  region      = "RegionOne"
  name        = "prometheus-compute-bootable-volume"
  size        = 20
  volume_type = "ceph"
  image_id    = var.os_image_id
}

resource "openstack_compute_instance_v2" "grafana" {
  name            = "grafana"
  image_id        = var.os_image_id
  flavor_id       = var.default_flavor_id
  key_pair        = var.key_pair
  security_groups = [
    openstack_networking_secgroup_v2.external_access.name,
    openstack_networking_secgroup_v2.slurm_compute.name,
    openstack_networking_secgroup_v2.grafana.name,
    openstack_networking_secgroup_v2.prometheus_node_exporter.name
  ]

   network {
    uuid  = var.external_network
  }

  network {
    uuid  = openstack_networking_network_v2.slurm_net.id
  }

  depends_on = [
    openstack_networking_subnet_v2.slurm_subnet,
    openstack_blockstorage_volume_v3.grafana_bootable_volume
]

  block_device {
        uuid                  = openstack_blockstorage_volume_v3.grafana_bootable_volume.id
        source_type           = "volume"
        boot_index            = 0
        destination_type      = "volume"
        delete_on_termination = true
      }
    }


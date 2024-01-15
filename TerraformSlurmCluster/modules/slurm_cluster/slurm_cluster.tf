resource "openstack_blockstorage_volume_v3" "compute_bootable_volume" {
  region      = var.region
  name        = "slurm-compute-bootable-volume-${count.index + 1}"
  size        = 20
  volume_type = var.volume_type
  image_id    = var.os_image_id
  count       = var.compute_instances_count
}

resource "openstack_blockstorage_volume_v3" "controller_bootable_volume" {
  region      = var.region
  name        = "slurm-controller-bootable-volume"
  size        = 20
  volume_type = var.volume_type
  image_id    = var.os_image_id
}

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

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = openstack_compute_instance_v2.terraform-slurm-controller.network[0].fixed_ip_v6
      private_key = file(var.key_path)
    }
    inline = [
      "echo '127.0.0.1 slurm-controller' > /etc/hostname",
      "hostnamectl set-hostname slurm-controller",
      "systemctl restart systemd-hostnamed",
    ]
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.controller_bootable_volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  depends_on = [
    openstack_networking_subnet_v2.slurm_subnet, openstack_blockstorage_volume_v3.controller_bootable_volume
  ]
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

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = openstack_compute_instance_v2.terraform-slurm-compute[count.index].network[0].fixed_ip_v6
      private_key = file(var.key_path)
    }
    inline = [
      "echo '127.0.0.1 slurm-compute-${count.index + 1}' > /etc/hostname",
      "hostnamectl set-hostname slurm-compute-${count.index + 1}",
      "systemctl restart systemd-hostnamed"
    ]
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.compute_bootable_volume[count.index].id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  depends_on = [openstack_networking_subnet_v2.slurm_subnet, openstack_blockstorage_volume_v3.compute_bootable_volume]
}
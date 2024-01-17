resource "openstack_blockstorage_volume_v3" "compute_bootable_volume" {
  region      = "RegionOne"
  name        = "slurm-compute-bootable-volume-${count.index + 1}"
  size        = 20
  volume_type = "ceph"
  image_id    = var.os_image_id
  count       = var.compute_instances_count
}

resource "openstack_blockstorage_volume_v3" "controller_bootable_volume" {
  region      = "RegionOne"
  name        = "slurm-controller-bootable-volume"
  size        = 20
  volume_type = "ceph"
  image_id    = var.os_image_id
}

resource "openstack_compute_instance_v2" "terraform-slurm-controller" {
  name            = "slurm-controller"
  flavor_id       = var.slurm_flavor_id
  key_pair        = var.key_pair
  security_groups = [
    openstack_networking_secgroup_v2.external_access.name,
    openstack_networking_secgroup_v2.slurm_master.name,
    openstack_networking_secgroup_v2.prometheus_node_exporter.name,
    openstack_networking_secgroup_v2.beegfs.name,
  ]

  network {
    uuid = var.external_network
  }

  network {
    uuid = openstack_networking_network_v2.slurm_net.id
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.controller_bootable_volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host        = openstack_compute_instance_v2.terraform-slurm-controller.access_ip_v4
  }
    inline = [
      "echo '127.0.0.1\t' $(hostnamectl | grep -i 'static hostname:' | cut -f2- -d:) | sudo tee -a /etc/hosts"
    ]
  }

  depends_on = [openstack_networking_subnet_v2.slurm_subnet]
}

resource "openstack_compute_instance_v2" "terraform-slurm-compute" {
  count           = var.compute_instances_count
  name            = "slurm-compute-${count.index + 1}"
  flavor_id       = var.slurm_flavor_id
  key_pair        = var.key_pair
  security_groups = [
    openstack_networking_secgroup_v2.external_access.name,
    openstack_networking_secgroup_v2.slurm_compute.name,
    openstack_networking_secgroup_v2.prometheus_node_exporter.name,
    openstack_networking_secgroup_v2.beegfs.name
  ]

  network {
    uuid = var.external_network
  }

  network {
    uuid = openstack_networking_network_v2.slurm_net.id
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.compute_bootable_volume[count.index].id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.key_path)
      host = "${self.access_ip_v4}"
  }
    inline = [
      "echo '127.0.0.1\t' $(hostnamectl | grep -i 'static hostname:' | cut -f2- -d:) | sudo tee -a /etc/hosts"
    ]
  }

  depends_on = [openstack_networking_subnet_v2.slurm_subnet, openstack_blockstorage_volume_v3.compute_bootable_volume]
}


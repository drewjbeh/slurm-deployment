resource "openstack_blockstorage_volume_v3" "prometheus_bootable_volume" {
  region      = var.region
  name        = "prometheus-server-bootable-volume"
  size        = 20
  volume_type = var.volume_type
  image_id    = var.os_image_id
}

resource "openstack_blockstorage_volume_v3" "grafana_bootable_volume" {
  region      = var.region
  name        = "grafana-bootable-volume"
  size        = 20
  volume_type = var.volume_type
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
    uuid = var.external_network
  }

  network {
    uuid = openstack_networking_network_v2.slurm_net.id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "${openstack_compute_instance_v2.prometheus-server.network.0.fixed_ip_v6}"
      private_key = "${file(var.key_path)}"
    }
    inline = [
      "echo '127.0.0.1 prometheus-server' > /etc/hostname",
      "hostnamectl set-hostname prometheus-server",
      "systemctl restart systemd-hostnamed"
    ]
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.prometheus_bootable_volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  depends_on = [
    openstack_networking_subnet_v2.slurm_subnet, openstack_blockstorage_volume_v3.prometheus_bootable_volume
  ]
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
    uuid = var.external_network
  }

  network {
    uuid = openstack_networking_network_v2.slurm_net.id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "${openstack_compute_instance_v2.grafana.network.0.fixed_ip_v6}"
      private_key = "${file(var.key_path)}"
    }
    inline = [
      "echo '127.0.0.1 grafana' > /etc/hostname",
      "hostnamectl set-hostname grafana",
      "systemctl restart systemd-hostnamed"
    ]
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.grafana_bootable_volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  depends_on = [openstack_networking_subnet_v2.slurm_subnet, openstack_blockstorage_volume_v3.grafana_bootable_volume]
}

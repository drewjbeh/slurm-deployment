resource "openstack_blockstorage_volume_v3" "nginx_bootable_volume" {
  region      = "RegionOne"
  name        = "nginx-bootable-volume"
  size        = 20
  volume_type = "ceph"
  image_id    = var.os_image_id
}

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
   block_device {
    uuid                  = openstack_blockstorage_volume_v3.nginx_bootable_volume.id
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
      host        = openstack_compute_instance_v2.nginx.access_ip_v4
    }
    inline = [
      "echo '127.0.0.1\t' $(hostnamectl | grep -i 'static hostname:' | cut -f2- -d:) | sudo tee -a /etc/hosts"
    ]
  }
  
  network {
    uuid = openstack_networking_network_v2.slurm_net.id
  }

  depends_on = [openstack_networking_subnet_v2.slurm_subnet]
}

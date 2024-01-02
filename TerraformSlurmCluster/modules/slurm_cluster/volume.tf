resource "openstack_blockstorage_volume_v3" "nfs-ceph" {
  region      = var.region
  name        = "nfs-ceph"
  size        = var.volume_size
  volume_type = var.volume_type
}

resource "openstack_compute_volume_attach_v2" "nfs-ceph-attach" {
  instance_id = openstack_compute_instance_v2.terraform-slurm-controller.id
  volume_id   = openstack_blockstorage_volume_v3.nfs-ceph.id
  depends_on  = [openstack_compute_instance_v2.terraform-slurm-controller]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "${openstack_compute_instance_v2.terraform-slurm-controller.network.0.fixed_ip_v6}"
      private_key = "${file(var.key_path)}"
    }
    inline = [
      "sudo mkdir -p /mnt/ceph",
      "yes | sudo mkfs -t ext4 /dev/vdb",
      "echo '/dev/vdb   /mnt/ceph   ext4   defaults   0 2' | sudo tee -a /etc/fstab",
      "sudo mount -a"
    ]
  }
}

output "slurm-compute" {
  value = [
    for compute in openstack_compute_instance_v2.terraform-slurm-compute:
    "${compute.name}, ${element(compute.network.*.fixed_ip_v4, 1)}, ${element(compute.network.*.fixed_ip_v4, 0)}"
  ]
}

output "slurm-controller" {
  value = [join(", ", [openstack_compute_instance_v2.terraform-slurm-controller.name, openstack_compute_instance_v2.terraform-slurm-controller.network.1.fixed_ip_v4, openstack_compute_instance_v2.terraform-slurm-controller.network.0.fixed_ip_v4])]
}

output "prometheus" {
  value = [join(", ", [openstack_compute_instance_v2.prometheus-server.name, openstack_compute_instance_v2.prometheus-server.network.1.fixed_ip_v4, openstack_compute_instance_v2.prometheus-server.network.0.fixed_ip_v4])]
}

output "grafana" {
  value = [join(", ", [openstack_compute_instance_v2.grafana.name, openstack_compute_instance_v2.grafana.network.1.fixed_ip_v4, openstack_compute_instance_v2.grafana.access_ip_v4])]
}

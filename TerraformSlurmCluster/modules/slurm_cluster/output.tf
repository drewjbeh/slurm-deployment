output "compute_ip" {
  value = [
    for compute in openstack_compute_instance_v2.terraform-slurm-compute:
    "${compute.name}, ${element(compute.network.*.fixed_ip_v4, 1)}, ${element(compute.network.*.fixed_ip_v6, 0)}"
  ]
}

output "controller_ip" {
  value = join(", ", [openstack_compute_instance_v2.terraform-slurm-controller.name, openstack_compute_instance_v2.terraform-slurm-controller.network.1.fixed_ip_v4])
}

output "prometheus_ip" {
  value = join(", ", [openstack_compute_instance_v2.prometheus-server.name, openstack_compute_instance_v2.prometheus-server.network.1.fixed_ip_v4, openstack_compute_instance_v2.prometheus-server.network.fixed_ip_v6])
}

output "grafana_ip" {
  value = join(", ", [openstack_compute_instance_v2.grafana.name, openstack_compute_instance_v2.grafana.access_ip_v6])
}

# external access
resource "openstack_networking_secgroup_v2" "external_access" {
  name        = "external_access"
  description = "Allow external access"
}

resource "openstack_networking_secgroup_rule_v2" "ipv4_egress_rule" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.external_access.id
}

resource "openstack_networking_secgroup_rule_v2" "ipv6_egress_rule" {
  direction         = "egress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.external_access.id
}

resource "openstack_networking_secgroup_rule_v2" "ipv4_ingress_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.external_access.id
}

resource "openstack_networking_secgroup_rule_v2" "ipv6_ingress_rule" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.external_access.id
}

# grafana
resource "openstack_networking_secgroup_v2" "grafana" {
  name        = "grafana"
  description = "Enable access to grafana on port 3000"
}

resource "openstack_networking_secgroup_rule_v2" "grafana_ipv4_ingress_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.grafana.id
}

resource "openstack_networking_secgroup_rule_v2" "grafana_ipv6_ingress_rule" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.grafana.id
}

# nginx
resource "openstack_networking_secgroup_v2" "nginx" {
  name        = "nginx"
  description = "Open ports 80 (HTTP) and 443 (HTTPS)"
}

resource "openstack_networking_secgroup_rule_v2" "nginx_ipv4_http_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nginx.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_ipv6_http_rule" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.nginx.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_ipv4_https_ingress_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.nginx.id
}

resource "openstack_networking_secgroup_rule_v2" "nginx_ipv6_https_ingress_rule" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.nginx.id
}

resource "openstack_networking_secgroup_v2" "prometheus" {
  name = "prometheus"
  description = ""
}

resource "openstack_networking_secgroup_rule_v2" "prometheus_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol = "tcp"
  port_range_min = 9090
  port_range_max = 9090
  security_group_id = openstack_networking_secgroup_v2.prometheus.id
}

resource "openstack_networking_secgroup_rule_v2" "prometheus_ipv6_rule" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol = "tcp"
  port_range_min = 9090
  port_range_max = 9090
  security_group_id = openstack_networking_secgroup_v2.prometheus.id
}

resource "openstack_networking_secgroup_v2" "prometheus_node_exporter" {
  name = "prometheus_node_exporter"
  description = "Open port 9100 for prometheus node exporter"
}

resource "openstack_networking_secgroup_rule_v2" "prometheus_node_exporter_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.prometheus_node_exporter.id
}

resource "openstack_networking_secgroup_rule_v2" "prometheus_node_exporter_ipv6_rule" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.prometheus_node_exporter.id
}

resource "openstack_networking_secgroup_v2" "slurm_compute" {
  name = "slurm_compute"
  description = ""
}

resource "openstack_networking_secgroup_rule_v2" "slurm_compute_icmp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.slurm_compute.id
}

resource "openstack_networking_secgroup_rule_v2" "slurm_compute_tcp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.slurm_compute.id
}

resource "openstack_networking_secgroup_v2" "slurm_master" {
  name = "slurm_master"
  description = ""
}

resource "openstack_networking_secgroup_rule_v2" "slurm_master_icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.slurm_master.id
}

resource "openstack_networking_secgroup_rule_v2" "slurm_master_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.slurm_master.id
}

resource "openstack_networking_secgroup_rule_v2" "slurm_master_mysql" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.slurm_master.id
}

resource "openstack_networking_secgroup_rule_v2" "slurm_master_clurmctld" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6817
  port_range_max    = 6817
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.slurm_master.id
}

resource "openstack_networking_secgroup_rule_v2" "slurm_master_slurmbd" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6819
  port_range_max    = 6819
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.slurm_master.id
}

resource "openstack_networking_secgroup_v2" "vault" {
  name        = "vault"
  description = ""
}

resource "openstack_networking_secgroup_rule_v2" "vault_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8200
  port_range_max    = 8200
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.vault.id
}

resource "openstack_networking_secgroup_rule_v2" "vault_ipv6_rule" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 8200
  port_range_max    = 8200
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.vault.id
}

resource "openstack_networking_secgroup_v2" "beegfs" {
  name = "beegfs"
  description = "Open ports for beegfs services"
}

resource "openstack_networking_secgroup_rule_v2" "beegfs_mgmt_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8008
  port_range_max    = 8008
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.beegfs.id
}

resource "openstack_networking_secgroup_rule_v2" "beegfs_meta_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8005
  port_range_max    = 8005
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.beegfs.id
}

resource "openstack_networking_secgroup_rule_v2" "beegfs_storage_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8003
  port_range_max    = 8003
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.beegfs.id
}

resource "openstack_networking_secgroup_rule_v2" "beegfs_client_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8004
  port_range_max    = 8004
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.beegfs.id
}

resource "openstack_networking_secgroup_rule_v2" "beegfs_helperd_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8006
  port_range_max    = 8006
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.beegfs.id
}

resource "openstack_networking_secgroup_v2" "nfs_ganesha" {
  name        = "nfs-ganesha"
  description = ""
}

resource "openstack_networking_secgroup_rule_v2" "nfs_ganehsa_ipv4_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2049
  port_range_max    = 2049
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.beegfs.id
}

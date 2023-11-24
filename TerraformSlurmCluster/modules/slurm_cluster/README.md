## Overview

A helper module that is implemented to create the infrastructure for a SLURM
cluster. The module will create the following:

- SLURM controller and one or more SLURM compute nodes.
- Prometheus and Grafana for real time monitoring.
- Security groups for the cluster.
- Internal network the cluster uses to communicate.

## Usage
```terraform
module "slurm_cluster" {
  source = "./modules/slurm_cluster"

  key_pair                = var.key_pair
  compute_instances_count = var.compute_instances_count

  slurm_flavor_id   = var.slurm_flavor_id
  os_image_id       = var.ubuntu_generic_image_id
  default_flavor_id = var.mini_flavor_id

  volume_size = var.volume_size
  volume_type = var.volume_type

  external_network  = var.ipv6_external_network
  quobyte_network   = var.quobyte_network
  slurm_subnet_cidr = var.slurm_subnet_cidr
}
```

The cluster size can easily be configured through the
`compute_instances_count`, simplifying the addition or removal of nodes.

## Inputs

| Name                    | Description                                                      | Type   | Default | Required |
|-------------------------|------------------------------------------------------------------|--------|---------|----------|
| key_pair                | SSH key that will be used to login into the cluster.             | string | null    | yes      |
| compute_instances_count | Number of SLURM compute instances to create.                     | number | 5       | no       |
| slurm_flavor_id         | Openstack flavor for all SLURM VMs.                              | string | null    | yes      |
| default_flavor_id       | Openstack flavor for other VMs (e.g. prometheus, grafana etc.).  | string | null    | yes      |
| os_image_id             | Operating system to use for the VMs.                             | string | null    | yes      |
| external_network        | ID of the external network to be assigned/attached on the VMs.   | string | null    | yes      |
| quobyte_network         | ID of the `quobyte` network in order to create a shared storage. | string | null    | yes      |
| slurm_subnet_cidr       | CIDR block for the SLURM internal network.                       | string | null    | yes      |

## Outputs

| Name          | Description                                                                                                         |
|---------------|---------------------------------------------------------------------------------------------------------------------|
| compute_ip    | An array of SLURM compute nodes IP values. Each item contains the name of the instance, external IP and internal IP |
| controller_ip | A comma separated string that contains controller instance name, external IP and internal IP                        |
| prometheus_ip | A comma separated string that contains prometheus instance name, external IP and internal IP                        |
| grafana_ip    | A comma separated string that contains grafana instance name, external IP and internal IP                           |

### Output Usage
The purpose of the output is to display a summary of the created instances 
and to dynamically parse the output to generate the ansible inventory. Below 
is a sample output after executing `terraform apply`:
```shell
slurm_cluster = {
  "grafana" = [
    "grafana, 192.168.155.158, [2001:7c0:801:281:f816:3eff:fe07:dfe7]",
  ]
  "prometheus" = [
    "prometheus-server, 192.168.155.201, [2001:7c0:801:281:f816:3eff:fe16:b67a]",
  ]
  "slurm-compute" = [
    "slurm-compute-1, 192.168.155.194, [2001:7c0:801:281:f816:3eff:fe76:3bc0]",
  ]
  "slurm-controller" = [
    "slurm-controller, 192.168.155.204, [2001:7c0:801:281:f816:3eff:fefc:58a3]",
  ]
}
```
The output can be displayed as json by executing the command `terraform 
output -json`, giving the following `json` output:
```json
{
  "slurm_cluster": {
    "sensitive": false,
    "type": "omitted for brevity",
    "value": {
      "grafana": [
        "grafana, 192.168.155.41, [2001:7c0:801:281:f816:3eff:fe35:26e8]"
      ],
      "prometheus": [
        "prometheus-server, 192.168.155.53, [2001:7c0:801:281:f816:3eff:fea4:c36e]"
      ],
      "slurm-compute": [
        "slurm-compute-1, 192.168.155.212, [2001:7c0:801:281:f816:3eff:fe49:7d0f]",
        "slurm-compute-2, 192.168.155.162, [2001:7c0:801:281:f816:3eff:fee4:8dfa]",
        "slurm-compute-3, 192.168.155.248, [2001:7c0:801:281:f816:3eff:fec9:467e]",
        "slurm-compute-4, 192.168.155.107, [2001:7c0:801:281:f816:3eff:fe13:aa1a]",
        "slurm-compute-5, 192.168.155.9, [2001:7c0:801:281:f816:3eff:fe59:4b59]"
      ],
      "slurm-controller": [
        "slurm-controller, 192.168.155.189, [2001:7c0:801:281:f816:3eff:fe91:aa5e]"
      ]
    }
  }
}
```
The `json` output can then be parsed to create the ansible inventory.

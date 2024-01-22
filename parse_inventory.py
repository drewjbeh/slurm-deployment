import json
import os
import shutil

import yaml

controller_ipv4 = ""
prometheus_port = 9090
prometheus_url = ""

python_interpreter = "/usr/bin/python3"
ssh_key_path = "~/.ssh/slurm"
controller_name = "slurm-controller"
node_exporter_port = "9100"

hosts = {"all": {
    "hosts": {

    },
    "children": {

    }
}}

with open("inventory.json", "r") as json_file:
    inventory = json.load(json_file)

values = inventory["slurm_cluster"]["value"]
for key, value in values.items():
    for item in value:
        items = item.split(",")
        name = items[0]
        ipv4 = items[1]
        ipv6 = items[2]
        ansible_host = f"ansible_host: {ipv6.replace('[', '').replace(']', '')}"
        ansible_hostname = f"ansible_hostname: {name}"
        ansible_host_v4 = f"ansible_host_v4: {ipv4}"
        hosts["all"]["hosts"][name] = ""
        if key not in hosts["all"]["children"]:
            hosts["all"]["children"][key] = {"hosts": {}}
        hosts["all"]["children"][key]["hosts"][name] = ""

        host_path = f"inventory{os.sep}host_vars{os.sep}{name}"
        os.makedirs(host_path, exist_ok=True)
        with open(f"{host_path}{os.sep}vars.yml", "w") as file:
            file.write(f"---\n{ansible_host}\n{ansible_hostname}\n{ansible_host_v4}")
        if "prometheus" in item:
            prometheus_url = f"http://{ipv6.strip()}:{prometheus_port}"
        if "controller" in item:
            controller_ipv4 = ipv4.strip()

# add slurm-cluster group to include all compute and controller nodes
hosts["all"]["children"]["slurm-cluster"] = {"hosts": {}}
for compute in hosts["all"]["children"]["slurm-compute"]["hosts"]:
    hosts["all"]["children"]["slurm-cluster"]["hosts"][compute] = ""
for controller in hosts["all"]["children"]["slurm-controller"]["hosts"]:
    hosts["all"]["children"]["slurm-cluster"]["hosts"][controller] = ""

group_vars_dir = f"inventory{os.sep}group_vars"
os.makedirs(group_vars_dir)
os.makedirs(f"{group_vars_dir}{os.sep}all")
os.makedirs(f"{group_vars_dir}{os.sep}slurm-compute")
os.makedirs(f"{group_vars_dir}{os.sep}slurm-cluster")

all_content = f"""---
ansible_python_interpreter: {python_interpreter}
ansible_ssh_private_key_file: {ssh_key_path}
slurm_controller_name: {controller_name}
slurm_controller_ip: {controller_ipv4}
node_exporter_port: 9100
prometheus_url: {prometheus_url}
"""

slurm_cluster_content = f"""---
cgroup_conf: "{{{{ ansible_inventory_sources | first }}}}/group_vars/slurm-cluster/cgroup.conf"
slurm_conf: "{{{{ ansible_inventory_sources | first }}}}/group_vars/slurm-cluster/slurm.conf.j2"
"""

shutil.copy("confs/cgroup.conf", "inventory/group_vars/slurm-cluster")
shutil.copy("confs/slurm.conf.j2", "inventory/group_vars/slurm-cluster")
shutil.copy("confs/slurm-compute.yml.j2", "inventory/group_vars/slurm-compute")

with open(f"inventory{os.sep}hosts.yml", "w") as file:
    yaml.safe_dump(hosts, file, default_style=None)

with open(f"{group_vars_dir}{os.sep}all{os.sep}all.yml", "w") as f:
    f.write(all_content)

with open(f"{group_vars_dir}{os.sep}slurm-cluster{os.sep}slurm-cluster.yml", "w") as f:
    f.write(slurm_cluster_content)
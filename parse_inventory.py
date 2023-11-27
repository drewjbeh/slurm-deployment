import json
import os

import yaml

controller_ipv4 = ""
prometheus_port = 9090
prometheus_url = ""

slurm_compute_cpus = 28
slurm_compute_boards = 1
slurm_compute_sockets = 28
slurm_compute_threads = 1
slurm_real_memory = 64313

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

group_vars_dir = f"inventory{os.sep}group_vars"
os.makedirs(group_vars_dir)
os.makedirs(f"{group_vars_dir}{os.sep}all")
os.makedirs(f"{group_vars_dir}{os.sep}slurm-compute")

all_content = f"""---
ansible_python_interpreter: {python_interpreter}
ansible_ssh_private_key_file: {ssh_key_path}
slurm_controller_name: {controller_name}
slurm_controller_ip: {controller_ipv4}
node_exporter_port: 9100
prometheus_url: {prometheus_url}
"""

slurm_compute_content = f"""---
cpus: {slurm_compute_cpus}
boards: {slurm_compute_boards}
sockets_per_board: {slurm_compute_sockets}
threads_per_core: {slurm_compute_threads}
real_memory: {slurm_real_memory}
"""

with open(f"inventory{os.sep}hosts.yml", "w") as file:
    yaml.safe_dump(hosts, file, default_style=None)

with open(f"{group_vars_dir}{os.sep}all{os.sep}all.yml", "w") as f:
    f.write(all_content)

with open(f"{group_vars_dir}{os.sep}slurm-compute{os.sep}slurm-compute.yml", "w") as f:
    f.write(slurm_compute_content)

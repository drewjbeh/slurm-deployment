import concurrent.futures
import os
import subprocess
import time
from pathlib import Path


def get_ansible_command(playbook_path, inventory_path):
    return [
        "ansible-playbook",
        playbook_path,
        "-i", inventory_path
    ]


def run_playbook(command, working_directory, log_filename):
    try:
        log_file = open(log_filename, "w")
        process = subprocess.Popen(
            command,
            cwd=working_directory,
            stdout=log_file,
            stderr=log_file,
            universal_newlines=True
        )
        process.wait()
        return_code = process.returncode
        log_file.close()

        print(f"Playbook {command[1]} Return Code:", return_code)

        return return_code
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return 1  # Return a non-zero value in case of an error


def run_terraform(command):
    try:
        log_file = open("terraform_logs.txt", "a")
        process = subprocess.Popen(
            command,
            stdout=log_file,
            stderr=log_file,
            universal_newlines=True
        )
        process.wait()
        return_code = process.returncode
        log_file.close()
        print(f"{command} executed properly.")
        return return_code

    except Exception as e:
        print(f"An error occurred: {e}")
        return 1


base_path = "/home/ubuntu/SlurmDeployment"
terraform_working_directory = f"{base_path}/TerraformSlurmCluster"

ansible_working_directory = f"{base_path}/AnsibleSlurmCluster"
ansible_logs_directory = f"{base_path}/ansible_logs"
playbooks_directory = f"{ansible_working_directory}/playbooks"
inventory_path = f"{ansible_working_directory}/inventory"

terraform_commands = [
    f"terraform -chdir={terraform_working_directory} init",
    f"terraform -chdir={terraform_working_directory} apply --auto-approve",
    f"terraform -chdir={terraform_working_directory} output -json > inventory.json",
    "python3 parse_inventory.py",
    f"rm -rf {inventory_path}",
    f"mv ./inventory {ansible_working_directory}/"
]

terraform_start = time.time()
for command in terraform_commands:
    try:
        print(command)
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {command}")
        print(e)
    except Exception as e:
        print(f"An error occurred: {e}")

terraform_end = time.time()
print(f"Terraform took {terraform_end - terraform_start} to finish")

print("Create ansible_logs directory")
Path(ansible_logs_directory).mkdir(parents=True, exist_ok=True)

common_path = f"{playbooks_directory}/common.yml"
monitoring_path = f"{playbooks_directory}/monitoring.yml"
compute_nodes_path = f"{playbooks_directory}/compute_nodes.yml"
controller_path = f"{playbooks_directory}/controller.yml"
build_singularity_path = f"{playbooks_directory}/singularity.yml"
munge = f"{playbooks_directory}/restart_munge.yml"

common_command = get_ansible_command(common_path, inventory_path)
monitoring_command = get_ansible_command(monitoring_path, inventory_path)
compute_nodes_command = get_ansible_command(compute_nodes_path, inventory_path)
controller_command = get_ansible_command(controller_path, inventory_path)
build_singularity_command = get_ansible_command(build_singularity_path, inventory_path)
munge_command = get_ansible_command(munge, inventory_path)

# wait for the VMs to be up and running
print("Wait for VMs to be up and running...")
time.sleep(120)

ansible_start = time.time()

print("Running common.yml playbook")
common_return_code = run_playbook(common_command, ansible_working_directory, f"{ansible_logs_directory}/common.txt")

if common_return_code == 0:
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as executor:
        print("Running monitoring.yml, compute_nodes.yml, controller.yml and singularity.yml concurrently")
        monitoring_future = executor.submit(run_playbook, monitoring_command, ansible_working_directory,
                                            f"{ansible_logs_directory}/monitoring.txt")
        compute_nodes_future = executor.submit(run_playbook, compute_nodes_command, ansible_working_directory,
                                               f"{ansible_logs_directory}/compute_nodes.txt")
        controller_future = executor.submit(run_playbook, controller_command, ansible_working_directory,
                                            f"{ansible_logs_directory}/controller.txt")
        build_singularity_future = executor.submit(run_playbook, build_singularity_command, ansible_working_directory,
                                                   f"{ansible_logs_directory}/singularity.txt")
        # Wait for tasks to complete
        concurrent.futures.wait([monitoring_future, compute_nodes_future, controller_future],
                                return_when=concurrent.futures.ALL_COMPLETED)

    print("Running restart_munge.yml playbook")
    munge_return_code = run_playbook(munge_command, ansible_working_directory, f"{ansible_logs_directory}/restart_munge.txt")

    if munge_return_code == 0:
        print("Munge playbook has finished successfully.")
    else:
        print("Munge playbook did not finish successfully.")
else:
    print(f"common.yml didn't execute successfully, had a return code {common_return_code}")

ansible_end = time.time()
print(f"Ansible took {ansible_end - ansible_start} to finish")

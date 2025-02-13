import concurrent.futures
import subprocess
import time
from pathlib import Path

from constants import INVENTORY_PATH, ANSIBLE_WORKING_DIRECTORY, ANSIBLE_LOGS_DIRECTORY, PLAYBOOKS_DIRECTORY

inventory_commands = [
    "python3 parse_inventory.py",
    f"rm -rf {INVENTORY_PATH}",
    f"mv ./inventory {ANSIBLE_WORKING_DIRECTORY}/"
]


def get_ansible_command(playbook_name):
    playbook_path = f"{PLAYBOOKS_DIRECTORY}/{playbook_name}"
    return ["ansible-playbook", playbook_path, "-i", INVENTORY_PATH]


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
        log_file.close()
        print(f"Playbook {command[1]} Return Code:", process.returncode)

        return process.returncode
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return 1


[subprocess.run(item, shell=True, check=True) for item in inventory_commands]

print("Create ansible_logs directory")
Path(ANSIBLE_LOGS_DIRECTORY).mkdir(parents=True, exist_ok=True)

commands = {
    "common": get_ansible_command("common.yml"),
    "monitoring": get_ansible_command("monitoring.yml"),
    "compute": get_ansible_command("compute_nodes.yml"),
    "controller": get_ansible_command("controller.yml"),
    "singularity": get_ansible_command("singularity.yml"),
    "munge": get_ansible_command("restart_munge.yml"),
    "mount": get_ansible_command("mount.yml")
}

# wait for the VMs to be up and running
print("Wait for VMs to be up and running...")
time.sleep(30)

ansible_start = time.time()

print("Running common.yml playbook")
common_return_code = run_playbook(commands["common"], ANSIBLE_WORKING_DIRECTORY, f"{ANSIBLE_LOGS_DIRECTORY}/common.txt")

if common_return_code == 0:
    with concurrent.futures.ThreadPoolExecutor(max_workers=8) as executor:
        print("Running monitoring.yml, compute_nodes.yml, controller.yml and singularity.yml concurrently")
        futures = {
            name: executor.submit(run_playbook, cmd, ANSIBLE_WORKING_DIRECTORY, f"{ANSIBLE_LOGS_DIRECTORY}/{name}.txt")
            for name, cmd in commands.items() if name not in ["common", "munge", "mount"]}
        concurrent.futures.wait(futures.values(), return_when=concurrent.futures.ALL_COMPLETED)

    print("Running restart_munge.yml playbook")
    run_playbook(commands["munge"], ANSIBLE_WORKING_DIRECTORY, f"{ANSIBLE_LOGS_DIRECTORY}/restart_munge.txt")
    print("Running mount.yml playbook")
    run_playbook(commands["mount.yml"], ANSIBLE_WORKING_DIRECTORY, f"{ANSIBLE_LOGS_DIRECTORY}/mount.txt")

ansible_end = time.time()
print(f"Ansible took {ansible_end - ansible_start} to finish")

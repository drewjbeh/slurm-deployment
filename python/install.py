import subprocess
import sys


def run_commands(commands):
    for command in commands:
        run_command(command)


def run_command(command):
    try:
        subprocess.run(command, shell=True, check=True, text=True)
        print(f"✅ Successfully ran: {command}")
    except subprocess.CalledProcessError as e:
        print(f"❌ Error executing: {command}\n{e}")
        sys.exit(1)


def get_distro_codename():
    return subprocess.check_output(["lsb_release", "-cs"], text=True).strip()


install_terraform_commands = [
    "sudo apt-get update && sudo apt-get install -y gnupg software-properties-common",
    "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null",
    f"echo 'deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com {get_distro_codename()} main' | sudo tee /etc/apt/sources.list.d/hashicorp.list",
    "sudo apt update -y",
    "sudo apt install terraform"
]

install_ansible_commands = [
    "sudo apt update",
    "sudo apt install software-properties-common",
    "sudo add-apt-repository --yes --update ppa:ansible/ansible",
    "sudo apt install -y ansible"
]

run_commands(install_terraform_commands)
run_commands(install_ansible_commands)

import subprocess
import time

from constants import TERRAFORM_WORKING_DIRECTORY

terraform_commands = [
    f"terraform -chdir={TERRAFORM_WORKING_DIRECTORY} init",
    f"terraform -chdir={TERRAFORM_WORKING_DIRECTORY} apply --auto-approve",
    f"terraform -chdir={TERRAFORM_WORKING_DIRECTORY} output -json > inventory.json",
]

terraform_start = time.time()
for command in terraform_commands:
    try:
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {command}\n{e}")
    except Exception as e:
        print(f"An error occurred: {e}")

terraform_end = time.time()
print(f"Terraform took {terraform_end - terraform_start} to finish")

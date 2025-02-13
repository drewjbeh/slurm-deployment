import subprocess
import sys


def run_script(script_name):
    try:
        subprocess.run([sys.executable, script_name], check=True)
        print(f"✅ Successfully ran {script_name}")
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to run {script_name}: {e}")
        sys.exit(1)


if __name__ == "__main__":
    scripts = ["install.py", "run_terraform.py", "run_ansible.py"]

    for script in scripts:
        run_script(script)

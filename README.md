### Prerequisites

Below are the resources that need to be available out of the box in order to have a SLURM workflow up and running from scratch:

- de.NBI project with proper resource allocation.
- `controller` server with proper configuration to run ansible and terraform from.
- Authentication token (can be generated through the Openstack dashboard)
- Quobyte volume (cannot be automated, must be created manually)

A deployment  server must exist with the proper environment setup:

- Terraform
- Ansible
- Python3

The infrastructure and configuration will be performed through the deployment node. Executing the commands below is all that's needed to deploy a newly created slurm cluster:
```
mkdir SlurmDeployment
cd SlurmDeployment
git init
git pull https://github.com/MChehab94/slurm-deployment
python3 setup_environment.py
```
> `TerraformSlurmCluster/provider.tf ` must be edited first to authenticate with Openstack. Make sure to populate the provider  block:
>```
> provider "openstack" {
>  user_name                     = "USERNAME"
>  tenant_name                   = "PROJECT_NAME"
>  application_credential_secret = "APPLICATION_CREDENTIAL_SECRET"
>  application_credential_id     = "APPLICATION_CREDENTIAL_ID"
>  auth_url                      = "OPENSTACK_AUTH_URL"
>  region                        = "REGION"
>  insecure                      = true
>}
> ```

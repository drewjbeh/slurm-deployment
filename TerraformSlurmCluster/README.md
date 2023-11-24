## Overview
Terraform implementation to create the basic infrastructure required to 
deploy a SLURM cluster using the `slurm_cluster` module.

## Implementation
### Provider
```terraform
...
provider "openstack" {
  user_name                     = "USERNAME"
  tenant_name                   = "PROJECT_NAME"
  application_credential_secret = "SECRET"
  application_credential_id     = "SECRET_ID"
  auth_url                      = "AUTH_URL"
  region                        = "REGION"
  insecure                      = true
}
```
The above block is required in order to connect `terraform` with the 
Openstack project. The most important parameters:
- `application_credential_secret`: A secret generated from the Openstack 
  dashboard. Note that the secret is tied directly to the project.
- `application_credential_id`: Id of the created secret.

> Hard coding the secrets might not be the ideal approach. There are two 
> options that can be used:
> - Using `env` variables
> - Using vault and retrieving the secrets through the vault

### Vault
Below is a sample snippet to integrate vault and retrieve the secrets.
```terraform
data "vault_generic_secret" "terraform_secrets" {
  path = "secrets/terraform"
}

provider "vault" {
  address         = var.vault_address
  token           = var.vault_token
  skip_tls_verify = true
}

provider "openstack" {
  user_name                     = data.vault_generic_secret.terraform_secrets.data["user_name"]
  tenant_name                   = data.vault_generic_secret.terraform_secrets.data["tenant_name"]
  application_credential_secret = data.vault_generic_secret.terraform_secrets.data["application_credential_secret"]
  application_credential_id     = data.vault_generic_secret.terraform_secrets.data["application_credential_id"]
  auth_url                      = data.vault_generic_secret.terraform_secrets.data["auth_url"]
  region                        = data.vault_generic_secret.terraform_secrets.data["region"]
}
```


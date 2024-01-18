terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51.1"
    }
  }
}

provider "openstack" {
  user_name                     = "USERNAME"
  tenant_name                   = "TENANT"
  application_credential_secret = "APPLICATION_CREDENTIAL_SECRET"
  application_credential_id     = "APPLICATION_CREDENTIAL_ID"
  auth_url                      = "AUTH_URL"
  region                        = "REGION"
  insecure                      = true
}

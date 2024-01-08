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
  user_name                     = "di93mih"
  tenant_name                   = "di93mih"
  application_credential_secret = "04QZ8GfklRv6LwXlU4aChpCzwIFGIYuArC3NjZ16UQb9zp0Cmwbl5Jvl2uAWPBeirt04UN4gzeMKi6oNjM-YFQ"
  application_credential_id     = "cd6d711729664b05a69c1f80fc5db973"
  auth_url                      = "https://cc.lrz.de:5000"
  region                        = "RegionOne"
  insecure                      = true
}

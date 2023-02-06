terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.6.1"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 0.2.4"
    }
  }

  cloud {
    organization = "CLAMS23"

    workspaces {
      name = "BRKDCN-2673-Demo"
    }
  }
}

locals {
  model = yamldecode(data.utils_yaml_merge.model.output)
}

data "utils_yaml_merge" "model" {
  input = [for file in fileset(path.module, "data/*.yaml") : file(file)]
}

module "tenant" {
  source  = "netascode/nac-tenant/aci"
  version = "0.4.2"

  for_each    = { for tenant in try(local.model.apic.tenants, []) : tenant.name => tenant }
  model       = local.model
  tenant_name = each.value.name
}

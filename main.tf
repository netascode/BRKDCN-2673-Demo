terraform {
  cloud {
    organization = "CiscoLive"

    workspaces {
      name = "BRKDCN-2673-Demo"
    }
  }
}

module "aci" {
  source  = "netascode/nac-aci/aci"
  version = "1.0.1"

  yaml_directories          = ["data"]
  manage_tenants            = true
  write_default_values_file = "defaults.yaml"
}

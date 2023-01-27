terraform {
  required_version = ">= 1.3"
  cloud {
    organization = "lhtran"

    workspaces {
      name = "lhtran-oci-infrastructure"
    }
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.96.0"
    }
  }
}


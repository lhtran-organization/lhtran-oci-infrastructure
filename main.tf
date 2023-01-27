module "core_vcn" {
  source = "./core_vcn"

  compartment_id = var.compartment_id
  vcn_name       = var.vcn_name
  vcn_cidrs      = var.vcn_cidrs
  vcn_dns_label  = var.vcn_dns_label
  env            = var.env
}


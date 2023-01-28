module "core_vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = ">= 3.5.1"
  
  compartment_id = var.compartment_id
  vcn_name = var.vcn_name
  label_prefix = var.vcn_dns_label
  vcn_dns_label = var.vcn_dns_label
  vcn_cidrs = var.vcn_cidrs
  create_internet_gateway = true
  freeform_tags   = {
    "env" = "${var.env}"
    "module": "oracle-terraform-modules/vcn/oci"
    "terraformed": "Please do not edit manually"
  }
}
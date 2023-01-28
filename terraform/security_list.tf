resource "oci_core_security_list" "lhtran_vcn_sl" {
  display_name   = "lhtran_vcn_default_security_list"
  compartment_id = var.compartment_id
  vcn_id         = module.core_vcn.vcn_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  dynamic "ingress_security_rules" {
    for_each = var.home_vpn_cidrs
    content {
      source   = ingress_security_rules.value
      protocol = "all"
    }
  }

  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "17"
    udp_options {
      max = 51821
      min = 51821
    }
  }

  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6"
    tcp_options {
      max = 22
      min = 22
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.vcn_cidrs
    content {
      source   = ingress_security_rules.value
      protocol = "all"
    }
  }

  freeform_tags = {
    "env" = "${var.env}"
    "module" : "oracle-terraform-modules/vcn/oci"
    "terraformed" : "Please do not edit manually"
  }
}
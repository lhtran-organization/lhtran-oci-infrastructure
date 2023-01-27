data "oci_core_dhcp_options" "dhcp_options" {

  compartment_id = var.compartment_id
  vcn_id         = module.core_vcn.vcn_id
}

locals {
  dhcp_default_options = data.oci_core_dhcp_options.dhcp_options.options.0.id
}

resource "oci_core_subnet" "vcn_subnet" {
  for_each       = var.subnets
  cidr_block     = each.value.cidr_block
  compartment_id = var.compartment_id
  vcn_id         = module.core_vcn.vcn_id


  #defined_tags    = var.defined_tags
  dhcp_options_id = local.dhcp_default_options
  display_name    = lookup(each.value, "name", each.key)
  dns_label       = lookup(each.value, "dns_label", null)
  freeform_tags = {
    "env" = "${var.env}"
    "terraformed" : "Please do not edit manually"
  }
  #commented for IPV6 support
  #ipv6cidr_block             = var.enable_ipv6 == false ? null : each.value.ipv6cidr_block
  #ipv6cidr_blocks            = var.enable_ipv6 == false ? null : [each.value.ipv6cidr_block]
  #prohibit_internet_ingress  = var.enable_ipv6 && lookup(each.value,"type","public") == "public" ? each.value.prohibit_internet_ingress : false
  prohibit_public_ip_on_vnic = lookup(each.value, "type", "public") == "public" ? false : true
  route_table_id             = lookup(each.value, "type", "public") == "public" ? module.core_vcn.ig_route_id : module.core_vcn.nat_route_id
  security_list_ids          = [oci_core_security_list.lhtran_vcn_sl.id]
}
data "oci_core_private_ips" "ocipl_rt_wireguard" {
  vnic_id = module.wg_instance.vnic_attachment_all_attributes.0.vnic_attachments[0].vnic_id
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = data.oci_core_vcns.lhtran_vcn.virtual_networks[0].id

  display_name = "public-routetable"
  freeform_tags = {
    "env" = "${var.env}"
    "module" : "oracle-terraform-modules/vcn/oci"
    "terraformed" : "Please do not edit manually"
  }

  route_rules {
    network_entity_id = module.core_vcn.internet_gateway_id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }

  dynamic "route_rules" {
    for_each = var.home_vpn_cidrs
    content {
      network_entity_id = data.oci_core_private_ips.ocipl_rt_wireguard.private_ips[0].id
      destination_type  = "CIDR_BLOCK"
      destination       = route_rules.value
    }
  }
}

resource "oci_core_route_table" "private" {
  compartment_id = var.compartment_id
  vcn_id         = data.oci_core_vcns.lhtran_vcn.virtual_networks[0].id

  display_name = "private-routetable"
  freeform_tags = {
    "env" = "${var.env}"
    "module" : "oracle-terraform-modules/vcn/oci"
    "terraformed" : "Please do not edit manually"
  }

  dynamic "route_rules" {
    for_each = var.home_vpn_cidrs
    content {
      network_entity_id = data.oci_core_private_ips.ocipl_rt_wireguard.private_ips[0].id
      destination_type  = "CIDR_BLOCK"
      destination       = route_rules.value
    }
  }
}
data "oci_core_vcns" "lhtran_vcn" {
  compartment_id = var.compartment_id
  display_name   = format("%s-%s", var.vcn_dns_label, var.vcn_name)
}

data "oci_core_subnets" "public_subnets" {
  compartment_id = var.compartment_id
  vcn_id         = data.oci_core_vcns.lhtran_vcn.virtual_networks[0].id
}

data "oci_core_images" "ubuntu_aarch64" {
  compartment_id           = var.compartment_id
  operating_system         = var.os_name
  operating_system_version = var.os_version
  shape                    = var.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

module "wg_instance" {
  source                      = "oracle-terraform-modules/compute-instance/oci"
  version                     = ">=2.4"
  instance_count              = 1 # how many instances do you want?
  ad_number                   = 2 # AD number to provision instances. If null, instances are provisionned in a rolling manner starting with AD1
  compartment_ocid            = var.compartment_id
  instance_display_name       = "ocipl-rt-wireguard"
  skip_source_dest_check      = true
  source_ocid                 = data.oci_core_images.ubuntu_aarch64.images[0].id
  subnet_ocids                = [for i in data.oci_core_subnets.public_subnets.subnets : i.id if startswith(i.display_name, "public")]
  public_ip                   = "RESERVED"
  ssh_public_keys             = var.ssh_public_key
  boot_volume_size_in_gbs     = var.boot_volume_size_in_gbs
  shape                       = var.shape
  instance_flex_ocpus         = var.shape_ocpus
  instance_flex_memory_in_gbs = var.shape_memory
  freeform_tags = {
    "env" = "${var.env}"
    "module" : "oracle-terraform-modules/compute-instance/oci"
    "terraformed" : "Please do not edit manually"
  }
}

output "instance_public_ip" {
  value = module.wg_instance.public_ip[0]
}
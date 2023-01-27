variable "tenancy_ocid" {
  type        = string
  description = "tenancy_ocid"
}
variable "user_ocid" {
  type        = string
  description = "user_ocid"
}
variable "fingerprint" {
  type        = string
  description = "MD5 fingerprint of the private_key"
}
variable "private_key" {
  type        = string
  description = "Private key to sign API call. Public key must be uploaded in the console."
}
variable "oci_region" {
  type        = string
  description = "Region to deploy VNC"
  validation {
    condition     = contains(["us-ashburn-1"], var.oci_region)
    error_message = "Region must be in us-ashburn-1"
  }
}
variable "compartment_id" {
  type        = string
  description = "Compartment id where to create all resources"
}
variable "vcn_name" {
  type        = string
  description = "Name of the VCN"
}
variable "vcn_dns_label" {
  type        = string
  description = "Name of the VCN DNS label"
}
variable "vcn_cidrs" {
  type        = list(string)
  description = "VCN Cidrs"
}
variable "home_vpn_cidrs" {
  type        = list(string)
  description = "VCN Cidrs"
}
variable "env" {
  type        = string
  description = "Environment"
  validation {
    condition     = contains(["production", "development", "test"], var.env)
    error_message = "Environment must be production, development or test"
  }
}
variable "subnets" {
  type        = any
  description = "Map of public and/or private subnet(s)"
}
variable "my_ip" {
  type        = string
  description = "My public IP"
}
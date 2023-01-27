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
variable "env" {
  type        = string
  description = "Environment"
  validation {
    condition     = contains(["production", "development", "test"], var.env)
    error_message = "Environment must be production, development or test"
  }
}
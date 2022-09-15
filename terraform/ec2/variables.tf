variable "cidr_vpc" {
  default     = "10.90.0.0/16"
  description = "This is default cidr"

}

locals {
  subnets = {
    public = {
      a = cidrsubnet(var.cidr_vpc, 8, 1)
      b = cidrsubnet(var.cidr_vpc, 8, 2)
      c = cidrsubnet(var.cidr_vpc, 8, 3)
    }
  }
}
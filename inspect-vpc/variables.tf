
############ Set Variables Do Not Change ##################
variable "region" {
  description = "AWS Region to target"
  type        = string
  default     = "us-east-1"
}

variable "account_name" {
  description = "Default Account name"
  type        = string
  default     = "Networking"
}

variable "tags" {
  description = "Tags"
  type        = map(any)
  default = {
    Owner = "Your Name"
  }
}
############ Your Project Variables ##################
variable "vpc_cidr" {
  description = "Default VPC CIDR"
  type        = string
  default     = "100.64.0.0/16"
}

variable "env" {
  description = "Default Environment"
  type        = string
  default     = "NFW"
}

variable "project" {
  description = "Default Project Name"
  type        = string
  default     = "NFW"
}

############ Global Variables ##################
variable "az" {
  description = "Avaialbility Zone Text"
  type        = list(any)
  default     = ["AZ1", "AZ2", "AZ3"]
}

variable "tier" {
  description = "Tiers"
  type        = list(any)
  default     = ["NFW", "TGW"]
}

variable "availability_zones" {
  description = "Avaialbility Zones"
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "zone_ids" {
  description = "zone ids maping to Avaialbility Zones" #unsed var just for info
  type        = map(any)
  default = {
    "use1-az2" = "us-east-1a"
    "use1-az4" = "us-east-1b"
    "use1-az6" = "us-east-1c"
  }
}

variable "tgw_id" {
  type    = string
  default = "tgw-0ba456f63be593fdd"
}

variable "association_default_route_table_id" {
  type    = string
  default = ""
}

variable "ingress_egress_attachment_id" {
  type    = string
  default = "tgw-attach-0595c907cedffaab7"
}


############ Set Variables Do Not Change ##################
variable "region" {
  description = "AWS Region to target"
  type        = string
  default     = "us-east-1"
}

variable "account_name" {
  description = "Default Account name"
  type        = string
  default     = "Production"
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
  default     = "10.0.0.0/16"
}

variable "env" {
  description = "Default Environment"
  type        = string
  default     = "PRD"
}

variable "project" {
  description = "Default Project Name"
  type        = string
  default     = "PRD"
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
  default     = ["APP", "DATA", "TGW"]
}

variable "availability_zones" {
  description = "Avaialbility Zones"
  type        = list(any)
  default     = ["us-east-1d", "us-east-1a", "us-east-1b"]
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
  default = "tgw-0ba456f63be593fdd" # TGW ID here
}
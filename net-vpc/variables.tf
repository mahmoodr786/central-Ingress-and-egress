
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
  default     = "10.1.0.0/16"
}

variable "env" {
  description = "Default Environment"
  type        = string
  default     = "NET"
}

variable "project" {
  description = "Default Project Name"
  type        = string
  default     = "NET"
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
  default     = ["DMZ", "WAF", "TGW", "WEB"]
}

variable "availability_zones" {
  description = "Avaialbility Zones"
  type        = list(any)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
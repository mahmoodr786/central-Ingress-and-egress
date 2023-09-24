module "subnet-addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = "dmz-az1"
      new_bits = 2
    },
    {
      name     = "dmz-az2"
      new_bits = 2
    },
    {
      name     = "dmz-az3"
      new_bits = 2
    },
    {
      name     = "tgw-az1"
      new_bits = 8
    },
    {
      name     = "tgw-az2"
      new_bits = 8
    },
    {
      name     = "tgw-az3"
      new_bits = 8
    }
  ]
}

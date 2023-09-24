module "subnet-addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = "nfw-az1"
      new_bits = 10
    },
    {
      name     = "nfw-az2"
      new_bits = 10
    },
    {
      name     = "nfw-az3"
      new_bits = 10
    },
    {
      name     = "tgw-az1"
      new_bits = 10
    },
    {
      name     = "tgw-az2"
      new_bits = 10
    },
    {
      name     = "tgw-az3"
      new_bits = 10
    }
  ]
}

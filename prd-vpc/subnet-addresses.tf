module "subnet-addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = "app-az1"
      new_bits = 2
    },
    {
      name     = "app-az2"
      new_bits = 2
    },
    {
      name     = "app-az3"
      new_bits = 2
    },
    {
      name     = "data-az1"
      new_bits = 4
    },
    {
      name     = "data-az2"
      new_bits = 4
    },
    {
      name     = "data-az3"
      new_bits = 4
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

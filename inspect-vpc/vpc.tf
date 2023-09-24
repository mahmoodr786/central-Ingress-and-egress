############ VPC #####################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}-VPC"
    },
  )
}

#################### Subnets ######################################################################################

#################### APP Subnets ########################
resource "aws_subnet" "nfw-az1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 0)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.nfw-az1

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 0)}_${element(var.az, 0)}"
    },
  )
}

resource "aws_subnet" "nfw-az2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 1)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.nfw-az2

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 0)}_${element(var.az, 1)}"
    },
  )
}

resource "aws_subnet" "nfw-az3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 2)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.nfw-az3

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 0)}_${element(var.az, 2)}"
    },
  )
}

#################### TGW Subnets ########################
resource "aws_subnet" "tgw-az1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 0)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.tgw-az1

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 1)}_${element(var.az, 0)}"
    },
  )
}

resource "aws_subnet" "tgw-az2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 1)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.tgw-az2

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 1)}_${element(var.az, 1)}"
    },
  )
}

resource "aws_subnet" "tgw-az3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 2)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.tgw-az3

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 1)}_${element(var.az, 2)}"
    },
  )
}


###################### Route Tables ##########################################
resource "aws_route_table" "tgw-az1-rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 0)}_TGW_RT"
    },
  )
}
resource "aws_route_table" "tgw-az2-rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 1)}_TGW_RT"
    },
  )
}
resource "aws_route_table" "tgw-az3-rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 2)}_TGW_RT"
    },
  )
}

resource "aws_route" "tgw-rts" {
  for_each               = { for az in aws_networkfirewall_firewall.nfw.firewall_status[0].sync_states : az.availability_zone => az }
  route_table_id         = each.value.availability_zone == "us-east-1a" ? aws_route_table.tgw-az1-rt.id : each.value.availability_zone == "us-east-1b" ? aws_route_table.tgw-az2-rt.id : aws_route_table.tgw-az3-rt.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = each.value.attachment[0].endpoint_id

}

###################### NFW Route Tables ##########################################
resource "aws_route_table" "nfw-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_NFW_RT"
    },
  )
}

##################### Subnet Association #####################
resource "aws_route_table_association" "nfw-az1-rts" {
  subnet_id      = aws_subnet.nfw-az1.id
  route_table_id = aws_route_table.nfw-rt.id
}

resource "aws_route_table_association" "nfw-az2-rts" {
  subnet_id      = aws_subnet.nfw-az2.id
  route_table_id = aws_route_table.nfw-rt.id
}

resource "aws_route_table_association" "nfw-az3-rts" {
  subnet_id      = aws_subnet.nfw-az3.id
  route_table_id = aws_route_table.nfw-rt.id
}


##################### TGW Association ########################
resource "aws_route_table_association" "tgw-az1-rts" {
  subnet_id      = aws_subnet.tgw-az1.id
  route_table_id = aws_route_table.tgw-az1-rt.id
}

resource "aws_route_table_association" "tgw-az2-rts" {
  subnet_id      = aws_subnet.tgw-az2.id
  route_table_id = aws_route_table.tgw-az2-rt.id
}

resource "aws_route_table_association" "tgw-az3-rts" {
  subnet_id      = aws_subnet.tgw-az3.id
  route_table_id = aws_route_table.tgw-az3-rt.id
}





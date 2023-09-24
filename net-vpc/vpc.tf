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


################## VPC Flow Logs ###############################
resource "aws_iam_role" "flow_logs_role" {
  name               = "${var.account_name}_${var.region}_VPC_Flow_Logs_Role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume_policy.json

  inline_policy {
    name   = "${var.account_name}_${var.region}_VPC_Flow_Logs_Policy"
    policy = data.aws_iam_policy_document.flow_logs_policy.json
  }

}

resource "aws_cloudwatch_log_group" "flow_logs_log_group" {
  name = "${var.account_name}_${var.region}_flow_logs"
}

resource "aws_flow_log" "vpc-flow_logs" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.flow_logs_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

#################### IGW ##########################################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_VPC_IGW"
    },
  )
}

#################### Subnets ######################################################################################

#################### DMZ Subnets ########################
resource "aws_subnet" "dmz-az1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 0)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.dmz-az1

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 0)}_${element(var.az, 0)}"
    },
  )
}

resource "aws_subnet" "dmz-az2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 1)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.dmz-az2

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 0)}_${element(var.az, 1)}"
    },
  )
}

resource "aws_subnet" "dmz-az3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 2)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.dmz-az3

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
      "Name" = "${var.env}_${element(var.tier, 2)}_${element(var.az, 0)}"
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
      "Name" = "${var.env}_${element(var.tier, 2)}_${element(var.az, 1)}"
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
      "Name" = "${var.env}_${element(var.tier, 2)}_${element(var.az, 2)}"
    },
  )
}

###################### NAT Gateway ###########################################

resource "aws_eip" "nat-eip-az1" {

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_NAT_GTWY_EIP_AZ1"
    },
  )
}
resource "aws_eip" "nat-eip-az2" {

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_NAT_GTWY_EIP_AZ2"
    },
  )
}
resource "aws_eip" "nat-eip-az3" {

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_NAT_GTWY_EIP_AZ3"
    },
  )
}

resource "aws_nat_gateway" "az1-nat" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat-eip-az1.id
  subnet_id     = aws_subnet.dmz-az1.id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_NAT_GTWY_AZ1"
    },
  )

}

resource "aws_nat_gateway" "az2-nat" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat-eip-az2.id
  subnet_id     = aws_subnet.dmz-az2.id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_NAT_GTWY_AZ2"
    },
  )

}

resource "aws_nat_gateway" "az3-nat" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat-eip-az3.id
  subnet_id     = aws_subnet.dmz-az3.id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_NAT_GTWY_AZ3"
    },
  )

}

###################### DMZ Route Tables ##########################################
resource "aws_route_table" "az1-dmz-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.net_tgw.id
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 0)}_DMZ_RT"
    },
  )
}
resource "aws_route_table" "az2-dmz-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.net_tgw.id
  }


  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 1)}_DMZ_RT"
    },
  )
}
resource "aws_route_table" "az3-dmz-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.net_tgw.id
  }


  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 2)}_DMZ_RT"
    },
  )
}

###################### TGW Route Tables ##########################################
resource "aws_route_table" "az1-tgw-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az1-nat.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.net_tgw.id
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 0)}_TGW_RT"
    },
  )
}
resource "aws_route_table" "az2-tgw-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az2-nat.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.net_tgw.id
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 1)}_TGW_RT"
    },
  )
}
resource "aws_route_table" "az3-tgw-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az3-nat.id
  }
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.net_tgw.id
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 2)}_TGW_RT"
    },
  )
}

##################### DMZ Association ########################
resource "aws_route_table_association" "dmz-az1-rts" {
  subnet_id      = aws_subnet.dmz-az1.id
  route_table_id = aws_route_table.az1-dmz-rt.id
}

resource "aws_route_table_association" "dmz-az2-rts" {
  subnet_id      = aws_subnet.dmz-az2.id
  route_table_id = aws_route_table.az2-dmz-rt.id
}

resource "aws_route_table_association" "dmz-az3-rts" {
  subnet_id      = aws_subnet.dmz-az3.id
  route_table_id = aws_route_table.az3-dmz-rt.id
}

##################### TGW Association ########################
resource "aws_route_table_association" "tgw-az1-rts" {
  subnet_id      = aws_subnet.tgw-az1.id
  route_table_id = aws_route_table.az1-tgw-rt.id
}

resource "aws_route_table_association" "tgw-az2-rts" {
  subnet_id      = aws_subnet.tgw-az2.id
  route_table_id = aws_route_table.az2-tgw-rt.id
}

resource "aws_route_table_association" "tgw-az3-rts" {
  subnet_id      = aws_subnet.tgw-az3.id
  route_table_id = aws_route_table.az3-tgw-rt.id
}











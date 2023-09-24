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

#################### Subnets ######################################################################################

#################### APP Subnets ########################
resource "aws_subnet" "app-az1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 0)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.app-az1

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 0)}_${element(var.az, 0)}"
    },
  )
}

resource "aws_subnet" "app-az2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 1)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.app-az2

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 0)}_${element(var.az, 1)}"
    },
  )
}

resource "aws_subnet" "app-az3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 2)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.app-az3

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 0)}_${element(var.az, 2)}"
    },
  )
}

#################### DATA Subnets ########################
resource "aws_subnet" "data-az1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 0)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.data-az1

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 1)}_${element(var.az, 0)}"
    },
  )
}

resource "aws_subnet" "data-az2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 1)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.data-az2

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 1)}_${element(var.az, 1)}"
    },
  )
}

resource "aws_subnet" "data-az3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, 2)
  cidr_block        = module.subnet-addrs.network_cidr_blocks.data-az3

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.tier, 1)}_${element(var.az, 2)}"
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


###################### Route Tables ##########################################
resource "aws_route_table" "az1-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 0)}_RT"
    },
  )
}
resource "aws_route_table" "az2-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 1)}_RT"
    },
  )
}
resource "aws_route_table" "az3-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_${element(var.az, 2)}_RT"
    },
  )
}


###################### TGW Route Tables ##########################################
resource "aws_route_table" "tgw-rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      "Name" = "${var.env}_TGW_RT"
    },
  )
}



##################### Subnet Association #####################
resource "aws_route_table_association" "app-az1-rts" {
  subnet_id      = aws_subnet.app-az1.id
  route_table_id = aws_route_table.az1-rt.id
}

resource "aws_route_table_association" "app-az2-rts" {
  subnet_id      = aws_subnet.app-az2.id
  route_table_id = aws_route_table.az2-rt.id
}

resource "aws_route_table_association" "app-az3-rts" {
  subnet_id      = aws_subnet.app-az3.id
  route_table_id = aws_route_table.az3-rt.id
}
resource "aws_route_table_association" "data-az1-rts" {
  subnet_id      = aws_subnet.data-az1.id
  route_table_id = aws_route_table.az1-rt.id
}

resource "aws_route_table_association" "data-az2-rts" {
  subnet_id      = aws_subnet.data-az2.id
  route_table_id = aws_route_table.az2-rt.id
}

resource "aws_route_table_association" "data-az3-rts" {
  subnet_id      = aws_subnet.data-az3.id
  route_table_id = aws_route_table.az3-rt.id
}

##################### TGW Association ########################
resource "aws_route_table_association" "tgw-az1-rts" {
  subnet_id      = aws_subnet.tgw-az1.id
  route_table_id = aws_route_table.tgw-rt.id
}

resource "aws_route_table_association" "tgw-az2-rts" {
  subnet_id      = aws_subnet.tgw-az2.id
  route_table_id = aws_route_table.tgw-rt.id
}

resource "aws_route_table_association" "tgw-az3-rts" {
  subnet_id      = aws_subnet.tgw-az3.id
  route_table_id = aws_route_table.tgw-rt.id
}











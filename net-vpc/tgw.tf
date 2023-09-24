##################### TGW ##################################
resource "aws_ec2_transit_gateway" "net_tgw" {
  description = "Networking Transit Gateway"

  auto_accept_shared_attachments = "enable"

  default_route_table_association = "enable"

  default_route_table_propagation = "enable"

  dns_support = "enable"

  vpn_ecmp_support = "enable"

  tags = merge(
    local.common_tags,
    var.tags,
    {
      Name = "${var.account_name}_TGW"
    },
  )
}

module "transit_gateway_attachment" {
  source  = "adamwshero/transit-gateway-attachment/aws"
  version = "~> 1.5.0"

  transit_gateway_attachments = {
    attachment-1 = {
      vpc_id             = aws_vpc.main.id
      transit_gateway_id = aws_ec2_transit_gateway.net_tgw.id
      subnet_ids         = [aws_subnet.tgw-az1.id, aws_subnet.tgw-az2.id, aws_subnet.tgw-az3.id]
    }
  }
  appliance_mode_support = "enable"
  tags = merge(
    local.common_tags,
    var.tags,
    {
      Name = "${var.account_name}_VPC_Attachment"
    },
  )
}









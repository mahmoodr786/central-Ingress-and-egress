module "transit_gateway_attachment" {
  source  = "adamwshero/transit-gateway-attachment/aws"
  version = "~> 1.5.0"

  transit_gateway_attachments = {
    attachment-1 = {
      vpc_id             = aws_vpc.main.id
      transit_gateway_id = var.tgw_id
      subnet_ids         = [aws_subnet.tgw-az1.id, aws_subnet.tgw-az2.id, aws_subnet.tgw-az3.id]
    }
  }
  appliance_mode_support                          = "enable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    local.common_tags,
    var.tags,
    {
      Name = "${var.env}_VPC_Attachment"
    },
  )
}

resource "aws_ec2_transit_gateway_route_table" "inspection-rt" {
  transit_gateway_id = var.tgw_id

  tags = merge(
    local.common_tags,
    var.tags,
    {
      Name = "Inspcection_RT"
    },
  )
}

resource "aws_ec2_transit_gateway_route" "static_r" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection-rt.id
  destination_cidr_block         = "0.0.0.0/0"
  blackhole                      = false
  transit_gateway_attachment_id  = var.ingress_egress_attachment_id
}

resource "aws_ec2_transit_gateway_route_table_association" "inspect-asso" {
  transit_gateway_attachment_id  = module.transit_gateway_attachment.transit_gateway_attachments.attachment-1[0].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.inspection-rt.id
}
resource "aws_ec2_transit_gateway_route" "tgw_rt" {
  transit_gateway_route_table_id = var.association_default_route_table_id
  destination_cidr_block         = "0.0.0.0/0"
  blackhole                      = false
  transit_gateway_attachment_id  = module.transit_gateway_attachment.transit_gateway_attachments.attachment-1[0].id
}
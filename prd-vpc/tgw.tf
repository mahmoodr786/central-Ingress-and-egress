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
  appliance_mode_support = "enable"
  tags = merge(
    local.common_tags,
    var.tags,
    {
      Name = "${var.account_name}_VPC_Attachment"
    },
  )
}


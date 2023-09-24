provider "aws" {
  region = "us-east-1"
}


variable "nat_gateway_ids" {
  type    = list(string)
  default = ["nat-0e3e2696152a8f51a", "nat-09c5712cbd2307b76", "nat-044bb3796e4e904c4"] ### define your NAT IDs here
}

resource "aws_sns_topic" "alerts" {
  name = "NATAlerts"
}

# Create a CloudWatch alarm for each NAT gateway
resource "aws_cloudwatch_metric_alarm" "nat_gateway_data_transfer_alarms" {
  count               = length(var.nat_gateway_ids)
  alarm_name          = "NatGatewayDataTransferAlarm-${var.nat_gateway_ids[count.index]}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "BytesOutToDestination"
  namespace           = "AWS/NATGateway"
  period              = 60 # 5 minutes
  statistic           = "Sum"
  threshold           = 10000000 # 10 MB in bytes

  alarm_description = "Alarm when NAT Gateway data transfer exceeds 10MB"

  alarm_actions = [aws_sns_topic.alerts.arn]

  dimensions = {
    NatGatewayId = var.nat_gateway_ids[count.index]
  }
}


resource "aws_sns_topic_subscription" "email_subscription" {
  count     = length(var.nat_gateway_ids)
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "youremail@example.com"
}
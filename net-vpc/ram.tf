resource "aws_ram_resource_share" "ram" {
  name                      = "Transit Gateway RAM"
  allow_external_principals = true
}
resource "aws_ram_principal_association" "ram_acc1" {
  principal          = "" #account ID here
  resource_share_arn = aws_ram_resource_share.ram.arn
}
resource "aws_ram_principal_association" "ram_acc2" {
  principal          = "" #account ID 2 here
  resource_share_arn = aws_ram_resource_share.ram.arn
}
resource "aws_ram_resource_association" "ram_ra" {
  resource_arn       = aws_ec2_transit_gateway.net_tgw.arn
  resource_share_arn = aws_ram_resource_share.ram.arn
}
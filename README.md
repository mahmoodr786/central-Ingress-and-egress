# Central Ingress and Egress using AWS Network Firewall and Transit Gateway
### Terraform code to create the stack. Read the blog 
[here](https://medium.com/@mahmood1/central-ingress-and-egress-using-aws-network-firewall-and-transit-gateway-part-1-setting-up-aws-4036020723bf) 
first.

##### Running the TF code

Go to the net-vpc folder. This will the first terraform code you will run. You will run this in your networking 
account. Update the ram.tf with the Account IDs that you will share your TGW with. Add as many as 
aws_ram_principal_association as you need.
```terraform
resource "aws_ram_principal_association" "ram_acc2" {
  principal          = "" #account ID 2 here
  resource_share_arn = aws_ram_resource_share.ram.arn
}
```
Go net-vpc
```sh
cd net-vpc
terraform init
terraform apply
```

After the net-vpc is completed. You will need to update the inspect-vpc variables with TGW ID, TGW default route 
table ID and net-vpc attachment ID. Lines 70 to 83 in variables.tf. Run this in same networking account.

```sh
cd inspect-vpc
terraform init
terraform apply
```
Finally you will run the prd-vpc in your prod account or whatever you call your account. **Note:** you will have to 
accept each RAM invitation for each account manually before running the terraform code. Copy and paste the prd-vpc 
as many times as you need and update the variables.tf 

```sh
cd prd-vpc
terraform init
terraform apply
```
That is it.


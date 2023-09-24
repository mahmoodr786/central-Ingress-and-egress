############################ Network Firewall #################################
resource "aws_networkfirewall_rule_group" "nfw_stateless_rg" {
  description = "Stateless Rate Limiting Rule"
  capacity    = 100
  name        = "Sateless-Rules"
  type        = "STATELESS"
  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {

        stateless_rule {
          priority = 1
          rule_definition {
            actions = ["aws:pass"]
            match_attributes {
              source {
                address_definition = "10.0.0.0/8"
              }
              destination {
                address_definition = "10.0.0.0/8"
              }
            }
          }
        }
      }
    }
  }

  tags = local.common_tags

}

resource "aws_networkfirewall_rule_group" "nfw_statefull_rg" {
  capacity = 100
  name     = "deny-domains"
  type     = "STATEFUL"

  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["HTTP_HOST"]
        targets              = ["example.com"]
      }
    }
  }

  tags = local.common_tags
}

resource "aws_networkfirewall_firewall_policy" "nfw-policy" {
  name        = "IDS-IPS-Policy"
  description = "Networking IDS and IPS Firewall Policy"

  firewall_policy {
    stateless_default_actions          = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:drop"]

    stateless_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.nfw_stateless_rg.arn
    }

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.nfw_statefull_rg.arn
    }
  }
}

resource "aws_networkfirewall_firewall" "nfw" {
  name = "IDS-IPS"

  subnet_mapping {
    subnet_id = aws_subnet.nfw-az1.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.nfw-az2.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.nfw-az3.id
  }

  firewall_policy_arn = aws_networkfirewall_firewall_policy.nfw-policy.arn
  vpc_id              = aws_vpc.main.id
  description         = "Networking IDS and IPS"
}
resource "yandex_vpc_security_group" "sg" {
  name        = "SGroup"
  description = "description for my security group"
  network_id  = yandex_vpc_network.vpc0.id
}

resource "yandex_vpc_security_group_rule" "http" {
  security_group_binding = yandex_vpc_security_group.sg.id
  direction              = "ingress"
  description            = "rule1"
  v4_cidr_blocks         = ["0.0.0.0/0"]
#  port                   = 80
  protocol               = "ANY"
}

resource "yandex_vpc_security_group_rule" "https" {
  security_group_binding = yandex_vpc_security_group.sg.id
  direction              = "ingress"
  description            = "rule2"
  v4_cidr_blocks         = ["0.0.0.0/0"]
#  port                   = 443
  protocol               = "ANY"
}

resource "yandex_vpc_security_group_rule" "ssh" {
  security_group_binding = yandex_vpc_security_group.sg.id
  direction              = "ingress"
  description            = "rule3"
  v4_cidr_blocks         = ["0.0.0.0/0"]
#  port                   = 22
  protocol               = "ANY"
}

resource "yandex_vpc_security_group_rule" "out" {
  security_group_binding = yandex_vpc_security_group.sg.id
  direction              = "egress"
  description            = "rule4"
  v4_cidr_blocks         = ["0.0.0.0/0"]
#  from_port              = 1
#  to_port                = 65535
  protocol               = "ANY"
}

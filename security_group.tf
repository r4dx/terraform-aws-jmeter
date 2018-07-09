resource "aws_security_group" "jmeter-sg" {
  name   = "jmeter-sg"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ingress-private-sgr" {
  type      = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  self      = true

  security_group_id = "${aws_security_group.jmeter-sg.id}"
}

resource "aws_security_group_rule" "egress-private-sgr" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  self      = true

  security_group_id = "${aws_security_group.jmeter-sg.id}"
}

resource "aws_security_group_rule" "egress-public-sgr" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.jmeter-sg.id}"
}

resource "aws_security_group_rule" "ingress-public-sgr" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.jmeter-sg.id}"
}

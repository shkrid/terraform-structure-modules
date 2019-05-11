data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.prefix}-remote-state-${var.env}"
    key    = "${var.env}/vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

module "web" {
  source         = "terraform-aws-modules/ec2-instance/aws"
  name           = "${var.prefix}-web-${var.env}"
  instance_count = "${var.instance_count}"

  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  monitoring                  = true
  vpc_security_group_ids      = ["${module.web_sg.this_security_group_id}"]
  subnet_ids                  = ["${data.terraform_remote_state.vpc.public_subnets}"]
  associate_public_ip_address = true
}

resource "aws_eip" "web" {
  count    = "${var.instance_count}"
  vpc      = true
  instance = "${module.web.id[count.index]}"
}

module "web_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.prefix}-web-sg-${var.env}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

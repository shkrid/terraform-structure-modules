provider "aws" {
  alias = "src"
}

provider "aws" {
  alias = "dst"
}

data "aws_caller_identity" "dst" {
  provider = "aws.dst"
}

data "aws_region" "dst" {
  provider = "aws.dst"
}

data "aws_route_tables" "src_rtbs" {
  provider = "aws.src"
  vpc_id   = "${var.vpc_id}"
}

data "aws_route_tables" "dst_rtbs" {
  provider = "aws.dst"
  vpc_id   = "${var.peer_vpc_id}"
}

data "aws_vpc" "src" {
  id = "${var.vpc_id}"
}

data "aws_vpc" "dst" {
  id = "${var.peer_vpc_id}"
}

resource "aws_vpc_peering_connection" "src" {
  provider = "aws.src"

  peer_owner_id = "${data.aws_caller_identity.dst.account_id}"
  peer_region   = "${data.aws_region.dst.name}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  vpc_id        = "${var.vpc_id}"
}

resource "aws_vpc_peering_connection_accepter" "dst" {
  provider = "aws.dst"

  vpc_peering_connection_id = "${aws_vpc_peering_connection.src.id}"
  auto_accept               = true
}

resource "aws_route" "src" {
  provider = "aws.src"

  count = "${length(data.aws_route_tables.src_rtbs.ids)}"

  route_table_id            = "${data.aws_route_tables.src_rtbs.ids[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.dst.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.src.id}"
}

resource "aws_route" "dst" {
  provider = "aws.dst"

  count = "${length(data.aws_route_tables.dst_rtbs.ids)}"

  route_table_id            = "${data.aws_route_tables.dst_rtbs.ids[count.index]}"
  destination_cidr_block    = "${data.aws_vpc.src.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.src.id}"
}

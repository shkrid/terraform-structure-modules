# resource "aws_s3_bucket" "rs-protected" {
#   count = "${var.prevent_destroy ? 1 : 0}"
#   # same effect
#   # count = "${var.prevent_destroy}"
#   bucket = "${var.prefix}-remote-state-${var.env}"

#   versioning {
#     enabled = true
#   }
#   force_destroy = true
#   tags {
#     Name        = "${var.prefix}-remote-state-${var.env}"
#     Environment = "${var.env}"
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }

resource "aws_s3_bucket" "rs" {
  # count = "${!var.prevent_destroy ? 1 : 0}" 
  # same effect
  # count = "${!var.prevent_destroy}"
  # count = "${1-var.prevent_destroy}"
  # count = "${var.prevent_destroy ? 0 : 1}"
  bucket = "${var.prefix}-remote-state-${var.env}"

  versioning {
    enabled = true
  }

  force_destroy = true

  tags {
    Name        = "${var.prefix}-remote-state-${var.env}"
    Environment = "${var.env}"
  }
}

resource "aws_dynamodb_table" "rs" {
  # Not working http://www.devlo.io/if-else-terraform.html
  # count = "${var.locking == true ? 1 : 0}"
  count = "${var.locking ? 1 : 0}"
  # same effect
  # count = "${var.locking}"
  name           = "${var.prefix}-remote-state-${var.env}"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name        = "${var.prefix}-remote-state-${var.env}"
    Environment = "${var.env}"
  }
}
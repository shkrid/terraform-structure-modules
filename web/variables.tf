variable "prefix" {
  default     = "prefix"
  description = "The name of our org, i.e. examplecom."
}

variable "env" {
  default     = "env"
  description = "The name of our environment, i.e. development."
}

variable "instance_count" {
  default = 1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {}
variable "key_name" {}
variable "subnet_ids" {}
variable "vpc_id" {}

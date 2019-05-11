variable "region" {
  default     = "us-east-1"
  description = "The name of the AWS region"
}

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

variable "ami" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {}

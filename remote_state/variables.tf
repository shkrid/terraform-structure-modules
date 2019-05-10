variable "prefix" {
  default     = "prefix"
  description = "The name of our org, i.e. examplecom."
}

variable "env" {
  default     = "env"
  description = "The name of our environment, i.e. development."
}

variable "locking" {
  default     = false
  description = "Use dynamodb locking"
}

variable "prevent_destroy" {
  default     = true
  description = "Protect s3 backut from deleteing by terraform"
}
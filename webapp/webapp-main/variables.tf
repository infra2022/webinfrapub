variable "project" {
  description = "The name of the current project."
  type        = string
}

variable "region" {
  type    = string
}

variable "ami" {
  type    = string
}
variable "vpc_cidr" {
  type    = string
}

variable "public_sub_cidr" {
  type    = list(string)
}
variable "private_sub_cidr" {
  type    = list(string)
}
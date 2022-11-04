variable "project" {
  description = "The name of the current project."
  type        = string
}

variable "region" {
  type    = string
}

variable "vpc_cidr" {
  type    = string
}

variable "private_subnets_cidr" {
  type    = list(string)
}

variable "public_subnets_cidr" {
  type    = list(string)
}
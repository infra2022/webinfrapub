variable "project" {
  description = "The name of the current project."
  type        = string
}

variable "allow_http_sec_grp_id" {
  type = string
}

variable "subnet_ids" {
  type = string
}

variable "vpc_id" {
  type = string
}
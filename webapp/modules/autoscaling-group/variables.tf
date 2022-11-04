variable "project" {
  description = "The name of the current project."
  type        = string
}
variable "name" {
  description = "The partial name of the ASG and LT."
  type        = string
}

variable "region" {
  type    = string
}

variable "ami" {
  type    = string
}

variable "tg_arn" {
  type    = string
}
# variable "image_id" {
#   description = "The id of the machine image (AMI) to use for the server."
#   type        = map(string)
#   default = {
#     us-east-1 = "ami-0be2609ba883822ec",
#     us-east-2 = "ami-0a0ad6b70e61be944"
#   }
# }

variable "instance_type" {
  description = "The size of the VM instances."
  type        = string
  default     = "t2.micro"
}

variable "instance_count_min" {
  description = "Number of instances to provision."
  type        = number
  default     = 0

  validation {
    condition     = var.instance_count_min >= 0 && var.instance_count_min <= 3
    error_message = "Instance count min must be between 0 and 3."
  }
}

variable "instance_count_max" {
  description = "Number of instances to provision."
  type        = number
  default     = 0

  validation {
    condition     = var.instance_count_max >= 0 && var.instance_count_max <= 3
    error_message = "Instance count max must be between 0 and 3."
  }
}

variable "add_public_ip" {
  type    = bool
  default = false
}

variable "allow_http_sec_grp_id" {
  type = string
}

variable "startup_script" {
  type = string
}

variable "subnet_ids" {
  type = string
}

variable "load_balancer_id" {
  type = string
}
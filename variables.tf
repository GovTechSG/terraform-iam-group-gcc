variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "name" {
  description = "name of the group in aws console"
  type        = string
}

variable "path" {
  description = "optional path to the group"
  type        = string
  default     = "/"
}

variable "role_names" {
  description = "list of role names (including path if applicable) that this group can assume"
  type        = list(string)
}

variable "usernames" {
  description = "list of user usernames"
  type        = list(string)
}

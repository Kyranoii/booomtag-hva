# Enviorment variables
variable "region" {
  description = "region to create resource"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}


# Networking variables
variable "vpc_cidr" {
  description = "Define IP range"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "Define IP range of public subnet in az1"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "Define IP range of public subnet in az2"
  type        = string
}

variable "private_app_az1_cidr" {
  description = "Define IP range of private app in az1"
  type        = string
}

variable "private_app_az2_cidr" {
  description = "Define IP range of private app az2"
  type        = string
}

variable "private_db_az1_cidr" {
  description = "Define IP range of private db az1"
  type        = string
}

variable "private_db_az2_cidr" {
  description = "Define IP range of private db az2"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  default = "booomtagdb"
}

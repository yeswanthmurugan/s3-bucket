variable "environment" {
  description = "Environment name like dev, staging, or prod"
  type        = string
}

variable "services" {
  description = "Name of the logging service "
  type        = list(string)
}
variable "prefix-1" {
  description = "Prefix for bucket names, e.g., bu-eu"
  type        = string
}

variable "prefix-2" {
  description = "Prefix for bucket names, e.g., bu-us"
  type        = string
}
variable "region_1" {
  description = "Region for the bucket"
  type        = string
}
variable "region_2" {
  description = "Region for the bucket"
  type        = string
}
# Define the prefix for all resource naming
variable "prefix" {
  description = "The application prefix that will be prepended to all created resources"
  default = "default"
}

variable "administrator_login" {
  default = "admin"
  description = "The SQL Server admin login username"
}

variable "administrator_password" {
  default = "admin-password-123"
  description = "The SQL Administrator default password"
}

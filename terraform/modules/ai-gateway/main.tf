# Module implementation — see README.md for full architecture details
# Extend with cloud-specific resources for your deployment target

variable "environment" { type = string }
variable "prefix" { type = string }

output "module_name" { value = var.prefix }

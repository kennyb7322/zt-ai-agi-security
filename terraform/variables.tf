# ═══════════════════════════════════════════════════════════════════
# Zero Trust AI/GI/AGI Architecture — Global Variables
# ═══════════════════════════════════════════════════════════════════

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "Primary AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "dr_region" {
  description = "Disaster recovery region"
  type        = string
  default     = "us-west-2"
}

variable "resource_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "zt-ai"
}

variable "vpc_cidr" {
  description = "CIDR block for the Zero Trust VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for multi-AZ deployment"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# ─── Edge Security (L01) ───
variable "geo_allowed_countries" {
  description = "List of allowed country codes for geo-blocking"
  type        = list(string)
  default     = ["US", "CA", "GB", "DE", "FR", "JP", "AU"]
}

variable "api_rate_limit_rpm" {
  description = "API rate limit (requests per minute per key)"
  type        = number
  default     = 60
}

# ─── AI Gateway (L02) ───
variable "max_token_budget_per_request" {
  description = "Maximum token budget per AI request"
  type        = number
  default     = 4096
}

# ─── Data Layer (L06) ───
variable "rds_instance_class" {
  description = "RDS instance class for the data layer"
  type        = string
  default     = "db.r6g.large"
}

# ─── AGI Controls ───
variable "enable_agi_controls" {
  description = "Enable AGI-specific security controls (Layers 09-10)"
  type        = bool
  default     = false
}

variable "max_autonomy_without_approval" {
  description = "Maximum autonomy level (0-5) that does not require human approval"
  type        = number
  default     = 2
  validation {
    condition     = var.max_autonomy_without_approval >= 0 && var.max_autonomy_without_approval <= 5
    error_message = "Autonomy level must be between 0 and 5."
  }
}

variable "max_gpu_instances" {
  description = "Maximum GPU instances allowed (resource confinement)"
  type        = number
  default     = 4
}

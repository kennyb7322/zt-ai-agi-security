# ═══════════════════════════════════════════════════════════════════
# Zero Trust AI/GI/AGI Architecture — Root Terraform Module
# 10-Layer Security Stack — Cloud-Agnostic Orchestration
#
# Author: Kenneth P. Barnes, Ph.D. — UCS Solutions
# ═══════════════════════════════════════════════════════════════════

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "zt-ai-agi-tfstate"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "zt-ai-agi-tflock"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "zt-ai-agi-security"
      Environment = var.environment
      ManagedBy   = "terraform"
      Architecture = "zero-trust-ai-agi"
      Owner       = "ucs-solutions"
    }
  }
}

# ═══════════════════════════════════════════════
# LAYER 01 — AI-Aware Edge Security
# ═══════════════════════════════════════════════
module "edge_security" {
  source = "./modules/edge-security"

  environment         = var.environment
  prefix              = var.resource_prefix
  allowed_countries   = var.geo_allowed_countries
  rate_limit_rpm      = var.api_rate_limit_rpm
  enable_agi_controls = var.enable_agi_controls
  waf_log_bucket      = module.observability.log_bucket_id
}

# ═══════════════════════════════════════════════
# LAYER 02 — AI Security Gateway
# ═══════════════════════════════════════════════
module "ai_gateway" {
  source = "./modules/ai-gateway"

  environment              = var.environment
  prefix                   = var.resource_prefix
  edge_waf_arn             = module.edge_security.waf_arn
  max_token_budget         = var.max_token_budget_per_request
  enable_reasoning_validator = var.enable_agi_controls
  enable_goal_alignment    = var.enable_agi_controls
  enable_supply_chain_sbom = true
}

# ═══════════════════════════════════════════════
# LAYER 03 — Zero Trust Network Segmentation
# ═══════════════════════════════════════════════
module "zero_trust_network" {
  source = "./modules/zero-trust-network"

  environment             = var.environment
  prefix                  = var.resource_prefix
  vpc_cidr                = var.vpc_cidr
  availability_zones      = var.availability_zones
  enable_service_mesh     = true
  enable_cognitive_sandbox = var.enable_agi_controls
  nat_gateway_count       = length(var.availability_zones)
}

# ═══════════════════════════════════════════════
# LAYER 04 — AI Control Plane & Application
# ═══════════════════════════════════════════════
module "ai_control_plane" {
  source = "./modules/ai-control-plane"

  environment              = var.environment
  prefix                   = var.resource_prefix
  vpc_id                   = module.zero_trust_network.vpc_id
  private_subnet_ids       = module.zero_trust_network.private_subnet_ids
  enable_canary_deployments = true
  enable_human_in_loop     = var.enable_agi_controls
  max_autonomy_auto        = var.max_autonomy_without_approval
}

# ═══════════════════════════════════════════════
# LAYER 05 — AI Guardrails & DLP
# ═══════════════════════════════════════════════
module "guardrails_dlp" {
  source = "./modules/guardrails-dlp"

  environment                = var.environment
  prefix                     = var.resource_prefix
  vpc_id                     = module.zero_trust_network.vpc_id
  enable_pii_masking         = true
  enable_toxicity_check      = true
  enable_immutable_audit     = true
  enable_emergent_detection  = var.enable_agi_controls
  audit_retention_days       = 2555  # 7 years
}

# ═══════════════════════════════════════════════
# LAYER 06 — Secure Data & AI Workloads
# ═══════════════════════════════════════════════
module "secure_data" {
  source = "./modules/secure-data"

  environment              = var.environment
  prefix                   = var.resource_prefix
  vpc_id                   = module.zero_trust_network.vpc_id
  private_subnet_ids       = module.zero_trust_network.private_subnet_ids
  kms_key_arn              = module.secrets_identity.kms_key_arn
  enable_cross_region_dr   = true
  dr_region                = var.dr_region
  enable_memory_partitioning = var.enable_agi_controls
  rds_instance_class       = var.rds_instance_class
}

# ═══════════════════════════════════════════════
# LAYER 07 — Secrets, Identity & Agent Creds
# ═══════════════════════════════════════════════
module "secrets_identity" {
  source = "./modules/secrets-identity"

  environment               = var.environment
  prefix                    = var.resource_prefix
  enable_identity_federation = true
  enable_agent_identity     = var.enable_agi_controls
  secret_rotation_days      = 30
  capability_token_ttl_hours = 4
}

# ═══════════════════════════════════════════════
# LAYER 08 — AI-Driven Security & Observability
# ═══════════════════════════════════════════════
module "observability" {
  source = "./modules/observability"

  environment               = var.environment
  prefix                    = var.resource_prefix
  vpc_id                    = module.zero_trust_network.vpc_id
  enable_guardduty          = true
  enable_ai_monitoring      = true
  enable_chaos_engineering  = var.environment != "prod"
  enable_siem_soar          = true
  enable_agi_telemetry      = var.enable_agi_controls
  log_retention_days        = 365
}

# ═══════════════════════════════════════════════
# LAYER 09 — AGI Autonomy Governance [NEW]
# ═══════════════════════════════════════════════
module "agi_governance" {
  source = "./modules/agi-governance"
  count  = var.enable_agi_controls ? 1 : 0

  environment            = var.environment
  prefix                 = var.resource_prefix
  vpc_id                 = module.zero_trust_network.vpc_id
  alert_topic_arn        = module.observability.alert_topic_arn
  max_gpu_instances      = var.max_gpu_instances
  heartbeat_interval_sec = 60
  kill_switch_multi_key  = true
  model_weight_retention_days = 365
}

# ═══════════════════════════════════════════════
# LAYER 10 — AGI Ethical Containment [NEW]
# ═══════════════════════════════════════════════
module "ethical_containment" {
  source = "./modules/ethical-containment"
  count  = var.enable_agi_controls ? 1 : 0

  environment              = var.environment
  prefix                   = var.resource_prefix
  governance_module        = var.enable_agi_controls ? module.agi_governance[0] : null
  enable_value_alignment   = true
  enable_corrigibility     = true
  enable_red_team          = true
  enable_regulatory_compliance = true
  compliance_frameworks    = ["nist-ai-rmf", "eu-ai-act", "iso-42001"]
}

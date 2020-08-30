variable "vpc_id" {
  type        = string
  description = "the vpc id the instance will be placed in"
}
variable "az" {
  type        = string
  description = "the AZ prometheus will live in"
}
variable "disk_size_gb" {
  type        = number
  description = "How big the prometheus persistent disk should be, in GB"
}
variable "ami" {
  type        = string
  description = "AMI id for the instance"
}

variable "instance_type" {
  type        = string
  default     = "t3.nano"
  description = "ec2 instance type"
}

variable "subnet_id" {
  description = "the subnet id to place the instance on"
  type        = string
}

variable "playbook_bucket" {
  description = "the s3 bucket id that the instance can read ansible playbooks from"
  type        = string
}

variable "playbook_bundle_s3_key" {
  description = "the path to the ansible bundle zip file in the s3 bucket"
  type        = string
}

variable "ssm_logs_bucket" {
  type        = string
  description = "S3 bucket name of the bucket where SSM Session Manager logs are stored"
}

variable "cloudflare_origin_ca_key" {
  type = string
}
variable "cloudflare_auth_key" {
  type = string
}
variable "cloudflare_auth_email" {
  type = string
}
variable "cloudflare_zone" {
  type = string
}
variable "cloudflare_zone_id" {
  type = string
}
variable "monitoring_domain" {
  type        = string
  description = "the full domain that grafana + prometheus + alert manager will be made available at. (example: monitor.mydomain.com)"
}
variable "matrix_alertmanager_shared_secret" {
  type = string
}
variable "matrix_alertmanager_url" {
  type = string
}
variable "alertmanager_receivers" {
  type        = string
  description = "the yaml snippet as per alertmanager's 'receivers' docs"
}
variable "alertmanager_route" {
  description = "the yaml snippet as per alertmanager's 'routes' docs"
}

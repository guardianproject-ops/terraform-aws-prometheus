module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = concat(var.attributes, ["prometheus"])
  tags       = merge(var.tags, map("Application", local.tag_application))
}

module "label_efs" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = concat(var.attributes, ["efs"])
  tags       = merge(var.tags, map("Application", local.tag_application))
}

locals {
  ssm_prefix            = module.label.id
  tag_application       = "prometheus"
  ansible_document_name = "AWS-ApplyAnsiblePlaybooks"
  association_name      = "PrometheusApply"
}

data "aws_region" "current" {}

#########################
# Param Store Resources #
#########################
resource "aws_ssm_parameter" "cloudflare_origin_ca_key" {
  name  = "/${local.ssm_prefix}/cloudflare_origin_ca_key"
  type  = "SecureString"
  value = var.cloudflare_origin_ca_key
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "cloudflare_auth_key" {
  name  = "/${local.ssm_prefix}/cloudflare_auth_key"
  type  = "SecureString"
  value = var.cloudflare_auth_key
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "cloudflare_auth_email" {
  name  = "/${local.ssm_prefix}/cloudflare_auth_email"
  type  = "SecureString"
  value = var.cloudflare_auth_email
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "cloudflare_zone" {
  name  = "/${local.ssm_prefix}/cloudflare_zone"
  type  = "SecureString"
  value = var.cloudflare_zone
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "cloudflare_zone_id" {
  name  = "/${local.ssm_prefix}/cloudflare_zone_id"
  type  = "SecureString"
  value = var.cloudflare_zone_id
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "monitoring_domain" {
  name  = "/${local.ssm_prefix}/monitoring_domain"
  type  = "SecureString"
  value = var.monitoring_domain
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "matrix_alertmanager_shared_secret" {
  name  = "/${local.ssm_prefix}/matrix_alertmanager_shared_secret"
  type  = "SecureString"
  value = var.matrix_alertmanager_shared_secret
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "matrix_alertmanager_url" {
  name  = "/${local.ssm_prefix}/matrix_alertmanager_url"
  type  = "SecureString"
  value = var.matrix_alertmanager_url
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "alertmanager_receivers" {
  name  = "/${local.ssm_prefix}/alertmanager_receivers"
  type  = "SecureString"
  value = var.alertmanager_receivers
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "alertmanager_route" {
  name  = "/${local.ssm_prefix}/alertmanager_route"
  type  = "SecureString"
  value = yamlencode(var.alertmanager_route)
  tags  = module.label.tags
}
resource "aws_ssm_parameter" "monitoring_nfs_url" {
  name  = "/${local.ssm_prefix}/monitoring_nfs_url"
  type  = "String"
  value = aws_efs_file_system.default.dns_name
  tags  = module.label.tags
}
#######################
# IAM Resources       #
#######################

# create a kms_key to encrypt prometheus data with
module "kms_key" {
  source     = "git::https://github.com/cloudposse/terraform-aws-kms-key.git?ref=tags/0.4.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = module.label.attributes
  tags       = var.tags

  description = "KMS key for ${module.label.id}"
  alias       = "alias/${module.label.id}"
}

# create a policy to let the instance fetch its own prefix from SSM params
module "ssm_prefix_self" {
  source            = "git::https://gitlab.com/guardianproject-ops/terraform-aws-ssm-param-store-iam?ref=master"
  path_prefix       = "${module.label.id}/"
  prefix_with_label = false
  name              = var.name
  namespace         = var.namespace
  stage             = var.stage
  attributes        = module.label.attributes
  tags              = var.tags
  region            = data.aws_region.current.name
  kms_key_arn       = module.kms_key.key_arn
}

# define a policy that allows the instance to read from the ansible playbook bucket
data "aws_iam_policy_document" "playbook_bucket_access" {
  statement {
    sid = "AllowToReadFromPlaybookBucket"
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::${var.playbook_bucket}",
      "arn:aws:s3:::${var.playbook_bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "playbook_bucket_access" {
  name        = "playbook-bucket-access-${module.label.id}"
  description = "Policy that allows instances readonly access to playbook bucket"
  policy      = data.aws_iam_policy_document.playbook_bucket_access.json
}

# create a policy that allows the instance to use session manager and send logs an bucket
module "session_manager" {
  source         = "git::https://gitlab.com/guardianproject-ops/terraform-aws-session-manager-instance-policy?ref=master"
  name           = var.name
  namespace      = var.namespace
  stage          = var.stage
  attributes     = module.label.attributes
  tags           = var.tags
  s3_bucket_name = var.ssm_logs_bucket
  s3_key_prefix  = module.label.id
}

# define a policy that allows the instance to write to the session manager logs bucket
data "aws_iam_policy_document" "session_manager_bucket_access" {
  statement {
    sid = "AllowWriteToSessionManagerBucket"
    actions = [
      "s3:Put*"
    ]

    resources = [
      "arn:aws:s3:::${var.ssm_logs_bucket}",
      "arn:aws:s3:::${var.ssm_logs_bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "session_manager_bucket_access" {
  name        = "session-manager-bucket-access-${module.label.id}"
  description = "Policy that allows instances write access to the session manager logs bucket"
  policy      = data.aws_iam_policy_document.session_manager_bucket_access.json
}

# attach policies to the instance role
module "instance_role_attachment" {
  source     = "git::https://gitlab.com/guardianproject-ops/terraform-aws-iam-instance-role-policy-attachment?ref=master"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  delimiter  = var.delimiter

  iam_policy_arns = [
    module.session_manager.ec2_session_manager_policy_arn,
    aws_iam_policy.playbook_bucket_access.arn,
    aws_iam_policy.session_manager_bucket_access.arn,
    module.ssm_prefix_self.policy_arn,
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  ]
}

# create the instance profile with the role
resource "aws_iam_instance_profile" "profile" {
  name = module.label.id
  role = module.instance_role_attachment.instance_role_id
}

#######################
# EC2 Resources       #
#######################

resource "aws_efs_file_system" "default" {
  tags             = module.label_efs.tags
  encrypted        = true
  kms_key_id       = module.kms_key.key_arn
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
}

resource "aws_efs_mount_target" "default" {
  file_system_id  = aws_efs_file_system.default.id
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.efs.id]
}

locals {
  userdata = <<-USERDATA
#!/bin/bash
set -e
apt-get update && apt-get install -y nfs-common
echo "MOUNTING EFS"
mkdir -p /srv/${module.label.id}
echo '${aws_efs_file_system.default.dns_name}:/ /srv/${module.label.id} nfs4 defaults,vers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0' >> /etc/fstab
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.default.dns_name}:/ /srv/${module.label.id}
echo "MOUNTED EFS: ${aws_efs_file_system.default.dns_name}:/ /srv/${module.label.id}"
USERDATA

  security_group_ids = [
    aws_security_group.prometheus.id,
    aws_security_group.efs.id,
  ]
}

module "autoscale_group" {
  source = "git::https://github.com/cloudposse/terraform-aws-ec2-autoscale-group.git?ref=tags/0.4.0"

  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  delimiter  = var.delimiter

  image_id                  = var.ami
  instance_type             = var.instance_type
  security_group_ids        = local.security_group_ids
  iam_instance_profile_name = aws_iam_instance_profile.profile.name
  subnet_ids                = [var.subnet_id]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  wait_for_capacity_timeout = "5m"
  # we assign the instance a public ip, even though we do not open any ports.
  # this is because an elastic ip is cheaper than a NAT Gateway
  associate_public_ip_address = true
  # user_data_base64            = "${base64encode(local.userdata)}"


  tags = module.label.tags

  autoscaling_policies_enabled = false
}

# create the security group for the instance
# we use cloudflared so we do not neet to expose any ports
resource "aws_security_group" "prometheus" {
  name   = module.label.id
  tags   = module.label.tags
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs" {
  name   = module.label_efs.id
  tags   = module.label_efs.tags
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = 2049 # NFS
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.prometheus.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ssm_association" "prometheus" {
  name             = local.ansible_document_name
  association_name = local.association_name
  targets {
    key    = "tag:Application"
    values = [local.tag_application]
  }
  output_location {
    s3_bucket_name = var.ssm_logs_bucket
    s3_key_prefix  = "${var.name}/${local.association_name}"
  }
  parameters = {
    SourceType          = "S3"
    SourceInfo          = "{ \"path\": \"https://s3.amazonaws.com/${var.playbook_bucket}/${var.playbook_bundle_s3_key}\" }"
    InstallDependencies = "False"
    PlaybookFile        = "playbooks/prometheus.yml"
    ExtraVariables      = "SSM=True"
    Check               = "False"
    Verbose             = "-vvvv"
  }
}

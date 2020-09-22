#output "asg" {
#  value = module.autoscale_group
#}

output "efs_kms_key" {
  value = module.kms_key
}

output "efs" {
  value = aws_efs_file_system.default
}

output "efs_mount_target" {
  value = aws_efs_mount_target.default
}

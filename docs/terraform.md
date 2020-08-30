## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| alertmanager\_receivers | the yaml snippet as per alertmanager's 'receivers' docs | `string` | n/a | yes |
| alertmanager\_route | the yaml snippet as per alertmanager's 'routes' docs | `any` | n/a | yes |
| ami | AMI id for the instance | `string` | n/a | yes |
| attributes | Additional attributes (e.g., `one', or `two') | `list` | `[]` | no |
| az | the AZ prometheus will live in | `string` | n/a | yes |
| cloudflare\_auth\_email | n/a | `string` | n/a | yes |
| cloudflare\_auth\_key | n/a | `string` | n/a | yes |
| cloudflare\_origin\_ca\_key | n/a | `string` | n/a | yes |
| cloudflare\_zone | n/a | `string` | n/a | yes |
| cloudflare\_zone\_id | n/a | `string` | n/a | yes |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | `string` | `"-"` | no |
| instance\_type | ec2 instance type | `string` | `"t3.nano"` | no |
| matrix\_alertmanager\_shared\_secret | n/a | `string` | n/a | yes |
| matrix\_alertmanager\_url | n/a | `string` | n/a | yes |
| monitoring\_domain | the full domain that grafana + prometheus + alert manager will be made available at. (example: monitor.mydomain.com) | `string` | n/a | yes |
| name | Name  (e.g. `app` or `database`) | `string` | n/a | yes |
| namespace | Namespace (e.g. `keanu`) | `string` | n/a | yes |
| playbook\_bucket | the s3 bucket id that the instance can read ansible playbooks from | `string` | n/a | yes |
| playbook\_bundle\_s3\_key | the path to the ansible bundle zip file in the s3 bucket | `string` | n/a | yes |
| ssm\_logs\_bucket | S3 bucket name of the bucket where SSM Session Manager logs are stored | `string` | n/a | yes |
| stage | Environment (e.g. `hard`, `soft`, `unified`, `dev`) | `string` | n/a | yes |
| subnet\_id | the subnet id to place the instance on | `string` | n/a | yes |
| tags | Additional tags (e.g. map(`Visibility`,`Public`) | `map` | `{}` | no |
| vpc\_id | the vpc id the instance will be placed in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| asg | n/a |
| efs | n/a |
| efs\_kms\_key | n/a |
| efs\_mount\_target | n/a |


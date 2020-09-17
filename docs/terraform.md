## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| alertmanager\_receivers | the yaml snippet as per alertmanager's 'receivers' docs | `string` | n/a | yes |
| alertmanager\_route | the yaml snippet as per alertmanager's 'routes' docs | `any` | n/a | yes |
| ami | AMI id for the instance | `string` | n/a | yes |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| az | the AZ prometheus will live in | `string` | n/a | yes |
| cloudflare\_auth\_email | n/a | `string` | n/a | yes |
| cloudflare\_auth\_key | n/a | `string` | n/a | yes |
| cloudflare\_origin\_ca\_key | n/a | `string` | n/a | yes |
| cloudflare\_zone | n/a | `string` | n/a | yes |
| cloudflare\_zone\_id | n/a | `string` | n/a | yes |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | n/a | yes |
| enabled | Set to false to prevent the module from creating any resources | `bool` | n/a | yes |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | n/a | yes |
| instance\_type | ec2 instance type | `string` | `"t3.nano"` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | n/a | yes |
| matrix\_alertmanager\_shared\_secret | n/a | `string` | n/a | yes |
| matrix\_alertmanager\_url | n/a | `string` | n/a | yes |
| monitoring\_domain | the full domain that grafana + prometheus + alert manager will be made available at. (example: monitor.mydomain.com) | `string` | n/a | yes |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | n/a | yes |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | n/a | yes |
| playbook\_bucket | the s3 bucket id that the instance can read ansible playbooks from | `string` | n/a | yes |
| playbook\_bundle\_s3\_key | the path to the ansible bundle zip file in the s3 bucket | `string` | n/a | yes |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | n/a | yes |
| ssm\_logs\_bucket | S3 bucket name of the bucket where SSM Session Manager logs are stored | `string` | n/a | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | n/a | yes |
| subnet\_id | the subnet id to place the instance on | `string` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| vpc\_id | the vpc id the instance will be placed in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| asg | n/a |
| efs | n/a |
| efs\_kms\_key | n/a |
| efs\_mount\_target | n/a |


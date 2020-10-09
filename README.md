# IAM Group GCC


```hcl

module 'group' {
   # ensure the roles have already been created at ../../roles
  role_names = [
    "my-role"
  ]
  # ensure the users have already been created at ../../users
  usernames = [
    "user1",
  ]

  # > DO NOT TOUCH
  name = "name of group"
  description = "add monitors/read-only-access scoped users to this group"
  # / DO NOT TOUCH
}
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | aws region | `string` | n/a | yes |
| name | name of the group in aws console | `string` | n/a | yes |
| path | optional path to the group | `string` | `"/"` | no |
| role\_names | list of role names (including path if applicable) that this group can assume | `list(string)` | n/a | yes |
| usernames | list of user usernames | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | arn of the group |
| id | id of the group |
| membership\_name | name of the group membership |
| name | name of the group |
| path | path to the group |
| policy | json-formatted policy of the group |
| policy\_id | id of the policy of the group |
| policy\_name | name of the policy of the group |
| unique\_id | unique id of the group |
| usernames | usernames of users associated with this group |


output "arn" {
  description = "arn of the group"
  value       = "${aws_iam_group.iam_group.arn}"
}

output "id" {
  description = "id of the group"
  value       = "${aws_iam_group.iam_group.id}"
}

output "membership_name" {
  description = "name of the group membership"
  value       = "${aws_iam_group_membership.iam_group.name}"
}

output "name" {
  description = "name of the group"
  value       = "${aws_iam_group.iam_group.name}"
}

output "path" {
  description = "path to the group"
  value       = "${aws_iam_group.iam_group.path}"
}

output "policy" {
  description = "json-formatted policy of the group"
  value       = "${data.aws_iam_policy_document.iam_group.json}"
}

output "policy_id" {
  description = "id of the policy of the group"
  value       = "${aws_iam_group_policy.iam_group.id}"
}

output "policy_name" {
  description = "name of the policy of the group"
  value       = "${aws_iam_group_policy.iam_group.name}"
}

output "unique_id" {
  description = "unique id of the group"
  value       = "${aws_iam_group.iam_group.id}"
}

output "usernames" {
  description = "usernames of users associated with this group"
  value       = "${aws_iam_group_membership.iam_group.users}"
}

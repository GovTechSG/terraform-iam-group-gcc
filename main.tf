#
# iam-group-gcc
# -------------
# this module assists in creating an iam group
#

# ref: https://www.terraform.io/docs/providers/aws/d/caller_identity.html
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "iam_group" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect    = "Allow"
    resources = formatlist("arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/%s", var.role_names)
  }
}

resource "aws_iam_group_policy" "iam_group" {
  name   = "${var.name}-policy"
  group  = aws_iam_group.iam_group.id
  policy = data.aws_iam_policy_document.iam_group.json
}

resource "aws_iam_group_policy" "iam_group_force_mfa" {
  name   = "force-mfa"
  group  = aws_iam_group.iam_group.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowViewAccountInfo",
      "Effect": "Allow",
      "Action": [
        "iam:GetAccountPasswordPolicy",
        "iam:GetAccountSummary",
        "iam:ListVirtualMFADevices"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowManageOwnPasswords",
      "Effect": "Allow",
      "Action": [
        "iam:ChangePassword",
        "iam:GetUser"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}"
    },
    {
      "Sid": "AllowManageOwnAccessKeys",
      "Effect": "Allow",
      "Action": [
        "iam:CreateAccessKey",
        "iam:DeleteAccessKey",
        "iam:ListAccessKeys",
        "iam:UpdateAccessKey"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}"
    },
    {
      "Sid": "AllowManageOwnSigningCertificates",
      "Effect": "Allow",
      "Action": [
        "iam:DeleteSigningCertificate",
        "iam:ListSigningCertificates",
        "iam:UpdateSigningCertificate",
        "iam:UploadSigningCertificate"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}"
    },
    {
      "Sid": "AllowManageOwnSSHPublicKeys",
      "Effect": "Allow",
      "Action": [
        "iam:DeleteSSHPublicKey",
        "iam:GetSSHPublicKey",
        "iam:ListSSHPublicKeys",
        "iam:UpdateSSHPublicKey",
        "iam:UploadSSHPublicKey"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}"
    },
    {
      "Sid": "AllowManageOwnGitCredentials",
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceSpecificCredential",
        "iam:DeleteServiceSpecificCredential",
        "iam:ListServiceSpecificCredentials",
        "iam:ResetServiceSpecificCredential",
        "iam:UpdateServiceSpecificCredential"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}"
    },
    {
      "Sid": "AllowManageOwnVirtualMFADevice",
      "Effect": "Allow",
      "Action": [
        "iam:CreateVirtualMFADevice",
        "iam:DeleteVirtualMFADevice"
      ],
      "Resource": "arn:aws:iam::*:mfa/$${aws:username}"
    },
    {
      "Sid": "AllowManageOwnUserMFA",
      "Effect": "Allow",
      "Action": [
        "iam:DeactivateMFADevice",
        "iam:EnableMFADevice",
        "iam:ListMFADevices",
        "iam:ResyncMFADevice"
      ],
      "Resource": "arn:aws:iam::*:user/$${aws:username}"
    },
    {
      "Sid": "DenyAllExceptListedIfNoMFA",
      "Effect": "Deny",
      "NotAction": [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:GetUser",
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:ResyncMFADevice",
        "sts:GetSessionToken"
      ],
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        },
        "NumericLessThan": {
          "aws:MultiFactorAuthAge": 3600
        }
      }
    }
  ]
}
EOF
}

# ref: https://www.terraform.io/docs/providers/aws/r/iam_group_membership.html
resource "aws_iam_group_membership" "iam_group" {
  name  = "${var.name}-members"
  users = var.usernames
  group = aws_iam_group.iam_group.name
}

# ref: https://www.terraform.io/docs/providers/aws/d/iam_group.html
resource "aws_iam_group" "iam_group" {
  name = var.name
  path = var.path
}

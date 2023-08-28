

resource "aws_kms_key" "kms_key_s3" {
  description = "KMS for S3 default encryption"
  policy      = data.aws_iam_policy_document.kms_policy_s3.json

  enable_key_rotation = true
}

resource "aws_kms_alias" "kms_alias_s3" {
  name          = "alias/s3_kms_key"
  target_key_id = aws_kms_key.kms_key_s3.id
}

data "aws_iam_policy_document" "kms_policy_s3" {

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*"
    ]
    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }
  statement {
    sid    = "Allow cross account key usage for s3"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [for account_id in var.AuthOrgAccounts : "arn:aws:iam::${account_id}:root"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["arn:aws:s3:::*"]
    }
  }
}


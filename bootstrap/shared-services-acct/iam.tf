#------------------------------------------------------------------------------
#  Terraform ADO User
# -----------------------------------------------------------------------------

resource "aws_iam_user" "ado" {
  name = "ado-user"
}

resource "aws_iam_policy" "tf_state_management" {
  depends_on  = [aws_kms_key.kms_key_s3, aws_s3_bucket.terraform-state-bucket, aws_dynamodb_table.terraform-state-lock-table]
  name        = "tf-state-management"
  path        = "/"
  description = "Terraform state management policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AccessToS3KMSkey"
        Action = [
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyPair",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.kms_key_s3.arn
      },
      {
        Sid = "TFStateS3BucketTopLevel"
        Action = [
          "s3:ListBucket",
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.terraform-state-bucket.arn,
        ]
      },
      {
        Sid = "TFStateS3BucketKeys"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.terraform-state-bucket.arn}/*"
        ]
      },
      {
        Sid = "TFStateDynamoTable"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.terraform-state-lock-table.arn
      },
      {
        Sid = "AssumeRolePermissions"
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:iam::*:role/tf-deployment"
      },

    ]
  })
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  depends_on = [aws_iam_policy.tf_state_management]
  user       = aws_iam_user.ado.name
  policy_arn = aws_iam_policy.tf_state_management.arn
}

#--------------------------------------------------------------------------
# TF deployment (ado-user assumable role)
#--------------------------------------------------------------------------

resource "aws_iam_role" "tf_deployment" {
  name        = "tf-deployment"
  description = "Account for Terraform deployment"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/ado-user"
        },
        "Condition" : {}
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tf_assume_role" {
  role       = aws_iam_role.tf_deployment.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



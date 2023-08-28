resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "terraform-state-bucket-${data.aws_caller_identity.current.account_id}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "terraform-state-bucket-${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_ownership_controls" "terraform_state_bucket_acl_ownership" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket_encryption" {
  depends_on = [aws_kms_key.kms_key_s3]
  bucket     = aws_s3_bucket.terraform-state-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms_key_s3.id

    }
  }
}

resource "aws_s3_bucket_policy" "allow_ssl_requests_only_state_bucket" {
  bucket = aws_s3_bucket.terraform-state-bucket.id
  policy = data.aws_iam_policy_document.allow_ssl_requests_only_state_bucket.json
}

data "aws_iam_policy_document" "allow_ssl_requests_only_state_bucket" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:*"
    ]

    effect = "Deny"

    resources = [
      aws_s3_bucket.terraform-state-bucket.arn,
      "${aws_s3_bucket.terraform-state-bucket.arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform-state-bucket" {
  bucket = aws_s3_bucket.terraform-state-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

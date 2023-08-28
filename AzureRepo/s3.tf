#--------------------------------------------------------------------------
# Test bucket in shared services
#--------------------------------------------------------------------------

resource "aws_s3_bucket" "bucket_shared_services" {
  provider = aws
  bucket   = "test-bucket-${data.aws_caller_identity.current.account_id}-shared-services"

  tags = {
    Name = "test-bucket-${data.aws_caller_identity.current.account_id}-shared-services"
  }
}


resource "aws_s3_bucket_versioning" "test_bucket_shared_services_versioning" {
  provider = aws
  bucket   = aws_s3_bucket.bucket_shared_services.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "test_bucket_shared_services_acl_ownership" {
  provider = aws
  bucket   = aws_s3_bucket.bucket_shared_services.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket_shared_services_encryption" {
  provider = aws
  bucket   = aws_s3_bucket.bucket_shared_services.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${var.orgs3encryptionkey}"
    }
  }
}



#--------------------------------------------------------------------------
# Test bucket in Account Z
#--------------------------------------------------------------------------

resource "aws_s3_bucket" "bucket_accountz" {
  provider = aws.accountz
  bucket   = "test-bucket-${var.accountzid}-accountz"

  tags = {
    Name = "test-bucket-${var.accountzid}-accountz"
  }
}


resource "aws_s3_bucket_versioning" "test_bucket_accountz_versioning" {
  provider = aws.accountz
  bucket   = aws_s3_bucket.bucket_accountz.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "test_bucket_acountz_acl_ownership" {
  provider = aws.accountz
  bucket   = aws_s3_bucket.bucket_accountz.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket_accountz_encryption" {
  provider = aws.accountz
  bucket   = aws_s3_bucket.bucket_accountz.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${var.orgs3encryptionkey}"
    }
  }
}

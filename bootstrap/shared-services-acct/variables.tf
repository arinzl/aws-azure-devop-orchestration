variable "AuthOrgAccounts" {
  description = "List of AWS Account IDs to grant access to the KMS for S3 encryption"
  type        = list(string)
}

# Deployment pre tasks
Several files will require updating with your AWS Account IDs before depoyment

_key_
\Repo uses the following:\
- XXXX-ss-XXXX  = AWS AccountID for the shared services account
- XXXX-az-XXXX  = AWS AccountID for Account Z

Complete the following pre-tasks before deployment.

1.  Update variable accountzid in file variables.tf with AWS AccountID of your non shared-services account (accountz)
2.  Update value for variable service_connection_name in file azure-pipelines.yml with the name of your service_connection
3.  Update value for variable terraform_backend_state_bucket in file azure-pipelines.yml with the name of your terraform state bucket name
4.  Update value for variable terraform_backend_state_key in file azure-pipelines.yml with the name of your terraform state bucket key
5.  Update value for variable bucket in file backend.tf. with the name of your terraform state bucket
6.  Update value for variable key in file backend.tf. with the name of your terraform state key
7.  Update value for variable bucket in file backend.tf. with the name of your region
8.  Update value for variable dynamodb_table in file backend.tf. with the name of your dynamoDB table name
9.  Update provider aws in providers.tf with your shared services account ID
10. Update provider aws.accountz in providers with account Z account ID
11. update the default vaule of orgs3encryptionkey in file variables.tf with the KMS Keyid for S3 encryption from the shared services account


# Deployment
1. Upload code to your Azure Repo (first upload may required manual pipeline intiailisation)
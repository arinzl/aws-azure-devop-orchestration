#--------------------------------------------------------------------------
# TF deployment (shared services ado-user assumable role)
#--------------------------------------------------------------------------

resource "aws_iam_role" "tf_deployment" {
  name        = "tf-deployment"
  description = "Account Terraform Role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.shared_services_account_id}:user/ado-user"
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

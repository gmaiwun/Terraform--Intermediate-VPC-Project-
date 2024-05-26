resource "aws_kms_key" "s3_kms" {
  description             = "KMS key for S3 bucket"
  deletion_window_in_days = 10

  policy = jsonencode({
    Version = "2012-10-17",
    Id = "key-policy-1",
    Statement = [
      {
        Sid = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "kms:*",
        Resource = "*"
      },
      {
        Sid = "Allow access through EC2 instances",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.ec2_role.name}"
        },
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:SourceVpce": aws_vpc_endpoint.s3.id
          }
        }
      }
    ]
  })
}


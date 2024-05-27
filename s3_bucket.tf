# Creation of the s3

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "gmais-bucket-${random_id.bucket_suffix.hex}" #Use Own bucket name here
  tags = merge(
    var.global_tags,
    {
      "Name"          = "gmais-bucket-${random_id.bucket_suffix.hex}",
      "resource_type" = "s3-bucket",
      "Creation Date" = "${timestamp()}"
    }
  )
  
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Encryption of the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_sse" {
  bucket = aws_s3_bucket.secure_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms.arn
      sse_algorithm = "aws:kms"
    }
  }
}

# Creation of bucket policy

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.secure_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.ec2_role.name}"
        },
        Action = ["s3:GetObject", "s3:PutObject"],
        Resource = "${aws_s3_bucket.secure_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "aws:sourceVpce": aws_vpc_endpoint.s3.id
          }
        }
      }
    ]
  })
}
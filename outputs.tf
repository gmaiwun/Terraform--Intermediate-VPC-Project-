output "public_lb_dns_name" {
  value = aws_lb.public_lb.dns_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.secure_bucket.bucket
}

output "kms_key_id" {
  value = aws_kms_key.s3_kms.id
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
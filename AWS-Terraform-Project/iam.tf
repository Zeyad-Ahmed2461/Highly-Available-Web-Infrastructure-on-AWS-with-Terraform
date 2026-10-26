
# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# IAM Policy for S3
resource "aws_iam_policy" "s3_policy" {
  name   = "s3_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
      Effect   = "Allow"
      Resource = [
        aws_s3_bucket.zeyad_s3.arn, 
        
         "${aws_s3_bucket.zeyad_s3.arn}/*"
         ]
    }]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

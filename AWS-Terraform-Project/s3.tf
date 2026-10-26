# S3 Bucket
resource "aws_s3_bucket" "zeyad_s3" {
  bucket        = "zeyad-s3-2025"
  force_destroy = true
}

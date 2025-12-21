resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "s3_bkt" {
  bucket = "tfstatebuckets3-${random_id.suffix.hex}"
}


resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bkt.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_bkt" {
  bucket = aws_s3_bucket.s3_bkt.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
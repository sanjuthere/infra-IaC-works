resource "aws_s3_bucket" "bucket" {
  bucket = "sanju-bucket-${random_id.rand_id.hex}"
}

resource "random_id" "rand_id" {
  byte_length = 6
}

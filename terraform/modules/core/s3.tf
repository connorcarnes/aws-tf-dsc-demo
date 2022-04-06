resource "aws_s3_bucket" "this" {
  bucket = var.dsc_bucket_name
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "this" {
  for_each = fileset(path.root, "${var.mof_directory}/*.mof")

  bucket = var.dsc_bucket_name
  key    = "dsc"
  source = each.value
  etag   = filemd5(each.value)
  depends_on = [
    aws_s3_bucket.this,
  ]
}

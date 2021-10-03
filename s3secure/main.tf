# s3 bucket with https only
resource "aws_s3_bucket" "https_tls" {
 bucket = "https-tls"
 
 tags = {
   Name = "log bucket"
   "Region"     = "us-east-1"
 }
 
 server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       sse_algorithm = "AES256"
     }
   }
 }
 
 # lifecycle rule
 lifecycle_rule {
   abort_incomplete_multipart_upload_days = 10
   enabled                                = true
   id                                     = "abort-multipart-upload"
   tags = {}
 
   transition {
     days          = 90
     storage_class = "GLACIER"
   }
 
   expiration {
     days = 365
   }
 
 }
}
 
# bucket policy
resource "aws_s3_bucket_policy" "https_tls_policy" {
 bucket = aws_s3_bucket.https_tls.id
 
 policy = jsonencode({
   "Version": "2012-10-17",
   "Statement": [
       {
           "Principal" : "*",
           "Action": [
               "s3:*"
           ],
           "Resource": [
               "arn:aws:s3:::https-tls",
               "arn:aws:s3:::https-tls/*"
           ],
           "Effect": "Deny",
           "Condition": {
               "Bool": {
                   "aws:SecureTransport": "false"
               },
               "NumericLessThan": {
                   "s3:TlsVersion": "1.2"
               }
           }
       }
   ]
 })
}
 
 


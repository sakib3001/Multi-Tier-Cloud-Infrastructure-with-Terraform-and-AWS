terraform {
  backend "s3" {
    bucket = "paste_your_bucket_name"
    region = "paste_region_name"
    key = "terraform/state.tfstate"          # path or bucket key 
    dynamodb_table = "dynamodb_table_name"   # must set the partition key = LockID for that table
  }
}
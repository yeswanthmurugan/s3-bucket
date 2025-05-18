module "eu_log_bucket" {
  for_each = local.buckets

  source  = "./modules/s3"
    providers = {
    aws = aws.eu
  }
  
  bucket_name                   = each.value.name-1
  enable_versioning             = false
  enable_server_side_encryption = false
  create_kms_key                = false
  expiration_days               = 365
  bucket_key_enabled            = false
  create_read_only_policy       = false
  create_read_write_policy      = false
  
  
  
  tags = {
    Service     = each.value.tag
    Environment = var.environment
  }
}

module "us_log_bucket" {
  for_each = local.buckets
  source  = "./modules/s3"
  providers = {
    aws = aws.us
  }
  bucket_name                   = each.value.name-2
  enable_versioning             = false
  enable_server_side_encryption = false
  create_kms_key                = false
  expiration_days               = 365
  bucket_key_enabled            = false
  create_read_only_policy       = false
  create_read_write_policy      = false
  
  

  tags = {
    Service     = each.value.tag
    Environment = var.environment
  }
}

locals {
  account_ids = [
    "362799379729", "542376772884", "270286309069", "866397810353", "638681436699",
    "018924747830", "325892950270", "255780255974", "954965609557", "145172354502",
    "315816552451", "817709960565"
  ]
}

resource "aws_s3_bucket_policy" "eu_log_bucket_policy" {
  for_each = local.buckets
  provider = aws.eu
  bucket = each.value.name-1   # <-- Replace with your actual bucket reference

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = flatten([
      for account_id in local.account_ids : [
        {
          Sid = "vpc-log-${account_id}"
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Action = "s3:PutObject"
          Resource = [
                "arn:aws:s3:::${each.value.name-1}",
                "arn:aws:s3:::${each.value.name-1}/*"
            ],
          Condition = {
            StringEquals = {
              "aws:SourceAccount" = "${account_id}"
              "s3:x-amz-acl" = "bucket-owner-full-control"
            },
          }
        },
        {
          Sid = "AllowCloudTrailAccess-${account_id}"
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Action = "s3:PutObject"
          Resource = [
                "arn:aws:s3:::${each.value.name-1}",
                "arn:aws:s3:::${each.value.name-1}/*"
            ],
          Condition = {
            StringEquals = {
              "aws:SourceAccount" = "${account_id}"
              "s3:x-amz-acl" = "bucket-owner-full-control"
            },
          }
        },
               {
          Sid = "AWSLogDeliveryCheck-${account_id}"
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Action = [
                "s3:GetBucketAcl",
                "s3:ListBucket"
            ]
          Resource = [
                "arn:aws:s3:::${each.value.name-1}",
                "arn:aws:s3:::${each.value.name-1}/*"
            ],
          Condition = {
            StringEquals = {
              "aws:SourceAccount" = "${account_id}"
            },
          }
        },
               {
          Sid = "AWSCloudtrailaclCheck-${account_id}"
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Action = [
                "s3:GetBucketAcl",
                "s3:ListBucket"
            ],
          Resource = [
                "arn:aws:s3:::${each.value.name-1}",
                "arn:aws:s3:::${each.value.name-1}/*"
            ],
          Condition = {
            StringEquals = {
              "aws:SourceAccount" = "${account_id}"
            },
          }
        }
      ]
    ])
  })
}

resource "aws_s3_bucket_policy" "us_log_bucket_policy" {
  for_each = local.buckets
  provider = aws.us
  bucket = each.value.name-2   # <-- Replace with your actual bucket reference

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = flatten([
      for account_id in local.account_ids : [
        {
          Sid = "vpc-log-${account_id}"
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Action = "s3:PutObject"
          Resource = [
                "arn:aws:s3:::${each.value.name-2}",
                "arn:aws:s3:::${each.value.name-2}/*"
            ],
          Condition = {
            StringEquals = {
              "aws:SourceAccount" = "${account_id}"
              "s3:x-amz-acl" = "bucket-owner-full-control"
            },
          }
        },
        {
          Sid = "AllowCloudTrailAccess-${account_id}"
          Effect = "Allow"
          Principal = {
            Service = "cloudtrail.amazonaws.com"
          }
          Action = "s3:PutObject"
          Resource = [
                "arn:aws:s3:::${each.value.name-2}",
                "arn:aws:s3:::${each.value.name-2}/*"
            ],
          Condition = {
            StringEquals = {
              "aws:SourceAccount" = "${account_id}"
              "s3:x-amz-acl" = "bucket-owner-full-control"
            },
          }
        },
               {
          Sid = "AWSLogDeliveryCheck-${account_id}"
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Action = [
                "s3:GetBucketAcl",
                "s3:ListBucket"
            ]
          Resource = [
                "arn:aws:s3:::${each.value.name-2}",
                "arn:aws:s3:::${each.value.name-2}/*"
            ],
          Condition = {
            StringEquals = {
              "aws:SourceAccount" = "${account_id}"
            },
          }
        },
               {
          Sid = "AWSCloudtrailaclCheck-${account_id}"
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Action = [
                "s3:GetBucketAcl",
                "s3:ListBucket"
            ],
          Resource = [
                "arn:aws:s3:::${each.value.name-2}",
                "arn:aws:s3:::${each.value.name-2}/*"
            ],
          Condition = {
            StringEquals = {
              "aws:SourceAccount" = "${account_id}"
            },
          }
        }
      ]
    ])
  })
}





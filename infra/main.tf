terraform {
  required_version = ">=1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
  }

  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "infra/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}


resource "aws_sqs_queue" "image_candidate_49_queue" {
  name = "image_processing_queue"
}

resource "aws_iam_role" "lambda_execution" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "lambda-s3-sqs-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes"
          ]
          Resource = aws_sqs_queue.image_candidate_49_queue.arn
        },
        {
          Effect = "Allow"
          Action = [
            "s3:PutObject"
          ]
          Resource = "arn:aws:s3:::pgr301-couch-explorers/*"
        }
      ]
    })
  }
}

resource "aws_lambda_function" "zipper_lambda" {
  filename         = "lambda_sqs.zip"
  function_name    = "image-Generator-Function-candidate-49"
  role             = aws_iam_role.lambda_execution.arn
  handler          = "lambda_sqs.handler"
  runtime          = "python3.9"
  timeout          =  100

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.image_candidate_49_queue.id
      OUTPUT_BUCKET = "pgr301-couch-explorers"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_candidate_49_queue.arn
  function_name    = aws_lambda_function.zipper_lambda.arn
  batch_size       = 5
  enabled          = true
}

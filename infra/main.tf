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
    key    = "49/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}

resource "aws_sqs_queue" "image_candidate_49_queue" {
  name                       = "image_processing_queue"
  visibility_timeout_seconds = 110
}

resource "aws_iam_role" "lambda_execution" {
  name               = "lambda_execution_role_candidate_49"
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
}

resource "aws_iam_role_policy" "lambda_s3_sqs_bedrock_policy" {
  name   = "lambda-s3-sqs-bedrock-policy"
  role   = aws_iam_role.lambda_execution.id
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
      },
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_logs" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "zipper_lambda" {
  filename         = "lambda_sqs.zip"
  function_name    = "image-Generator-Function-candidate-49"
  role             = aws_iam_role.lambda_execution.arn
  handler          = "lambda_sqs.lambda_handler"  # Updated to match function name in Python code
  runtime          = "python3.9"
  timeout          = 100

  environment {
    variables = {
      QUEUE_URL   = aws_sqs_queue.image_candidate_49_queue.id
      BUCKET_NAME = "pgr301-couch-explorers"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_candidate_49_queue.arn
  function_name    = aws_lambda_function.zipper_lambda.arn
  batch_size       = 5
  enabled          = false //true for testing purpose :D
}

# CloudWatch Alarm for SQS Queue
resource "aws_cloudwatch_metric_alarm" "sqs_oldest_message_alarm" {
  alarm_name          = "SQSApproximateAgeOfOldestMessageAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 20
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Triggers when the oldest message in the queue exceeds the defined threshold"
  alarm_actions       = [aws_sns_topic.sqs_alarm_sns_topic.arn]
  dimensions = {
    QueueName = aws_sqs_queue.image_candidate_49_queue.name
  }
}

# SNS Topic for Alarm Notifications
resource "aws_sns_topic" "sqs_alarm_sns_topic" {
  name = "sqs-alarm-topic"
}

# Email Subscription for Alarm Notifications
resource "aws_sns_topic_subscription" "sqs_alarm_email_subscription" {
  topic_arn = aws_sns_topic.sqs_alarm_sns_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

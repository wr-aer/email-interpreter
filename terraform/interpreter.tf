resource "aws_sns_topic" "email_received_topic" {
  name = "${var.project_name}-email-received-topic"
}

resource "aws_s3_bucket_notification" "email_received_notification" {
  bucket = aws_s3_bucket.incoming_emails_bucket.id

  topic {
    topic_arn = aws_sns_topic.email_received_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_sns_topic_policy" "email_received_topic_policy_attachment" {
  arn    = aws_sns_topic.email_received_topic.arn
  policy = data.aws_iam_policy_document.email_received_topic_policy.json
}

data "aws_iam_policy_document" "email_received_topic_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = [aws_sns_topic.email_received_topic.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.incoming_emails_bucket.arn]
    }
  }
}

resource "aws_sqs_queue" "email_received_queue" {
  name = "${var.project_name}-email-received-queue"

  redrive_policy = jsonencode({
    maxReceiveCount     = 4
    deadLetterTargetArn = aws_sqs_queue.email_received_deadletter_queue.arn
  })
}

resource "aws_sqs_queue" "email_received_deadletter_queue" {
  name = "${var.project_name}-email-received-deadletter-queue"
}

resource "aws_sqs_queue_redrive_allow_policy" "email_received_queue_redrive_allow_policy" {
  queue_url = aws_sqs_queue.email_received_deadletter_queue.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.email_received_queue.arn]
  })
}

resource "aws_sns_topic_subscription" "email_received_topic_subscription" {
  topic_arn = aws_sns_topic.email_received_topic.arn  
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.email_received_queue.arn 
}

resource "aws_sqs_queue_policy" "email_received_topic_subscription_policy_attachment" {
  queue_url = aws_sqs_queue.email_received_queue.id
  policy    = data.aws_iam_policy_document.email_received_topic_subscription_policy.json
}

data "aws_iam_policy_document" "email_received_topic_subscription_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["SQS:SendMessage"]
    resources = [aws_sqs_queue.email_received_queue.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.email_received_topic.arn]
    }
  }
}

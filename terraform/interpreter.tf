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

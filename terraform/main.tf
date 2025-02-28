resource "aws_s3_bucket" "incoming_emails_bucket" {
  bucket = "${var.project_name}-incoming-emails"
}

resource "aws_s3_bucket_policy" "ses_put_s3_policy" {
  bucket = aws_s3_bucket.incoming_emails_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ses.amazonaws.com" },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.incoming_emails_bucket.id}/*"
    }
  ]
}
POLICY
}

resource "aws_sesv2_email_identity" "ses_receiving_email_identity" {
  email_identity = var.domain_name
}

resource "aws_ses_receipt_rule_set" "ses_receiving_rule_set" {
  rule_set_name = "${var.project_name}-ses-receiving-rule-set"
}

resource "aws_ses_receipt_rule" "ses_receiving_storing_rule" {
  name          = "${var.project_name}-ses-receiving-storing-rule"
  rule_set_name = aws_ses_receipt_rule_set.ses_receiving_rule_set.rule_set_name
  enabled       = true
  recipients    = [var.email_address]

  s3_action {
    bucket_name = aws_s3_bucket.incoming_emails_bucket.id
    position    = 1
  }
}

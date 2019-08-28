#Set up flow logging for cloudwatch

resource "aws_flow_log" "results_flow_log" {
  iam_role_arn    = aws_iam_role.results_flow_log_iam_role.arn
  log_destination = aws_cloudwatch_log_group.results_flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main_vpc.id
}

resource "aws_cloudwatch_log_group" "results_flow_log_group" {
  name = "results_flow_log_group_${var.common_name}"
}

resource "aws_iam_role" "results_flow_log_iam_role" {
  name = "results_flow_log_iam_role_${var.common_name}"

  assume_role_policy = file("${path.module}/flow_logging_tr_policy.json")
}

resource "aws_iam_role_policy" "cloudwatch_access_policy" {
  name = "cloudwatch_access_policy_${var.common_name}"
  role = aws_iam_role.results_flow_log_iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

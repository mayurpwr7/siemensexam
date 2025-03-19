# IAM Role for Lambda to assume
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        resource = "*"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy to attach to the Lambda role for permissions
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Lambda Policy with basic execution permissions"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow Lambda to write logs to CloudWatch
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      # Allow Lambda to invoke functions (to allow chaining of functions or API Gateway to invoke)
      {
        Action   = ["lambda:InvokeFunction"]
        Effect   = "Allow"
        Resource = "*"
      },
      # Allow Lambda to interact with API Gateway for POST method execution
      {
        Action   = ["apigateway:POST"]
        Effect   = "Allow"
        Resource = "arn:aws:apigateway:eu-west-1::/restapis/*/resources/*/methods/POST"
      },
      # Allow Lambda to manage SNS permissions if applicable
      {
        Action   = ["sns:Publish"]
        Effect   = "Allow"
        Resource = "*"
      },
      # Allow Lambda to access S3 if it's using S3 resources
      {
        Action   = ["s3:GetObject", "s3:PutObject"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::your-bucket-name/*"
      }
    ]
  })
}

# Attach IAM Policy to the Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}



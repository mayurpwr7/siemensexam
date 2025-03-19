resource "aws_lambda_function" "invoke_api_lambda" {
  function_name = "invoke_api_lambda"

  s3_bucket = "467.devops.candidate.exam"
  s3_key    = "<YourLambdaCodeLocation>.zip"  # You will need to upload your Lambda function code in a ZIP file to S3.

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      API_ENDPOINT = "https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data"
      API_AUTH_KEY = "test"
    }
  }
}

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:CreatePolicy",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "ec2:CreateVpc",
        "ec2:CreateSubnet",
        "ec2:CreateRouteTable",
        "ec2:CreateSecurityGroup",
        "lambda:CreateFunction",
        "lambda:AddPermission",
        "apigateway:POST"
      ],
      "Resource": "*"
    }
  ]
}


resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Lambda Policy with basic execution permissions"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:*"]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action   = ["lambda:InvokeFunction"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["apigateway:POST"]
        Effect   = "Allow"
        Resource = "arn:aws:apigateway:eu-west-1::/restapis/*/resources/*/methods/POST"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM Role for GitHub Actions to assume."
  value       = aws_iam_role.github_actions_role.arn
}
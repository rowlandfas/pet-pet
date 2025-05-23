
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "IAM-KMS" {
  name               = "IAM-KMS"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "policy1" {
  statement {
    effect    = "Allow"
    sid       = "VaultUnsealKey"
    resources = [aws_kms_key.kms-vault.arn]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
  }
}

resource "aws_iam_policy" "policy12" {
  name        = "kms-policy-doc1"
  description = "the policy for vault unseal key"
  policy      = data.aws_iam_policy_document.policy1.json
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.IAM-KMS.name
  policy_arn = aws_iam_policy.policy12.arn
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "vault-kms-unseal1"
  role = aws_iam_role.IAM-KMS.name
}
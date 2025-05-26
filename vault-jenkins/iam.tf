
# chatgpt
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
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

resource "aws_iam_role_policy_attachment" "kms-policy-attach" {
  role       = aws_iam_role.IAM-KMS.name
  policy_arn = aws_iam_policy.policy12.arn
}

resource "aws_iam_role_policy_attachment" "ssm-policy-attach" {
  role       = aws_iam_role.IAM-KMS.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "kms-instance-profile" {
  name = "vault-kms-unseal1"
  role = aws_iam_role.IAM-KMS.name
}

resource "aws_ssm_activation" "ssm-activation" {
  name               = "vault-ssm-activation"
  description        = "ssm to connect to the vault server"
  iam_role           = aws_iam_role.IAM-KMS.id
  registration_limit = "5"
  depends_on         = [
    aws_iam_role_policy_attachment.ssm-policy-attach
  ]
}



resource "aws_ecr_repository" "ck-ecr-nginx" {
    name = "ck-ecr-nginx"
}

resource "aws_ecr_repository" "ck-ecr-rails" {
    name = "ck-ecr-rails"
}


resource "aws_ecr_lifecycle_policy" "ck-ecr-nginx" {
    repository = aws_ecr_repository.ck-ecr-nginx.name

    policy = <<EOF
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Keep last 30 release tagged images",
                "selection": {
                    "tagStatus": "tagged",
                    "tagPrefixList": ["release"],
                    "countType": "imageCountMoreThan",
                    "countNumber": 30
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }
EOF
}

resource "aws_ecr_lifecycle_policy" "ck-ecr-rails" {
    repository = aws_ecr_repository.ck-ecr-rails.name

    policy = <<EOF
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Keep last 30 release tagged images",
                "selection": {
                    "tagStatus": "tagged",
                    "tagPrefixList": ["release"],
                    "countType": "imageCountMoreThan",
                    "countNumber": 30
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }
EOF
}

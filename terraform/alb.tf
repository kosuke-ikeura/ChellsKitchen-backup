# ALBの定義
resource "aws_lb" "ck-ab" {
    name            = "ck-ab"
    load_balancer_type = "application"
    internal           = false
    idle_timeout       = 60
    enable_deletion_protection = false

    subnets = [
        aws_subnet.public_0.id,
        aws_subnet.public_1.id,
    ]


    access_logs {
        bucket  = aws_s3_bucket.alb_log.id
        enabled = true
    }

    security_groups = [
        module.http_sg.security_group_id,
        module.https_sg.security_group_id,
        module.http_redirect_sg.security_group_id,
    ]
}

output "alb_dns_name" {
    value = aws_lb.ck-ab.dns_name
}

# ALBのセキュリティグループをモジュールで定義
module "http_sg" {
    source          = "./security_group"
    name            = "http-sg"
    vpc_id          = aws_vpc.chells_kitchen.id
    port            = 80
    cidr_blocks     = ["0.0.0.0/0"]
}

module "https_sg" {
    source          = "./security_group"
    name            = "https-sg"
    vpc_id          = aws_vpc.chells_kitchen.id
    port            = 443
    cidr_blocks     = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
    source            = "./security_group"
    name              = "http-redirect-sg"
    vpc_id            = aws_vpc.chells_kitchen.id
    port              = 8080
    cidr_blocks       = ["0.0.0.0/0"]
}

# HTTPリスナーの定義
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.ck-ab.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "これはHTTPです"
            status_code  = "200"
        }
    }
}

# ホストゾーンのデータソース定義
data "aws_route53_zone" "chealseasuke" {
    name = "chealseasuke.com"
}

# ALBのDNSレコードの定義
resource "aws_route53_record" "chealseasuke" {
    zone_id = data.aws_route53_zone.chealseasuke.zone_id
    name    = data.aws_route53_zone.chealseasuke.name
    type    = "A"

    alias {
        name                    = aws_lb.ck-ab.dns_name
        zone_id                 = aws_lb.ck-ab.zone_id
        evaluate_target_health  = true
    }
}

output "domain_name" {
    value = aws_route53_record.chealseasuke.name
}

# SSL証明書の定義
resource "aws_acm_certificate" "chealseasuke" {
    domain_name                 = aws_route53_record.chealseasuke.name
    subject_alternative_names   = []
    validation_method           = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

# SSL証明書の検証用レコードの定義
resource "aws_route53_record" "chealseasuke_certificate" {
    name    = aws_acm_certificate.chealseasuke.domain_validation_options[0].resource_record_name
    type    = aws_acm_certificate.chealseasuke.domain_validation_options[0].resource_record_type
    records = [aws_acm_certificate.chealseasuke.domain_validation_options[0].resource_record_value]
    zone_id = data.aws_route53_zone.chealseasuke.id
    ttl     = 60
}

# SSL証明書の検証完了まで待機
resource "aws_acm_certificate_validation" "chealseasuke" {
    certificate_arn         = aws_acm_certificate.chealseasuke.arn
    validation_record_fqdns = [aws_route53_record.chealseasuke_certificate.fqdn]
}

# HTTPSリスナーの定義
resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.ck-ab.arn
    port              = "443"
    protocol          = "HTTPS"
    certificate_arn   = aws_acm_certificate.chealseasuke.arn
    ssl_policy        = "ELBSecurityPolicy-2016-08"

    default_action {
        target_group_arn = aws_lb_target_group.ck-ab-target.arn
        type             = "forward"
    }
}

# HTTPからHTTPSにリダイレクトするリスナーの定義
resource "aws_lb_listener" "redirect_http_to_https" {
    load_balancer_arn = aws_lb.ck-ab.arn
    port              = "8080"
    protocol          = "HTTP"

    default_action {
        type = "redirect"

        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# ターゲットグループの定義
resource "aws_lb_target_group" "ck-ab-target" {
    name                  = "ck-ab-target${substr(uuid(),0, 3)}"
    target_type           = "ip"
    vpc_id                = aws_vpc.chells_kitchen.id
    port                  = 80
    protocol              = "HTTP"
    deregistration_delay  = 300

    health_check {
        interval            = 30
        path                = "/"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 4
        matcher             = 200
    }
    lifecycle {
        create_before_destroy = true
        ignore_changes        = [name]
    }

    depends_on = [aws_lb.ck-ab]
}


resource "aws_lb_listener_rule" "ck-ab-rule" {
    listener_arn = aws_lb_listener.https.arn
    priority     = 100

    action {
        type                = "forward"
        target_group_arn    = aws_lb_target_group.ck-ab-target.arn
    }

    condition {
        field  = "path-pattern"
        values = ["/*"]
    }
}

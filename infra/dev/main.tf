# Network

module "network" {
  source = "../modules/network/"

  cidr    = var.cidr
  project = var.project
  env     = var.env
}

# Security Group

module "alb_sg" {
  source  = "../modules/sg/"
  sg_name = "${var.project}-${var.env}-alb-sg"
  vpc_id  = module.network.vpc_id

  ingress_rules = [
    {
      description = "Allow HTTP from Internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS from Internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "web_sg" {
  source  = "../modules/sg/"
  sg_name = "${var.project}-${var.env}-web-sg"
  vpc_id  = module.network.vpc_id

  ingress_rules = [
    {
      description     = "Allow HTTP from ALB Only"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [module.alb_sg.sg_id]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "launch_template" {
  source             = "../modules/launch_template/"
  project            = var.project
  env                = var.env
  sg_id              = module.web_sg.sg_id
  index_html_content = file("${path.module}/../../code/index.html")
}

module "acm" {
  source      = "../modules/acm"
  project     = var.project
  env         = var.env
  domain_name = "static-2.binaya14.com.np"
}

module "alb" {
  source            = "../modules/lb/"
  project           = var.project
  env               = var.env
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.alb_sg.sg_id
  certificate_arn   = module.acm.certificate_arn
  domain_name       = "static-2.binaya14.com.np"
}


module "asg" {
  source                  = "../modules/asg/"
  project                 = var.project
  env                     = var.env
  private_subnet_ids      = module.network.private_subnet_ids
  target_group_arn        = module.alb.target_group_arn
  launch_template_id      = module.launch_template.launch_template_id
  launch_template_version = module.launch_template.launch_template_latest_version

  # Capacity settings
  min_size         = 1
  max_size         = 3
  desired_capacity = 1
}

module "oidc" {
  source              = "../modules/oidc/"
  project             = var.project
  env                 = var.env
  github_repo         = "BS14/static-hosting-2"
  launch_template_arn = module.launch_template.launch_template_arn
  asg_arn             = module.asg.asg_arn

}

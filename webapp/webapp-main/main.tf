# Create the Network
module "vpc" {
  source = "../modules/vpc"

  region        = var.region
  project       = var.project
  vpc_cidr      = var.vpc_cidr
  private_subnets_cidr = var.private_sub_cidr
  public_subnets_cidr = var.public_sub_cidr
}

# Create the Security Groups
module "sec-groups" {
  source = "../modules/sec-groups"

  project = var.project
  # Passed from VPC Module
  vpc_id = module.vpc.vpc_id
}

# Create the Webserver Load Balancer
module "web_load_balancer" {
  source  = "../modules/load-balancer"
  project = var.project
  vpc_id = module.vpc.vpc_id
  # Passed from VPC Module
  subnet_ids = module.vpc.public_subnets_ids

  # Passed from Sec Groups Module
  allow_http_sec_grp_id = module.sec-groups.load_balancer_sec_grp_id
}

# Create the Autoscaling Group
module "asg_private" {
  source = "../modules/autoscaling-group"
  name = "private"

  region         = var.region
  project        = var.project
  startup_script = "install_httpd.sh"
  ami = var.ami
  tg_arn = module.web_load_balancer.tg_grp_arn
  instance_type      = "t2.micro"
  instance_count_min = 0
  instance_count_max = 0
  add_public_ip      = false

  # Passed from VPC Module
  subnet_ids = module.vpc.private_subnets_ids

  # Passed from Sec Groups Module
  allow_http_sec_grp_id = module.sec-groups.webserver_sec_grp_id
  # allow_ssh_id  = module.sec-groups.allow_ssh_id

  # Passed from Load Balancer Module
  load_balancer_id = module.web_load_balancer.load_balancer_id
}
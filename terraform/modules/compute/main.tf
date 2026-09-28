# Data source : dernière image officielle Ubuntu 24.04 (Canonical)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.name}-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  # IMDSv2 obligatoire (bonne pratique de sécurité)
  metadata_options {
    http_tokens = "required"
  }

  tags = { Name = "${var.name}-web-${count.index}" }

  # Une nouvelle version d'Ubuntu ne doit pas recréer les serveurs à chaque apply
  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = var.instance_count
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

# Disque réseau partagé : images et fichiers uploadés de PrestaShop
resource "aws_efs_file_system" "main" {
  encrypted = true
  tags      = { Name = "${var.name}-efs" }
}

# Un point de montage par AZ : chaque EC2 monte celui de sa zone
resource "aws_efs_mount_target" "main" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [var.security_group_id]
}

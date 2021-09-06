
#building instance
resource "aws_instance" "rq_private_ec2" {
	ami            = "ami-087c17d1fe0178315"
	instance_type  = "t2.micro"
	key_name       = "ac_key"
	subnet_id      = aws_subnet.rq_private_subnet.id
	vpc_security_group_ids = [aws_security_group.rq_private_ec2_sg.id]

    #Docker engine install/Dockerfile/Docker build/Docker run
	user_data = file("install_node.sh")

	tags = {
    Name       = "rq_private_ec2"
    Project    = "rearc_quest"
	}
}
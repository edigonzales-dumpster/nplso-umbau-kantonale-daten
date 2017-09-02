provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "geodb-dev-pg" {
  name        = "geodb-dev-pg"
  description = "Allow only postgres inbound."
  
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "geodb-dev-pg"
  }
}

resource "aws_db_instance" "geodb-dev-db" {
    identifier = "geodb-dev"
    availability_zone = "eu-central-1a"    
    allocated_storage = 5
    storage_type = "gp2"    
    engine = "postgres"
    engine_version = "9.6.3"
    instance_class = "db.t2.micro"
    name = "xanadu2"
    port = 5432
    username = "stefan"
    password = "ziegler12"
    multi_az = false
    publicly_accessible = true
    backup_retention_period = "0"
    apply_immediately = "true"
    auto_minor_version_upgrade = false
    vpc_security_group_ids = ["${aws_security_group.geodb-dev-pg.id}"]    
    skip_final_snapshot = true
}

output "rds-address" {
  value = "${aws_db_instance.geodb-dev-db.address}"
}

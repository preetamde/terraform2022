# here it is about local-exec command and using ip ranges

data "aws_ip_ranges" "deland" {
  regions  = ["eu-central-1"]
  services = ["ec2"]
}

resource "aws_security_group" "derestricted" {
  name = "only for de"
  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = data.aws_ip_ranges.deland.cidr_blocks
    /* this cannot be in square bracket , as it should be string*/
    description = "Access only for Deutschland"
  }
  provisioner "local-exec" {
    command = "echo ${aws_security_group.derestricted.id} > iplist.log" # here data only from this block can be used under local-exec
  }
}

/*
This resource is needed if you wish to test local-exec without
launching instance
resource "null_resource" "noresource" {
        provisioner "local-exec" {
    command = "echo `date` > text.log"
}  
}*/


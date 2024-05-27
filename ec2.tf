resource "aws_instance" "db" {
    ami = "ami-090252cbe067a9e58"
    vpc_security_group_ids = ["sg-06f3c37ae42fa3128"]
    instance_type = "t2.micro"

    # provisioners will run when you are creating resources
    # they will not run once resources are created
    provisioner "local-exec" {    
        command = "echo ${self.private_ip} > private_ips.txt" #self is aws_instance.web
    }

    # this will fail because in our local machine ansible is not installed.
    # provisioner "local-exec" {    
    #     command = "ansible-playbook -i private_ips.txt web.yaml"
    # }

    connection {    
        type     = "ssh"    
        user     = "ec2-user"    
        password = "DevOps321"    
        host     = self.public_ip  
    }

    provisioner "remote-exec" {    
        inline = [      
              "sudo dnf install ansible -y",
              "sudo dnf install nginx -y",
              "sudo systemctl start nginx" 
        ]  
    }
}
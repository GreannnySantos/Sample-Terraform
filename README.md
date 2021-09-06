**README**
**Rearc Quest:**
[<u>https://github.com/rearc/quest</u>](https://github.com/rearc/quest). 
The rq webapp returns a secret word injected to a docker file, running
on the AWS cloud and whose underlying infrastructure was provision using
terraform. While using TLS(https) to establish a secure connection
between the instance and the user
**Requirements:**
1.  Deploy the app in a Docker container. 
2.  Use node:10 as the base image.
3.  Inject an environment variable (SECRET_WORD) in the Docker
    container.
4.  Deploy a load balancer in front of the app.
5.  Use Infrastructure as Code (IaC) to "codify" your deployment
6.  TLS (https). You may use locally-generated certs.

**Webapp url:**
[https://rq-alb-854614082.us-east-1.elb.amazonaws.com](https://rq-alb-854614082.us-east-1.elb.amazonaws.com/)

References:
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- https://docs.docker.com/get-started/02_our_app/
- https://devcenter.heroku.com/articles/ssl-certificate-self
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html

**Steps:** Deploy the app in a Docker container. 
1.  Provision infrastructure using terraform
    -   rq_vpc.tf - added provsioner information, created vpc and igw
    -   rq_private_ec2.tf - created ec2 instance with userdata
    -   rq_private.tf - creates private subnet 
    -   rq_public.tf - created public subnet, NAT Gateway, and EIP
    -   rq_alb.tf - created application load balancer
    -   rq_sg.tf - created security groups for ALB and EC2 instance
    -   Variable.tf - variables used
    -   Install_node.sh - userdata 

**Step 6: TLS(https) -  use locally-generated cert.**
A self-signed certificate is an SSL certificate not signed by a (CA) but
by one's own private key. The certificate is not validated by a third
party and is generally used in **low-risk internal networks or in the
software development phase**.
**Creating a Self-Signed SSL Certificat**e
Used this source to create a self signed ssl certificated

References:
https://devcenter.heroku.com/articles/ssl-certificate-self
1.  OpenSSL was  installed by default on my mac
2.  Ran following commands on terminal
 - openssl genrsa -aes256 -passout pass:my_password -out server.pass.key 4096
 - openssl rsa -passin pass:my_password -in server.pass.key -out server.key
 - rm server.pass.key
 - openssl req -new -key server.key -out server.csr

1.  For cname used the DNS name of my application load balancer
    1.  elb.amazonaws.com
1.  Imported SSL to Certificate Manager on aws using aws web console.
1.  Attached SSL to ALB on terraform code using the arn - Amazon
    resource name

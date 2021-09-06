#!/bin/bash
cd /root
yum update -y
yum install docker -y
systemctl start docker
systemctl enable docker
systemctl status docker >> /root/status.txt
cat <<EOF > Dockerfile
FROM node:10 
WORKDIR /app 
RUN git clone https://github.com/rearc/quest.git && cd quest && mv * /app
RUN npm install
EXPOSE 3000
ENV SECRET_WORD Greanny
CMD ["npm", "start"]
EOF
docker build -t nodejs-quest .
docker run -dp 80:3000 nodejs-quest 



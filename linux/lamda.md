# AWS Lambda         
[Link](https://aws.amazon.com/lambda/)        
deployment python [link](/storage/linux/scripts/lambda/deployment-python.sh)        
### Docker build        
```sh
wget -O Dockerfile https://github.com/koomox/devops/blob/master/storage/linux/scripts/lambda/Dockerfile
wget -O docker_install.sh https://github.com/koomox/devops/blob/master/storage/linux/scripts/lambda/docker_install.sh
wget -O requirements.txt https://github.com/koomox/devops/blob/master/storage/linux/scripts/lambda/requirements.txt
wget -O runner.sh https://github.com/koomox/devops/blob/master/storage/linux/scripts/lambda/runner.sh
```
```sh
sudo docker build -t aws_lambda_builder_image .
sudo docker images
```
```sh
chmod +x ./runner.sh
sudo ./runner.sh
```
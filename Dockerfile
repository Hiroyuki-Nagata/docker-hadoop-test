FROM amazonlinux:2016.09
MAINTAINER hiroyuking

RUN DEBIAN_FRONTEND=noninteractive \
yum update -y

RUN DEBIAN_FRONTEND=noninteractive \
yum install -y                     \
which				   \
curl				   \
java-1.8.0-openjdk                 \
python2.7

RUN /bin/echo "Hello, Hadoop!!"
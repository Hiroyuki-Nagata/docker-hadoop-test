FROM amazonlinux:2016.09
MAINTAINER hiroyuking
USER root
ENV HADOOP_VER 2.7.2

ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_PREFIX $HADOOP_HOME
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE $HADOOP_PREFIX/lib/native
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_CONF_DIR

ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

RUN DEBIAN_FRONTEND=noninteractive \
yum update -y

RUN DEBIAN_FRONTEND=noninteractive \
yum install -y                     \
which				   \
curl				   \
java-1.8.0-openjdk                 \
python2.7                          \
openssh-clients                    \
openssh-server                     \
openssl

# for psuedo-distributed, hadoop
RUN mkdir ~/.ssh
RUN chmod 700 ~/.ssh
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
RUN cp -f ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/*

# Apache Hadoop
RUN curl -O http://mirror.nohup.it/apache/hadoop/common/hadoop-$HADOOP_VER/hadoop-$HADOOP_VER.tar.gz
RUN tar -xvf hadoop-$HADOOP_VER.tar.gz -C ..; \
    mv ../hadoop-$HADOOP_VER $HADOOP_HOME

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config; \
    chown root:root /root/.ssh/config

COPY hadoop/ $HADOOP_HOME/
COPY ./etc /etc
RUN chmod +x $HADOOP_HOME/etc/hadoop/*.sh
RUN chmod +x $HADOOP_HOME/bin/*.sh

RUN rm -rf /hdfs;                   \
    mkdir -p /hdfs;                 \
    chown -R hdfs:hdfs /hdfs;       \
    chown -R hdfs:hdfs $HADOOP_HOME

USER hdfs
RUN mkdir -p $HADOOP_HOME/logs; \
    hdfs namenode -format
USER root

RUN hadoop version
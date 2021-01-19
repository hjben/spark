FROM hjben/centos-systemd:latest
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV JAVA_HOME /usr/lib/jvm/jre-11-openjdk
ENV SPARK_HOME /usr/local/spark
ENV SPARK_CLASSPATH $SPARK_HOME/jars
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV TZ=Asia/Seoul

RUN dnf install -y openssh-server openssh-clients openssh-askpass
RUN dnf install -y rsync
RUN dnf install -y vim
RUN dnf install -y net-tools
RUN dnf install -y java-11-openjdk
RUN dnf install -y wget

RUN dnf install -y python38

WORKDIR /usr/bin
RUN ln -s python3 python && ln -s pip3 pip

WORKDIR /
RUN wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz
RUN tar -xvzf spark-3.0.1-bin-hadoop3.2.tgz -C /usr/local
RUN ln -s /usr/local/spark-3.0.1-bin-hadoop3.2 /usr/local/spark
RUN rm -f /spark-3.0.1-bin-hadoop3.2.tgz

ADD slaves $SPARK_HOME/conf/slaves

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

EXPOSE 8080-8099
EXPOSE 4040-4099
EXPOSE 7077

CMD ["/usr/sbin/init"]

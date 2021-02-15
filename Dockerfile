FROM hjben/centos-openjdk:11
MAINTAINER hjben <hj.ben.kim@gmail.com>

ENV SPARK_HOME /usr/local/spark
ENV SPARK_CLASSPATH $SPARK_HOME/jars
ENV SPARK_VERSION 3.0.1
ENV HADOOP_VERSION 3.2
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN dnf install -y python38

WORKDIR /usr/bin
RUN ln -s python3 python && ln -s pip3 pip

WORKDIR /
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz
RUN tar -xvzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C /usr/local
RUN ln -s /usr/local/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION /usr/local/spark
RUN rm -f /spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

ADD slaves $SPARK_HOME/conf/slaves

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

EXPOSE 8080-8099
EXPOSE 4040-4099
EXPOSE 7077

ENTRYPOINT ["/usr/sbin/init"]
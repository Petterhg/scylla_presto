FROM centos:7

RUN yum update -y && \
    yum install -y \
    tar wget mvn java-1.8.0-openjdk python && \
    mkdir -p /home/presto/data

ENV HOME /home/presto

RUN cd $HOME && \
    wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.191/presto-server-0.191.tar.gz

RUN cd $HOME && tar xvfz presto-server-0.191.tar.gz && \
    rm presto-server-0.191.tar.gz && \
    cd presto-server-0.191 && \
    mkdir -p etc/catalog && \
    wget https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.191/presto-cli-0.191-executable.jar && \
    mv presto-cli-0.191-executable.jar presto && \
    chmod +x presto

ADD config.properties $HOME/presto-server-0.191/etc
ADD jvm.config $HOME/presto-server-0.191/etc
ADD cassandra.properties $HOME/presto-server-0.191/etc/catalog
ADD node.properties $HOME/presto-server-0.191/etc
ENTRYPOINT ["/home/presto/presto-server-0.191/bin/launcher", "run"]

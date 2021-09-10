ARG python_version
ARG debian_release
FROM python:${python_version}-slim-${debian_release} as builder

RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl

ARG spark_version
ARG hadoop_version
RUN curl -fsSLo spark-dist.tar.gz https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz
RUN tar -xvf spark-dist.tar.gz --strip-components 1

FROM python:${python_version}-slim-${debian_release}

ARG jdk_version
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openjdk-${jdk_version}-jre-headless tini

RUN mkdir -p /opt/spark && \
    mkdir -p /opt/spark/work-dir && \
    touch /opt/spark/RELEASE

# adapted from https://github.com/apache/spark/blob/20b7b92/resource-managers/kubernetes/docker/src/main/dockerfiles/spark/Dockerfile#L45
COPY --from=builder jars /opt/spark/jars
COPY --from=builder bin /opt/spark/bin
COPY --from=builder sbin /opt/spark/sbin
COPY --from=builder kubernetes/dockerfiles/spark/entrypoint.sh /opt/
COPY --from=builder kubernetes/dockerfiles/spark/decom.sh /opt/
COPY --from=builder examples /opt/spark/examples
COPY --from=builder kubernetes/tests /opt/spark/tests
COPY --from=builder data /opt/spark/data

# add python bindings
# adapted from https://github.com/apache/spark/blob/d58a4a3/resource-managers/kubernetes/docker/src/main/dockerfiles/spark/bindings/python/Dockerfile#L33
COPY --from=builder python/pyspark /opt/spark/python/pyspark
COPY --from=builder python/lib /opt/spark/python/lib

# set env vars needed by entrypoint.sh
ENV SPARK_HOME /opt/spark
ENV JAVA_HOME /usr/lib/jvm/java-${jdk_version}-openjdk-amd64

WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir
RUN chmod a+x /opt/decom.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

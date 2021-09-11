# 🍠 tekumara spark docker images ✨

[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/tekumara/spark?style=plastic)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/tekumara/spark?style=plastic)](https://hub.docker.com/r/tekumara/spark)
[![Build](https://github.com/tekumara/spark-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/tekumara/spark-docker/actions/workflows/docker-publish.yml)

Docker images for Spark on Kubernetes based on the [official Python docker images](https://github.com/docker-library/python). Closely follows the [Spark Kubernetes docker image](https://spark.apache.org/docs/latest/running-on-kubernetes.html#docker-images) with Python bindings.

## Why?

Smaller than other similar images.

## Usage

Images are available from [docker hub](https://hub.docker.com/repository/docker/tekumara/spark/), eg:

```
docker pull tekumara/spark:3.1.2-hadoop3.2-java11-python3.8-bullseye
```

## Build

Build spark 3.1.2

```
spark_version=3.1.2 make build
```

MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help build describe test push

python_version ?= 3.8
debian_release ?= bullseye
spark_version ?= 3.1.2
hadoop_version ?= 3.2
jdk_version ?= 11
repo = tekumara/spark
tag = $(spark_version)-hadoop$(hadoop_version)-java$(jdk_version)-python$(python_version)-$(debian_release)

## build the docker image
build:
	docker buildx build . \
		--build-arg python_version=$(python_version)  \
		--build-arg debian_release=$(debian_release)  \
		--build-arg spark_version=$(spark_version)    \
		--build-arg hadoop_version=$(hadoop_version)  \
		--build-arg jdk_version=$(jdk_version)        \
		-t $(repo):$(tag)

## describe image
describe:
	docker images $(repo):$(tag)

## test docker image in client mode
test:
	docker run --rm $(repo):$(tag) driver /opt/spark/examples/src/main/python/pi.py

## push images to dockerhub
push:
	docker push --all-tags $(repo)

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

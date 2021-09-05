MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash -o pipefail
.DEFAULT_GOAL := help
.PHONY: help docker-build

## display help message
help:
	@awk '/^##.*$$/,/^[~\/\.0-9a-zA-Z_-]+:/' $(MAKEFILE_LIST) | awk '!(NR%2){print $$0p}{p=$$0}' | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort

## build the docker image
build:
	docker build . -t pyspark:3.1.2-hadoop3.2-java11-python3.8-buster

## describe image
describe:
	docker images pyspark:3.1.2-hadoop3.2-java11-python3.8-buster

## run latest docker image
run:
	docker run --rm -it pyspark:latest

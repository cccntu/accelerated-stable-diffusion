#!/usr/bin/make
USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
WORK_DIR := $(shell realpath --relative-base=${HOME} .)

# docker-compose can be installed with pip: `pip install docker-compose`
# but if you don't want to use docker-compose, you can use the following commands
build-test-runtime:
	docker build --target testruntime --build-arg USER_ID=${USER_ID} --build-arg GROUP_ID=${GROUP_ID} -f Dockerfile . --no-cache
build:
	docker build -t sd-image:latest --build-arg USER_ID=${USER_ID} --build-arg GROUP_ID=${GROUP_ID} -f Dockerfile .
run:
	docker run -it --rm --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 \
		-v ${HOME}:/home/user \
		-w /home/user/${WORK_DIR} \
		--user user \
		sd-image:latest bash
# the above commands should mount the home directory to the container
# and set the working directory to the current directory
# so you can run `make test` in the container, right after you run `make run`
test:
	python scripts/test.py
	USE_MEMORY_EFFICIENT_ATTENTION=1 python scripts/test.py
test-latency:
	python scripts/benchmark.py --samples 1
	USE_MEMORY_EFFICIENT_ATTENTION=1 python scripts/benchmark.py --samples 1

version:
	docker --version
	docker-compose --version
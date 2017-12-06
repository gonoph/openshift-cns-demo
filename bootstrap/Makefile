.PHONY: all build clean run
MAKEFILE_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))

DOCKERFILE?=Dockerfile
DOCKER_LABEL?=localhost/ocp-installer:latest

all: build

build: $(DOCKERFILE)
	docker build -t $(DOCKER_LABEL) -f $(DOCKERFILE) .

$(DOCKERFILE): $(DOCKERFILE).template
	sed -e "s,%%GID%%,`id -g`," -e "s,%%UID%%,`id -u`," $(DOCKERFILE).template > $(DOCKERFILE)

clean: $(DOCKERFILE).template
	rm -fv $(DOCKERFILE)

run: $(DOCKERFILE)
	[ -d /tmp/secrets.$$USER ] || mv -v `mktemp -d` /tmp/secrets.$$USER
	docker run --rm -it -v $(MAKEFILE_DIR)..:/tmp/install:Z -v /tmp/secrets.$$USER:/tmp/secrets:Z $(DOCKER_LABEL)

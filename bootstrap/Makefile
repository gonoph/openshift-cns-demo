.PHONY: all build clean run
MAKEFILE_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))

DOCKERFILE?=Dockerfile.centos
DOCKER_LABEL?=localhost/ocp-installer:latest

all: build

build: $(DOCKERFILE)
	docker build -t $(DOCKER_LABEL) -f $(DOCKERFILE) .

$(DOCKERFILE): $(DOCKERFILE).template
	sed -e "s,%%GID%%,`id -g`," -e "s,%%UID%%,`id -u`," $(DOCKERFILE).template > $(DOCKERFILE)

clean: $(DOCKERFILE).template
	rm -fv $(DOCKERFILE)

run: $(DOCKERFILE)
	docker run --rm -it -v $(MAKEFILE_DIR)..:/tmp/install:Z $(DOCKER_LABEL)
	echo $(MAKEFILE_DIR)

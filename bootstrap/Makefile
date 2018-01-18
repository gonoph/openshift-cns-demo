.PHONY: all build clean run
MAKEFILE_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))

DOCKERFILE?=Dockerfile
DOCKER_LABEL?=localhost/ocp-installer:latest

all: build

build: $(DOCKERFILE)
	docker build -t $(DOCKER_LABEL) -f $(DOCKERFILE) .

GID=$(shell id -g)
UID=$(shell id -u)
$(DOCKERFILE): $(DOCKERFILE).template
	sed -e "s,%%GID%%,$(GID)," -e "s,%%UID%%,$(UID)," $(DOCKERFILE).template > $(DOCKERFILE)

clean: $(DOCKERFILE).template
	rm -fv $(DOCKERFILE)

.ONESHELL:
run: $(DOCKERFILE)
	@T=`mktemp -d`
	trap 'rm -rfv $$T' EXIT
	cp -a ~/.ssh $$T
	err() { echo "$$@" >&2; exit 1; }
	V="-v $(MAKEFILE_DIR)/..:/tmp/install:Z"
	test -r $(MAKEFILE_DIR)/aws && cp $(MAKEFILE_DIR)/aws $$T && V+=" -v $$T/aws:/etc/profile.d/aws.sh:Z"
	D_HOME=`docker run --rm -i $(DOCKER_LABEL) /bin/sh -c 'echo $$HOME'`
	test -z "$$D_HOME" && err 'Unable to determine docker container HOME directory'
	V+=" -v $$T/.ssh:$$D_HOME/.ssh:Z"
	docker run --name=ocp-installer --rm -it $$V $(DOCKER_LABEL)

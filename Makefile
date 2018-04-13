.PHONY: $(PLAYBOOK_targets) all clean help test
MAKEFILE_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))

# DEBUG:=echo
FLAG_CREATE:=.flag-create
FLAG_CONFIG:=.flag-config
FLAG_OCP:=.flag-ocp
FLAG_POST:=.flag-post

PLAYBOOK_CLEAN:=clean.yml
PLAYBOOK_CREATE:=create.yml
PLAYBOOK_CONFIG:=config.yml
PLAYBOOK_OCP:=ocp.yml
PLAYBOOK_POST:=post_config.yml

PLAYBOOKS:=$(PLAYBOOK_CLEAN) $(PLAYBOOK_CREATE) $(PLAYBOOK_CONFIG) $(PLAYBOOK_OCP) $(PLAYBOOK_POST)
PLAYBOOK_flags:=$(FLAG_CREATE) $(FLAG_CONFIG) $(FLAG_OCP) $(FLAG_POST)

SCRIPT_TEST:=storage_test.sh

CREATE_DEPS:=~/.ssh

help:
	@echo "Usage: make (help|all|clean|create|config|ocp|post|test)"
	@echo "   help:     this help"
	@echo "   all:      run everything in the proper order"
	@echo "   clean:    clean up environment - delete EC2 instances"
	@echo "   create:   create the EC2 instances"
	@echo "   config:   configure the EC2 instances"
	@echo "   ocp:      run the OCP playbook on the EC2 instances"
	@echo "   post:     post configure OCP with some sane values"
	@echo "   test:     test that Storage is working"

all: create config ocp post test
clean: $(PLAYBOOK_CLEAN)
	$(DEBUG) ./demo.sh $<
	rm -f .flag-* *.retry
create: $(FLAG_CREATE)
config: create $(FLAG_CONFIG)
ocp: config $(FLAG_OCP)
post: ocp  $(FLAG_POST)
test: post
	$(DEBUG) ./$(SCRIPT_TEST) test

$(FLAG_CREATE): $(PLAYBOOK_CREATE) Makefile $(CREATE_DEPS)
$(FLAG_CONFIG): $(PLAYBOOK_CONFIG) Makefile
$(FLAG_OCP): $(PLAYBOOK_OCP) Makefile
$(FLAG_POST): $(PLAYBOOK_POST) Makefile

$(PLAYBOOK_flags):
	$(DEBUG) ./demo.sh $<
	touch $@

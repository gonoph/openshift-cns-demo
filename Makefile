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

EC2_INVENTORY:=inventory/demo
OCP_INVENTORY:=inventory/demo.ocp

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
	@echo "   myip:     helper target to add your current IP to the AWS VPC"
	@echo "   info:     helper target to get URL info"

all: create config ocp post test

clean create myip: INVENTORY_FILE=$(EC2_INVENTORY)
config ocp post test info: INVENTORY_FILE=$(OCP_INVENTORY)

clean: $(PLAYBOOK_CLEAN)
	$(DEBUG) ansible-playbook -i $(INVENTORY_FILE) $<
	rm -f .flag-* *.retry
create: $(EC2_INVENTORY) $(FLAG_CREATE)
config: create $(OCP_INVENTORY) $(FLAG_CONFIG)
ocp: config $(OCP_INVENTORY) $(FLAG_OCP)
post: ocp  $(OCP_INVENTORY) $(FLAG_POST)
test: post
	$(DEBUG) ./$(SCRIPT_TEST) test
myip:
	$(DEBUG) ansible-playbook -i $(INVENTORY_FILE) create.yml --tags=ec2_network,untagged
info:
	$(DEBUG) ansible-playbook -i $(INVENTORY_FILE) post_config.yml --tags=post_info

$(FLAG_CREATE): $(PLAYBOOK_CREATE) $(EC2_INVENTORY) Makefile $(CREATE_DEPS)
$(FLAG_CONFIG): $(PLAYBOOK_CONFIG) $(OCP_INVENTORY) Makefile
$(FLAG_OCP): $(PLAYBOOK_OCP) $(OCP_INVENTORY) Makefile
$(FLAG_POST): $(PLAYBOOK_POST) $(OCP_INVENTORY) Makefile
OCP_INVENTORY: $(PLAYBOOK_CONFIG)

$(PLAYBOOK_flags):
	$(DEBUG) ansible-playbook -i $(INVENTORY_FILE) $<
	touch $@

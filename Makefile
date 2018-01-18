.PHONY: $(PLAYBOOK_targets) all clean help
MAKEFILE_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))

FLAG_CREATE:=.flag-create
FLAG_CONFIG:=.flag-config
FLAG_OCP:=.flag-ocp
FLAG_POST:=.flag-post
FLAG_CNS_PRE:=.flag-cns-pre
FLAG_CNS:=.flag-cns

PLAYBOOK_CLEAN:=clean.yml
PLAYBOOK_CREATE:=create.yml
PLAYBOOK_CONFIG:=config.yml
PLAYBOOK_OCP:=ocp.yml
PLAYBOOK_POST:=post_config.yml
PLAYBOOK_CNS_PRE:=cns_prepare.yml

PLAYBOOKS:=$(PLAYBOOK_CLEAN) $(PLAYBOOK_CREATE) $(PLAYBOOK_CONFIG) $(PLAYBOOK_OCP) $(PLAYBOOK_POST) $(PLAYBOOK_CNS_PRE)
PLAYBOOK_flags:=$(FLAG_CREATE) $(FLAG_CONFIG) $(FLAG_OCP) $(FLAG_POST) $(FLAG_CNS_PRE)

SCRIPT_CNS:=script_cns.sh

help:
	@echo "Usage: make (help|all|clean|create|config|ocp|post|cns-pre|cns|test)"
	@echo "   help:     this help"
	@echo "   all:      run everything in the proper order"
	@echo "   clean:    clean up environment - delete EC2 instances"
	@echo "   create:   create the EC2 instances"
	@echo "   config:   configure the EC2 instances"
	@echo "   ocp:      run the OCP playbook on the EC2 instances"
	@echo "   post:     post configure OCP with some sane values"
	@echo "   cns-pre:  pre-configure the storage hosts for CNS"
	@echo "   cns:      install CNS on the hosts"
	@echo "   test:     test that CNS is working"

all: create config ocp post cns-pre cns test
clean: $(PLAYBOOK_CLEAN)
	./demo.sh $<
	rm -f .flag-*
create: $(FLAG_CREATE)
config: $(FLAG_CONFIG)
ocp: $(FLAG_OCP)
post: $(FLAG_POST)
cns-pre: $(FLAG_CNS_PRE)
cns: $(FLAG_CNS)

$(FLAG_CREATE): $(PLAYBOOK_CREATE)
$(FLAG_CONFIG): $(PLAYBOOK_CONFIG)
$(FLAG_OCP): $(PLAYBOOK_OCP)
$(FLAG_POST): $(PLAYBOOK_POST)
$(FLAG_CNS_PRE): $(PLAYBOOK_CNS_PRE)
$(FLAG_CNS): $(SCRIPT_CNS)
	echo ./$<
	touch $@

$(PLAYBOOK_flags):
	echo ./demo.sh $<
	touch $@

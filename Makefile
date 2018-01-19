.PHONY: $(PLAYBOOK_targets) all clean help test
MAKEFILE_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))

# DEBUG:=echo
FLAG_CREATE:=.flag-create
FLAG_CONFIG:=.flag-config
FLAG_OCP:=.flag-ocp
FLAG_POST:=.flag-post
FLAG_CNS_PRE:=.flag-cns-pre
FLAG_CNS:=.flag-cns
FLAG_CNS_POST:=.flag-cns-post

PLAYBOOK_CLEAN:=clean.yml
PLAYBOOK_CREATE:=create.yml
PLAYBOOK_CONFIG:=config.yml
PLAYBOOK_OCP:=ocp.yml
PLAYBOOK_POST:=post_config.yml
PLAYBOOK_CNS_PRE:=cns_prepare.yml
PLAYBOOK_CNS_POST:=cns_post.yml

PLAYBOOKS:=$(PLAYBOOK_CLEAN) $(PLAYBOOK_CREATE) $(PLAYBOOK_CONFIG) $(PLAYBOOK_OCP) $(PLAYBOOK_POST) $(PLAYBOOK_CNS_PRE) $(PLAYBOOK_CNS_POST)
PLAYBOOK_flags:=$(FLAG_CREATE) $(FLAG_CONFIG) $(FLAG_OCP) $(FLAG_POST) $(FLAG_CNS_PRE) $(FLAG_CNS_POST)

SCRIPT_CNS:=script_cns.sh

CREATE_DEPS:=~/.ssh

help:
	@echo "Usage: make (help|all|clean|create|config|ocp|post|cns-pre|cns|cns-post|test)"
	@echo "   help:     this help"
	@echo "   all:      run everything in the proper order"
	@echo "   clean:    clean up environment - delete EC2 instances"
	@echo "   create:   create the EC2 instances"
	@echo "   config:   configure the EC2 instances"
	@echo "   ocp:      run the OCP playbook on the EC2 instances"
	@echo "   post:     post configure OCP with some sane values"
	@echo "   cns-pre:  pre-configure the storage hosts for CNS"
	@echo "   cns:      install CNS on the hosts"
	@echo "   cns-post: post-configure the storage hosts for CNS"
	@echo "   test:     test that CNS is working"

all: create config ocp post cns-pre cns cns-post test
clean: $(PLAYBOOK_CLEAN)
	$(DEBUG) ./demo.sh $<
	rm -f .flag-* *.retry
create: $(FLAG_CREATE)
config: create $(FLAG_CONFIG)
ocp: config $(FLAG_OCP)
post: ocp  $(FLAG_POST)
cns-pre: post $(FLAG_CNS_PRE)
cns: cns-pre $(FLAG_CNS)
cns-post: cns $(FLAG_CNS_POST)
test: cns-post
	$(DEBUG) ./$(SCRIPT_CNS) test

$(FLAG_CREATE): $(PLAYBOOK_CREATE) Makefile $(CREATE_DEPS)
$(FLAG_CONFIG): $(PLAYBOOK_CONFIG) Makefile
$(FLAG_OCP): $(PLAYBOOK_OCP) Makefile
$(FLAG_POST): $(PLAYBOOK_POST) Makefile
$(FLAG_CNS_PRE): $(PLAYBOOK_CNS_PRE) Makefile
$(FLAG_CNS_POST): $(PLAYBOOK_CNS_POST) Makefile
$(FLAG_CNS): $(SCRIPT_CNS) Makefile
	$(DEBUG) ./$<
	touch $@

$(PLAYBOOK_flags):
	$(DEBUG) ./demo.sh $<
	touch $@

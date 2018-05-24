.phony: all

DEMO_CERTS?=.
EASY_RSA?=../easy-rsa/easyrsa3/easyrsa
EASY_RSA_ARGS?=--pki-dir=$(EASY_RSA_PKI) \
	       --batch \
	       --days=30 \
	       --dn-mode=org \
	       --req-c=US \
	       --req-st=NC \
	       --req-city=Raleigh \
	       --req-org=Openshift \
	       --req-ou=Demo \
	       --req-email=''

MASTER_PKI:=$(DEMO_CERTS)/pki.master
MASTER_CA:=$(MASTER_PKI)/ca.crt
MASTER_CLUSTER_TAG:=ocp-ca
MASTER_CLUSTER_REQ:=$(MASTER_PKI)/reqs/$(MASTER_CLUSTER_TAG).req
MASTER_CLUSTER_CRT:=$(MASTER_PKI)/issued/$(MASTER_CLUSTER_TAG).crt

CLUSTER_PKI:=$(DEMO_CERTS)/pki.cluster
CLUSTER_CA:=$(CLUSTER_PKI)/ca.crt
CLUSTER_REQ:=$(CLUSTER_PKI)/reqs/ca.req
CLUSTER_CA_BUNDLE:=$(CLUSTER_PKI)/ca-bundle.crt


all: $(MASTER_CA) $(CLUSTER_CA) $(CLUSTER_CA_BUNDLE)

$(MASTER_PKI) \
	$(MASTER_CA) \
	$(MASTER_CLUSTER_REQ) \
	$(MASTER_CLUSTER_CRT) \
	: EASY_RSA_PKI=$(MASTER_PKI)

$(CLUSTER_PKI) \
	$(CLUSTER_CA) \
	$(CLUSTER_REQ): EASY_RSA_PKI=$(CLUSTER_PKI)

# $(MASTER_PKI) $(CLUSTER_PKI):

$(MASTER_CA): # $(MASTER_PKI)
	$(EASY_RSA) $(EASY_RSA_ARGS) init-pki
	$(EASY_RSA) $(EASY_RSA_ARGS) --req-cn='Master CA' build-ca nopass

$(CLUSTER_REQ): # $(CLUSTER_PKI)
	$(EASY_RSA) $(EASY_RSA_ARGS) init-pki
	$(EASY_RSA) $(EASY_RSA_ARGS) --req-cn='Openshift CA' build-ca subca nopass

$(MASTER_CLUSTER_REQ): $(CLUSTER_REQ)
	test -r $(MASTER_CLUSTER_REQ) && rm -f $(MASTER_CLUSTER_REQ) || true
	$(EASY_RSA) $(EASY_RSA_ARGS) import-req $(CLUSTER_REQ) $(MASTER_CLUSTER_TAG)

$(MASTER_CLUSTER_CRT): $(MASTER_CLUSTER_REQ)
	test -r $(MASTER_CLUSTER_CRT) && $(EASY_RSA) $(EASY_RSA_ARGS) revoke $(MASTER_CLUSTER_TAG) || true
	$(EASY_RSA) $(EASY_RSA_ARGS) sign-req ca $(MASTER_CLUSTER_TAG)

$(CLUSTER_CA): $(MASTER_CLUSTER_CRT)
	T=`mktemp` \
	  && trap "rm -rf $$T" EXIT \
	  && openssl x509 -in $(MASTER_CLUSTER_CRT) -text > $$T \
	  && cp $$T $@

$(CLUSTER_CA_BUNDLE): $(CLUSTER_CA) $(MASTER_CA)
	T=`mktemp` \
	  && trap "rm -rf $$T" EXIT \
	  && openssl x509 -in $(CLUSTER_CA) > $$T \
	  && openssl x509 -in $(MASTER_CA) >> $$T \
	  && cp $$T $@

clean:
	rm -rf $(MASTER_PKI) $(CLUSTER_PKI)

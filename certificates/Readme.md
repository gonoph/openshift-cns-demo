# Custom CA Certificates
This directory handles the creation of the custom certificates.

# Why a Makefile
True, I was creating the certificates using an Ansible role as part of a larger
playbook, but I decided this was incorrect.

The ultimate output or deliverable of this process is a set of x509
certificates for use in the OCP installation. Given that context, I decided to
treat this part of the process as a code or package deliverable. In that
scenario, I would typically use a build process (like make) in order to
generate that output.

# Why generate certificates?

Most organiations have their own internal Certificate Authority (CA). They use this to:

* sign code
* protect internal assets
* authorize users (client certificates)
* ensure a complete chain of trust
* control this chain of trust
* revoke certificates
* enforce data security and governance

Typically, this IT organization will generate server and client certificates
for you. They will manage the lifecycle of these certificates, and will perform
the task of distributing updated master CAs and revocation lists across the
organization.

Sometimes, they delegate part of this concern to other departments. Typically,
this is done, because the department may have a faster issuance cadence than
the parent team can provide, or perhaps the department requires special
authorizations, and they can control their own governance by issuing their own
server and client certificates without delegating access to other teams or the
parent team.

Regardless, the issue is plain: companies typically have a parent (master) CA,
and then generate sub-CA's for other departments for various purposes. 

# Implementation in the demo

So for the demo, I create a fake `Master CA` and a fake `Openshift CA`. The
`Master CA` signs the `Openshift CA`, and then the Openshift installation uses
the `Openshift CA` instead of "auto-generating" a self-signed CA. This does
several things:

1. It configures Openshift similar to how a real IT organization would probably want it configured (a sub-CA delegated and signed by the corporate CA). 
2. If you tell your browser to trust the Master CA (corporate CA), then you automatically trust the Openshift CA, and all certificates it generates.
3. If you do (2) above, then all the metrics in the UI work (since your browser trusts the certificate), and any apps you create and open in the browser also work without additionally "trust this certificate" dialogs.

# The Process

In order to create a sub-CA, first you need a Master CA, then it needs to sign it, then place the resultant signed-sub-CA in the right place, and finally create a `ca-bundle.crt` that contains the trusted certificate chain.

* Create Master CA.
* Create sub CA request.
* Sign the sub CA request by the Master CA.
* Copy the sub CA signed certificate into the right location.
* Create a `ca-bundle.crt` that contains the CA trust chain, so we can install that sub CA inside Openshift.

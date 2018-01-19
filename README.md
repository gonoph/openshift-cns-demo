# ocp-demo
Demo of OCP and CNS

# About this project

The goal of this project is to help you test out Openshift Container Platorm
(OCP) and Container Native Storage (CNS). It's using the opensource upstreams
of the Red Hat products, as I'm not sure if the Developer Subscription or the
CDK offers access to the production bits. I recommend using the supported bits
as I've had to pin my dependency to the upstream projects to specific commit
versions in order to make sure everything runs smoothly.

# bootstrap docker image

There's a docker image under `/bootstrap` that you can use to create an install
environment. Since this demo is designed to run on AWS, I typically have a
small EC2 or lightsail instance on AWS that I use for the installs.

[Look at the bootstrap directory for more information](./bootstrap/)

# Usage

Everything should work out if you use the `Makefile`.

```base
# edit variables
vi inventory/demo
make help
make all
```

# Important inventory variables

1. `ansible_user` - the initial `ansible_user` for the VMs (ec2 is normally NOT root).
2. `private_ip_start` - the start address for the hosts in the ec2 group (so we
   can have static addresses across boots).
3. `ec2_mynetworks` - list of networks/hosts to allow access to the demo EC2 VMs
4. `ec2_ami_image` - the EC2 ami image, currently using the Fedora 27 Atomic
   image, you may need to update it.
5. `ec2_instance_type` - the ec2 instance type, currently the dns server needs
   t2.micro, and the OCP VMs use m4.large
6. `storage_routes` - This is used to add entries to the hosts file. It's most
   useful without dns, and running in the bootstrap container.

# Explaination of playbooks

1. `clean.yml`: playbook to clean up the EC2 instances and the local environment.
2. `create.yml`: playbook to create all the EC2 instances for the demo. It will
   also configure the local environment by adding the hosts to the `ssh/config`
   and the `/etc/hosts`
3. `config.yml`: playbook to configure the dns server and OCP instances.
4. `ocp.yml`: playbook to read in EC2 instances and then run the OCP install playbook.
5.  `post_config.yml`: playbook to post-configure the OCP instance by adding an
    admin user, copying the ca.crt, and log in.
6. `cns_prepare.yml`: playbook to prepare OCP to run the CNS deployment script.
6. `cns_post.yml`: playbook to add a storage class and prepare OCP to run the
   CNS deployment script.

The inventory is in `inventory/demo` and it contains all the hosts for the
demo, currently configured for AWS EC2 with one small dns VM, ond 3 4 core VMs
(master + two nodes).

# Getting Help

**DISCLAIMER**: I'm a Red Hat Solutions Architect. It's my job to introduce Red
Hat customers to Red Hat products, and help them gain the most value from these
products. I am not support, nor releasing this as a reprepsentative of Red Hat.
Thus I cannot help you use this playbook in production, enterprise, PoC, or
bake-off situation. I will gladly help you get in contact with someone at Red
Hat that **CAN** help you do these things.

The purpose of this playbook is to build a demo and experimental environment to
show the value of OCP and CNS backed by gluster. If you have any questions or
run into issues running this playbook to achieve that goal, then please create
a GitHub issue so I can address it!

If you have other questions or issues with OCP or CNS in general, I'll gladly
help you reach the correct resource at Red Hat!

# openshift-cns-demo
Demo of Openshift Container Platform (OCP) and Container Native Storage (CNS)

# About this project

The goal of this project is to help you test out Openshift Container Platorm
(OCP) and Container Native Storage (CNS). It's using the opensource upstreams
of the Red Hat products, as I'm not sure if the Developer Subscription or the
CDK offers access to the production bits in a way that allows an operations guy
to fully install a cluster like this. I recommend using the supported bits as
I've had to pin my dependency to the upstream projects to specific branches in
order to make sure everything runs smoothly.

# bootstrap docker image

There's a docker image under `/bootstrap` that you can use to create an install
environment. Since this demo is designed to run on AWS, I typically have a
small EC2 or lightsail instance on AWS that I use for the installs.

[Look at the bootstrap directory for more information](./bootstrap/)

# Understanding AWS and Ansible

Ansible will expect to be able to log into your EC2 instances. The easiest way
to do this is to use the same SSH key you use to create the EC2 instances as
the same SSH key you use for Ansible. The supplied Docker image in the
bootstrap tries to help you do this by:

* link/copy the current users `~/.ssh/` into the container
* run `ssh-agent` as the starting shell
* allow you to `ssh-add` your key (if it's not the default `~/.ssh/id_rsa`

# Layout of the demo

[Checkout the Layout directory for more information](./layout/)

# Usage

Clone this repository:
```bash
git clone --recursive http://github.com/gonoph/openshift-cns-demo.git
cd openshift-cns-demo
```

Optionally, then build and run the included docker bootstrap image:

```bash
cd bootstrap
cp aws.sample aws
# edit your aws information
vi aws
make
make run
```
Everything should work out if you use the `Makefile`.

```bash
# optional 
ssh-add ~/.ssh/id_rsa.ansible
# edit variables
vi inventory/demo
make help
make all
```

# Important inventory variables

## Required variables
You may or may not want to change these from what's defined in the inventory.

| Variable | inventory | Description |
| ---- | ---- | ---- |
| ansible_user | cloud-user | EC2 instances normally don't let you run as root |
| ec2_ami_image | RHEL 7.4 Atomic (Cloud Access) | the EC2 ami image - you may need to update it. |
| ec2_instance_type | t2.micro/t2.medium | the ec2 instance type, currently the dns server can be t2.micro, and the OCP VMs can be m4.medium / t2.medium |
| ec2_vpc_id | Single VPC | this is the vpc you want your instance to run. If you only have **ONE SINGLE** VPC in your AWS region, then you can leave this default. Otherwise, you will need to define this. |
| private_ip_start | 10 | the start address for the hosts in the ec2 group (so we can have static addresses across boots) |

## Optional variables
You may want to change these defaults, but they defined to sane values in the inventory file.

| Variable | Role | Default | Description |
| -------- | ---- | ------- | ----------- |
| ec2_demo_tag | ec2 | ocp | The tag to apply to the EC2 instances for create, lookups, and destroy. |
| ec2_keypair | ec2 | ansible-dev | The SSH Keypair the EC2 instances will use at creation. You must upload or create this key in EC2. I find it easier to use the same private / public key as what you're already using. |
| ec2_mynetworks | ec2 | [ ] | list of networks/hosts to allow access to the demo EC2 VMs. The playbook will automatically include the current host upon which ansible is run. |
| ec2_public_ip | ec2 | True | Set to false if you don't want a public IP. Though, you'll need a VPN into the VPC at that point. How to do that is beyond this demo. If you don't know what this means, I suggest keeping it at defaults. |
| ec2_region | ec2 | us-east-1 | Which region to create the EC2 instances. |
| ec2_vpc_subnet | ec2 | First subnet | playbook will select the **FIRST** subnet it finds in the VPC, unless you define it here. |
| ec2_wait | ec2 | 300 | How long to wait for EC2 to finish creating the instances. |
| demo_certificates | ec2/local | ./certificates | The directory to persist the created PKI certificates. |
| hostname | ec2/local | {{ inventory_hostname }}.example.com | our pleasantly defined hostname |
| local_custom_certificates | local | True | Controls the creation of the custom CA |
| ocp_app_domain | local | apps.{{ ocp_domain }} | Domain of app domain for OCP |
| ocp_domain | local | (nil) | Domain of public cluster URL |
| openshift_release | local | 3.7 | Release version of OCP to install |

# Explanation of playbooks

| playbook | Purpose |
| -------- | ----------- |
| clean.yml | To clean up the EC2 instances and the local environment. |
| create.yml | To create all the EC2 instances for the demo. It will also configure the local environment by adding the hosts to the `ssh/config` and the `/etc/hosts` |
| config.yml | To configure the dns server and OCP instances. |
| ocp.yml | To read in EC2 instances and then run the OCP install playbook. |
| post_config.yml | To post-configure the OCP instance by adding an admin user, copying the ca.crt, and log in. |

# Default Inventory

| Host | AWS type | vCPU | Memory | Purpose |
| ---- | -------- | ---- | ------ | ------- |
| dns1 | t2.micro | 1 | 1GiB | dns, haproxy, certserv |
| master1,2,3 | t2.medium | 2 | 4GiB | OCP master, CNS storage |
| node1,2,3 | t2.medium | 2 | 4GiB | OCP node, Infrastruture |

# Inventory Variables you'll probably need to change 

| Variable | Why change? |
| -------- | ----------- |
| ec2_ami_image | You need [Red Hat Cloud Access][1] in order to see the supplied image. |
| ansible_user | If you change the image above, you'll need to know the login user (ex: ec2-user, cloud-user) |
| ec2_demo_tag | If you change this, then you can run multiple of these clusters in AWS at the same time. You'll have to add it to the `ec2` group in the inventory file. |
| private_ip_start | If you change the above, then you'll need to change this variable, too, probably. |
| ec2_instance_type | If you want beefier VMs. With the current inventory defaults, it costs me $7.50 per day as of May 17th, 2018. |

[1]: https://www.redhat.com/en/technologies/cloud-computing/cloud-access

# Getting Help

**DISCLAIMER**: I'm a Red Hat Solutions Architect. It's my job to introduce Red
Hat customers to Red Hat products, and help them gain the most value from these
products. I am not support, nor releasing this as a representative of Red Hat.
Thus, I cannot help you use this playbook in production, enterprise, PoC, or
bake-off situation. I will gladly help you get in contact with someone at Red
Hat that **CAN** help you do these things.

The purpose of this playbook is to build a demo and an experimental environment
to show the value of OCP and CNS backed by gluster. If you have any questions
or run into issues running this playbook to achieve that goal, then please
create a GitHub issue so I can address it!

If you have other questions or issues with OCP or CNS in general, I'll gladly
help you reach the correct resource at Red Hat!


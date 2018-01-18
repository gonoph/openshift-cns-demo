# Usage bootstrap image

This image is designed to be fully able to run the playbooks for this demo.

It uses the following environment varibles:

- `AWS_ACCESS_KEY` for your access key into AWS
- `AWS_SECRET_KEY` for the secret key to the access key

Together, they allow the playbooks to create and manage AWS resources for the demo.

If you copy the `aws.sample` file to `aws`, then the `Makefile` will automatically ensure that the container when ran has those environments set.

```bash
cd bootstrap
cp aws.sample aws
vi aws
# edit the KEYS and save
```

To run the bootstrap:

```bash
cd bootstrap
make
make run
```
# Usage playbooks

You should just need to run `site.yml` to configure the ec2 instances, install OCP, then prepare them for CNS.

There's a handy script to help:

```bash
./install
```

And when you're done:

```bash
./clean.sh
```
# Explaination of playbooks:

1. `inventory/demo` - contains all the hosts for the demo, currently configured for AWS EC2 with one small dns VM, ond 3 4 core VMs (master + two nodes).
2. `clean.yml` - cleans up the inventory, removes everything
3. `create.yml` - creates the VMs and prepares them to run the OCP playbook
4. `/usr/share/ansible/openshift-ansible/playbooks/byo/config.yml` - the actual OCP installer playbook
5. `post_configure.yml` - post installer, assigns admin role to admin user
6. `site.yml`- runs all the playbooks above (except for clean.yml)

# Important variables inventory variables

1. `ansible_user` - the initial `ansible_user` for the VMs (ec2 is normally NOT root).
1. `private_ip_start` - the start address for the hosts in the ec2 group (so we can have static addresses across boots).
3. `ec2_mynetworks` - list of networks/hosts to allow access to the demo EC2 VMs
4. `ec2_ami_image` - the EC2 ami image, currently using the Fedora 27 Atomic image, you may need to update it.
5. `ec2_instance_type` - the ec2 instance type, currently the dns server needs t2.micro, and the OCP VMs use m4.large
6. `storage_routes` - This is used to add entries to the hosts file. It's most useful without dns, and running in the bootstrap container.



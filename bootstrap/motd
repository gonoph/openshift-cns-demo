= Using this installer image

If you're using EC2, you will need to add the following:

* export AWS_ACCESS_KEY and AWS_SECRET_KEY as environment variables prior to running the playbook or this container
* or, better yet, create a secret.yml and add the SECRETS variable on the command line to point to it.

    ansible-playbook -e SECRETS=/tmp/secrets/secrets.yml --ask-vault-pass .... [ other options ]

or

    ansible-playbook -e SECRETS=/tmp/secrets/secrets.yml --vault-password-file=/tmp/secrets/secrets.pass .... [ other options ]

= Explaination of playbooks:

1. inventory/demo - contains all the hosts for the demo, currently configured for AWS EC2 with one small dns VM, ond 3 4 core VMs (master + two nodes).
2. clean.yml - cleans up the inventory, removes everything
3. create.yml - creates the VMs and prepares them to run the OCP playbook
4. /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml - the actual OCP installer playbook
5. post_configure.yml - post installer, assigns admin role to admin user
6. site.yml - runs all the playbooks above (except for clean.yml)

= Important variables inventory variables

1. ansible_user - the initial ansible_user for the VMs (ec2 is normally NOT root).
2. ec2_mynetworks - list of networks/hosts to allow access to the demo EC2 VMs
3. ec2_ami_image - the EC2 ami image, currently using the Fedora 27 Atomic image, you may need to update it.
4. ec2_instance_type - the ec2 instance type, currently the dns server needs t2.micro, and the OCP VMs use m4.large



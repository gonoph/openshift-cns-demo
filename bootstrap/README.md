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

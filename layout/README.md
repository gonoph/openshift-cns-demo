# Layout of the demo

You can architect this however you want, but I tried to go minimum as possible
to show CNS. This requires at least 3 nodes in the OCP cluster, with one being
a master. You would not do this type of setup in production. In production, you
would have 3 masters, your own custom CA certificate, multiple storage devices
on dedicated storage nodes, and probably a hardware load balancer (or an AWS
ELB instance).

I needed to create a stand alone system to act as DNS, since I'm using
hostnames that don't exist. OCP expects all the hostnames to resolve properly.
I also setup the host to act as a simple haproxy load balancer, so if you
decide to attempt a more daring architecture, you at least have a software
based loadbalancer to start with.

# List of systems

So the systems are as follows:

* `dns.example.com` - the authoritative dns server for the demo as well as a
  software LB.
* `master.example.com` - the master OCP host which also acts as an OCP node.
* `node[1-2].example.com` - two worker nodes in the OCP cluster.

# Visual graph

I created this with [Graphviz](http://graphviz.org/) from this
[layout.dot](./layout.dot) file.

![alt text](https://github.com/gonoph/openshift-cns-demo/raw/master/layout/layout.png "Graphviz layout image")


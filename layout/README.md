# Layout of the demo

You can architect this however you want, but to test 3.7, I ended up needing more RAM than the systems I used in the 3.6 demo. It was (slightly) cheaper for me to double the number of systems rather than double RAM for each system. I figured this would also give me more vCPUs and IOPS. Therefore, I decided to create a 3-node master with 3-infra nodes.

For a production setup, you'd run your applicaiton workloads on non-infra nodes, and definately not the masters. A typical highly available infrasture could consist of (3) masters, (3) etcd systems, (3) infrastruture only nodes, (3) storage nodes, and the rest - application nodes. You'd also have your own custom CA certificate, multiple storage devices on dedicated storage nodes, and probably a hardware load balancer (or an AWS ELB instance).

For the demo, I'm doing this with 6 nodes: (3) masters/storage/etcd, (3) infrastrure/application nodes. With enough RAM, you could even do it with less, and if you don't need an HA master setup, you could do it with one master node - though the gluster storage requires 3 nodes at minimum.

I also decided to play around with EasyRSA, an OpenSSL project, that will automatically create a Custom Root CA, and a custom intermediary CA. The idea here to mimic a production environment where:

- Corporate IT maintains a Company Master CA.
- Company Master CA issues Openshift operations group a sub-CA: Openshift-CA.
- Install Openshift using the Openshift-CA issued by the Company Master CA.

I also wrote a small script that delivers the CA bundle if you go to http://$cluster_address/ca/ or to http://dns1/ca/. This was purely for convience when showing a demo, so I could easily obtain the ca.crt and import it into the browser.

I needed to create a stand alone system to act as DNS, since I'm using
hostnames that don't exist. OCP expects all the hostnames to resolve properly.
I also setup the host to act as a simple haproxy load balancer, so if you
decide to attempt a more daring architecture, you at least have a software
based loadbalancer to start with. I also changed the hostname to based on http://nip.io in order to show the demo easier. The drawback is that if you stop and then restart any of the VMs in the cluster, then they will probably get different public IPs, and the whole thing will break (as the SSL certificates won't match).

# List of systems

So the systems are as follows:

* `dns1` - the authoritative dns server for the demo as well as a software LB.
* `master[1:3]` - the master OCP hosts which also act as storage nodes.
* `node[1:3]` - the worker nodes in the OCP cluster, which are also 'infra' nodes.

# Visual graph

I created this with [Graphviz](http://graphviz.org/) from this
[layout.dot](./layout.dot) file.

![alt text](https://github.com/gonoph/openshift-cns-demo/raw/master/layout/layout.png "Graphviz layout image")


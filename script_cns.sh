#!/bin/sh

detail() {
	echo "##########"
	echo "###" "$@"
	echo "##########"
}

detail "Configuring nodes for storage"
./demo.sh cns-configure.yml

detail "Running deploy script for storage"
./gluster-kubernetes/deploy/gk-deploy -g /tmp/topology.json  -n storage -y

detail "Creating test PVC - claim1"

/usr/bin/oc create -f - << YAML
apiVersion: "v1"
kind: "PersistentVolumeClaim"
metadata:
  name: "claim1"
spec:
  accessModes:
    - "ReadWriteOnce"
  resources:
    requests:
      storage: "5Gi"
YAML

CURRENT=$(date +%s)
END=$[ $CURRENT + 10 ]

T=$(mktemp)
cleanup() { rm -f $T ; }
trap cleanup EXIT

detail "Waiting for claim to be bound"
while /usr/bin/oc get pv,pvc | tee $T ; do
	grep -q 'claim1 *Bound' $T && break
	[ $CURRENT -gt $END ] && break
	sleep 1 || break
done

detail "Remove it by running:"
echo oc delete pvc claim1

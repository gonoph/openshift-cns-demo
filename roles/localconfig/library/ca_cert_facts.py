#!/usr/bin/env python
# vim: sw=4 ai ts=4 expandtab

from os.path import isfile
from collections import namedtuple

KEY_LIST = ['certfile', 'keyfile', 'cafile']

def list_in_dict(l, d):
    if d is None:
        return False
    return reduce(
            lambda x, y: x == y == True,
            map(lambda z: z in d, l)
            )


Results = namedtuple('Results', ['missing', 'ok', 'paths'])
def files_exist_in_dict(d):
    missing=[]
    paths=[]
    for k in KEY_LIST:
        if k in d:
            p = d[k]
            paths.append(p)
            if not isfile(p):
                missing.append(k)
    return Results(missing, len(missing) == 0, paths)

def main():
    module = AnsibleModule(
        argument_spec=dict(
            openshift_master_ca_certificate=dict(type='dict', required=False),
            openshift_hosted_router_certificate=dict(type='dict', required=False),
            ),
        supports_check_mode=True,
    )

    try:
        has_master_ca = has_router_cert = False
        need_pki_master = need_pki_router = Results([], True, [])
        ret=dict( changed=False, failed=False, ansible_facts={})

        if 'openshift_master_ca_certificate' in module.params:
            has_master_ca = list_in_dict(KEY_LIST[0:2], module.params['openshift_master_ca_certificate'])
            if has_master_ca:
                need_pki_master = files_exist_in_dict(module.params['openshift_master_ca_certificate'])
        if 'openshift_hosted_router_certificate' in module.params:
            has_router_cert = list_in_dict(KEY_LIST, module.params['openshift_hosted_router_certificate'])
            if has_router_cert:
                need_pki_router = files_exist_in_dict(module.params['openshift_hosted_router_certificate'])

        ret['changed'] = not (need_pki_router.ok and need_pki_master.ok)
        ret['ec2_cert_has_master_ca'] = has_master_ca
        ret['ec2_cert_has_router_cert'] = has_router_cert
        ret['ec2_cert_missing'] = dict(master=need_pki_master.missing, router=need_pki_router.missing)
        ret['ec2_cert_paths'] = dict(master=need_pki_master.paths, router=need_pki_router.paths)
        module.exit_json(**ret)

    except Exception, e:
        module.fail_json(msg=str(e))

from ansible.module_utils.basic import *
if __name__ == "__main__":
    main()

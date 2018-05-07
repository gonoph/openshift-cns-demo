#!/usr/bin/python
# vim: sw=2 ts=2 expandtab
# -*- coding: utf-8 -*-
'''
Custom filters for use in OCP Demo
'''
from collections import Mapping
from ansible import errors
class FilterModule(object):
  ''' Custom ansible filter to convert public_ip fact from nodes into X509v3 Subject Alternative Names'''

  @staticmethod
  def ip_to_altnames(hostvars, group='ec2'):
    if not isinstance(hostvars, Mapping):
      raise errors.AnsibleFilterError("|failed expects hostvars is dictionary or object")
    if not isinstance(group, str):
      raise errors.AnsibleFilterError("|failed expects group to be string")
    groups = hostvars.items()[0][1]['groups']
    if group not in groups:
      raise errors.AnsibleFilterError("|failed unable to find `%s` group in groups" % group)

    ips = list(set(filter(lambda x: len(x) > 0,
          map(lambda h: hostvars[h]['public_ip'] if 'public_ip' in hostvars[h] else '', groups[group])
          )))

    return map(lambda t: 'IP:'+t, ips) + map(lambda t: 'DNS:'+t, ips)

  def filters(self):
    ''' filters hostvars by group to extract the public_ip into an array suitable for X509v3 Subject Alternative Name '''
    return {'ip_to_altnames': self.ip_to_altnames}

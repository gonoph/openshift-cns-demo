#!/usr/bin/python
# vim: sw=2 ts=2 expandtab
# -*- coding: utf-8 -*-
'''
Custom filters for use in openshift_hosted
'''
class FilterModule(object):
    ''' Custom ansible filters for use by ec2 role'''

    @staticmethod
    def converter(v_arr = [], i_arr = []):
        if not v_arr:
            return [], i_arr
        p=pow(10, (len(v_arr)-1)*3)
        v = v_arr[0]
        i = int(v) * p
        return FilterModule.converter(v_arr[1:], i_arr+[i])

    @staticmethod
    def version_to_int(version):
        return reduce((lambda x,y: x+y), FilterModule.converter(str(version).split('.'))[1])

    def filters(self):
        ''' converts a dotted version string to a number that can be sorted based on power of 10 '''
        return {'to_version': self.version_to_int}

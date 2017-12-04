#!/bin/sh

exec ansible-playbook -i inventory/demo "$@"

#!/bin/sh

exec ansible-playbook --vault-password-file=/tmp/vault.txt "$@"

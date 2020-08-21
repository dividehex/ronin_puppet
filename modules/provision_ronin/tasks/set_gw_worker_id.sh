#!/usr/bin/env bash


sed -i '' "s/t-mojave-vm-ref/${PT_hostname}/g" /etc/generic-worker.config

mkdir -p /var/tmp/semaphore

touch /var/tmp/semaphore/run-buildbot

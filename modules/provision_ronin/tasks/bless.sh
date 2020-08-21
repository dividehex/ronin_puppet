#!/usr/bin/env bash

if [[ $PT_dc == "mdc1" ]]; then
    DS_IP="10.49.56.200"
else
    DS_IP="10.51.56.233"
fi

echo -n "Blessing startup to netboot : ${PT_dc} ${DS_IP}"
[[ -z "${PT__noop}" ]] && echo "" && /usr/sbin/bless --netboot --nextonly --server bsdp://"${DS_IP}" || echo " (noop)"

echo -n "Rebooting in 1 minute"
[[ -z "${PT__noop}" ]] && echo "" && (shutdown -r +1 > /dev/null)  || echo " (noop)"

exit 0

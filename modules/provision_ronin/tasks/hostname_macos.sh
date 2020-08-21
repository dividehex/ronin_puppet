#!/usr/bin/env bash

echo -n "Changing HostName      : $(/usr/sbin/scutil --get HostName) -> ${PT_hostname}.${PT_domain}"
[[ -z "${PT__noop}" ]] && echo "" && /usr/sbin/scutil --set HostName "${PT_hostname}.${PT_domain}" || echo " (noop)"
echo -n "Changing ComputerName  : $(/usr/sbin/scutil --get ComputerName) -> ${PT_hostname}"
[[ -z "${PT__noop}" ]] && echo "" && /usr/sbin/scutil --set ComputerName "${PT_hostname}" || echo " (noop)"
echo -n "Changing LocalHostName : $(/usr/sbin/scutil --get LocalHostName) -> ${PT_hostname}"
[[ -z "${PT__noop}" ]] && echo "" && /usr/sbin/scutil --set LocalHostName "${PT_hostname}" || echo " (noop)"

exit 0

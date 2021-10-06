#!/bin/bash

check() {

Backup_of_internal_field_separator=$IFS
IFS=,

for item in $1; do
  if grep -F -w -q "$item" "$2"; then
    continue
        else echo "Missing configuration: $item | path: $2"
  fi
done
}


checkv2() {

Backup_of_internal_field_separator=$IFS
IFS=,

for item in $1; do
  if ufw status verbose |grep -F -w -q "$item"; then
    continue
        else echo "Missing configuration: port: $item"
  fi
done
}

listUFW="22,80,443,deny (incoming),allow (outgoing),Status: active"

echo "SUFW rules check"
checkv2 "$listUFW"
echo "Check completed successfully"
echo "Displaying ufw overview:"
ufw status

echo "run the command: [ss -atup | grep LISTEN] to se listening services"
echo

listsysctl='kernel.dmesg_restrict = 1,kernel.kptr_restrict = 2,kernel.core_uses_pid = 1,kernel.ctrl-alt-del = 0,kernel.maps_protect = 1,kernel.randomize_va_space = 2,kernel.sysrq = 0,fs.file-max = 65535,fs.protected_hardlinks = 1,fs.protected_symlinks = 1,fs.suid_dumpable = 0'
listsysctl2='net.ipv4.tcp_syncookies = 1,net.ipv4.tcp_syn_retries = 2,net.ipv4.tcp_synack_retries = 2,net.ipv4.tcp_max_syn_backlog = 4096,net.ipv4.ip_forward = 0,net.ipv4.conf.all.forwarding = 0,net.ipv4.conf.default.forwarding = 0,net.ipv6.conf.all.forwarding = 0,net.ipv6.conf.default.forwarding = 0,net.ipv4.conf.all.rp_filter = 1,net.ipv4.conf.default.rp_filter = 1'
filesysctl='/etc/sysctl.conf'

echo "Systctl config check"
check "$listsysctl" $filesysctl
check "$listsysctl2" $filesysctl
echo "Check completed successfully"
echo

listPW='retry=3,minlen=14,maxrepeat=3,minclass=4,difok=3,usercheck=1,en-force_for_root'
filePW='/etc/pam.d/common-password'
echo "Password policy check"
check "$listPW" $filePW
echo "Check completed successfully"


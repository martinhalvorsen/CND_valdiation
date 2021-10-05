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

listSSH='PasswordAuthentication no,ChallengeResponseAuthentication yes,AuthenticationMethods publickey,password publickey,keyboard-interactive'
fileSSH="/etc/ssh/sshd_config"

echo "SSH config check"
check "$listSSH" $fileSSH
echo "Check completed successfully"
echo

listPAM='#@include common-auth,auth required pam_google_authenticator.so'
filePAM='/etc/pam.d/sshd'

echo "PAM.d config check"
check "$listPAM" $filePAM
echo "Check completed successfully"
echo



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

listTLS='1SSLEngine on,SSLProtocol TLSv1.3,SSLCipherSuite HIGH:!aNULL,SSLCertificateFile,SSLCertificateKeyFile'
fileapache="/etc/apache2/sites-available/000-default.conf"

echo "TLS config check"
check "$listTLS" $fileapache
echo "Check completed successfully"
echo

listheader='<IfModule mod_headers.c>,Header always set Strict-Transport-Security:,Header always set X-Frame-Options:,Header always set X-Content-Type-Options:,Header always set Content-Security-Policy:,Header always set X-Permitted-Cross-Domain-Policies:,Header always set Referrer-Policy:,Header always set Clear-Site-Data:,Header always set Cross-Origin-Embedder-Policy:,Header always set Cross-Origin-Opener-Policy:,Header always set Cross-Origin-Resource-Policy:,Header always set Permissions-Policy:,</IfModule>'


echo "Header config check"
check "$listheader" $fileapache
echo "Check completed successfully"
echo

echo "Modsecurity config check"
listmodapache='SecRuleEngine On,<IfModule security2_module>,Include /usr/share/modsecurity-crs/crs-setup.conf,Include /usr/share/modsecurity-crs/rules/*.conf,</IfModule>'
listmodconf='SecRuleEngine On'
filemodconf="/etc/modsecurity/modsecurity.conf"
check "$listmodapache" $fileapache
check "$listmodconf" $filemodconf
echo "Check completed successfully"

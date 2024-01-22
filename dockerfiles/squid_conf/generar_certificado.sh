CERT_D=/etc/squid/cert
CERT=$CERT_D/squid_proxyCA.pem
rm -rf $CERT
mkdir -p $CERT_D
# Generate local self-signed CA certificate/key (in the same file)
openssl req -new -newkey rsa:4096 -sha256 -days 365 -nodes -x509  -subj "/C=ES/ST=Alicante/L=Elx/O=IES S8A/CN=IES S8A" -keyout $CERT -out $CERT
chown -R proxy:proxy $CERT_D
chmod 0400 $CERT

# add squid_proxyCA cert to system so it's trusted by default
CA_CERT_D=/usr/local/share/ca-certificates
rm -rf $CA_CERT_D/*
mkdir -p $CA_CERT_D
openssl x509 -inform PEM -in $CERT -out $CA_CERT_D/squid_proxyCA.crt
update-ca-certificates

/usr/lib/squid/security_file_certgen -c -s /var/spool/squid/ssl_db -M 4MB
chown -R proxy:proxy /var/spool/squid
#!/bin/bash

openssl genrsa -des3 -passout pass:1234 -out certs/server.key 1024 && \
openssl rsa -passin pass:1234 -in certs/server.key -out certs/server.key && \
openssl req -new -key certs/server.key -days 3650 -out certs/server.crt -x509 -subj '/C=FI/ST=Uusimaa/L=Helsinki/O=toska.dev/CN=toska.dev/emailAddress=grp-toska@helsinki.fi';
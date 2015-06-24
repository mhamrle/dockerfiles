#!/bin/sh -e

### Workaround for an AUFS bug: https://github.com/monetas/notary/issues/234
mkdir /etc/ssl/private-copy
mv /etc/ssl/private/* /etc/ssl/private-copy/
rm -rf /etc/ssl/private
mv /etc/ssl/private-copy /etc/ssl/private
chown -R root:ssl-cert /etc/ssl/private/
chmod -R 0750 /etc/ssl/private; 

### Start services.
service supervisor start

# Wait for postgres.
for i in $(seq 5); do
   if pg_isready; then
       break
   fi
   sleep 1
done

# Wait for InfluxDB. It is *utterly* inconsequential which URL we curl.
for i in $(seq 50); do
   echo "Waiting for InfluxDB to start (${i}/50)"
   if curl --fail --silent 'http://0.0.0.0:8086/' || [ $? -eq 22 ]; then
       echo "InfluxDB started"
       break
   fi
   sleep 1
done

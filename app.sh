#!/usr/bin/env bash

cat <<EOT
{
 "username": "${DATABASE_CREDS_READONLY_USERNAME}",
 "password": "${DATABASE_CREDS_READONLY_PASSWORD}",
 "database": "devxdemo-db"
}
EOT


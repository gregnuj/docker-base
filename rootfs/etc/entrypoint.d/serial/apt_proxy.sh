#!/bin/bash

APT_CONFD="/etc/apt/apt.conf.d"

if [ -n "$HTTP_PROXY" ]; then
	mkdir -p $APT_CONFD
	echo "Acquire::http::Proxy \"$HTTP_PROXY\"" >> $APT_CONFD/proxy.conf
fi
if [ -n "$HTTPS_PROXY" ]; then
	mkdir -p $APT_CONFD
	echo "Acquire::https::Proxy \"$HTTPS_PROXY\"" >> $APT_CONFD/proxy.conf
fi

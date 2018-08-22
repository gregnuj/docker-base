#!/bin/bash

TAG="$(basename $0 '.sh')"

echo "${TAG} generating ssh keys"
ssh-keygen -A

#!/bin/bash

git branch --format '%(refname:short)' | 
while read branch; do 
	git checkout
	git merge master
	git push
done
git checkout master

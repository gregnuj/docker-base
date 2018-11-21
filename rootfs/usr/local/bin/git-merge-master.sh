#!/bin/bash -e

git branch --format '%(refname:short)' | 
while read branch; do 
	git checkout $branch
	git merge master
	git push
done
git checkout master

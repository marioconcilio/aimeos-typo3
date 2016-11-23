#!/bin/bash

set -ev

git branch | sed -n '/\* /s///p'
git rev-parse --abbrev-ref HEAD
git name-rev --name-only HEAD
git symbolic-ref -q --short HEAD


BRANCH=`git rev-parse --abbrev-ref HEAD`
DATE=`date -u +%Y-%m-%d`

if test $BRANCH != 'master' && test $BRANCH != 'HEAD'; then
	VERSION="`git describe --abbrev=0 --tags --always`-dev"
else
	VERSION=`date -u +%y.%m.%d-dev`
fi

echo "$BRANCH, $VERSION"

cat .deploy.json | sed "s/###DATE###/$DATE/g" > .deploy.json.new
cat .deploy.json.new | sed "s/###VERSION###/$VERSION/g" > .deploy.json


zip -r ../aimeos_$VERSION.zip * -x .tx -x *.git* -x composer.* -x .deploy.* -x .travis.yml

#!/bin/bash

printf "Plugin name: "
read NAME

printf "Destination folder: "
read FOLDER

printf "Include Grunt support (y/n): "
read GRUNT

printf "Initialise new git repo (y/n): "
read NEWREPO

DEFAULT_NAME="Plugin Name"
DEFAULT_CLASS=${DEFAULT_NAME// /_}
DEFAULT_TOKEN=$( tr '[A-Z]' '[a-z]' <<< $DEFAULT_CLASS)
DEFAULT_SLUG=${DEFAULT_TOKEN//_/-}

CLASS=${NAME// /_}
TOKEN=$( tr '[A-Z]' '[a-z]' <<< $CLASS)
SLUG=${TOKEN//_/-}

cp -ar $DEFAULT_SLUG $FOLDER/$SLUG

echo "copy git files..."
cp -ar .git[im]* $FOLDER/$SLUG

cd $FOLDER/$SLUG

git submodule update --recursive
if [ "$NEWREPO" == "y" ]; then
	echo "Initialising new git repo..."
	cd ../..
	git init
else
	rm -f .git*
fi

if [ "$GRUNT" == "n" ]; then
	rm Gruntfile.js
	rm package.json
fi

echo "Updating plugin files..."

function update_file() {
	# 1. change name
	cp $1 $1.tmp
	sed "s/$DEFAULT_NAME/$NAME/g" $1.tmp > $1

	# 2. change slug
	cp $1 $1.tmp
	sed "s/$DEFAULT_1/$1/g" $1.tmp > $1

	# 3. change token
	cp $1 $1.tmp
	sed "s/$DEFAULT_TOKEN/$TOKEN/g" $1.tmp > $1

	# 4. change class
	cp $1 $1.tmp
	sed "s/$DEFAULT_CLASS/$CLASS/g" $1.tmp > $1
	rm $1.tmp
}

## README
update_file README.txt

## README
update_file uninstall.php

## DEFAULT_SLUG.php 
mv $DEFAULT_SLUG.php $SLUG.php
update_file $SLUG.php

## admin
cd admin
mv class-$DEFAULT_SLUG.php class-$SLUG.php
update_file class-$SLUG.php
## admin/views
cd views
update_file admin.php

## languages
cd ../../languages
mv $DEFAULT_SLUG.pot $SLUG.pot
update_file $SLUG.pot

## public
cd ../public
mv class-$DEFAULT_SLUG.php class-$SLUG.php
update_file class-$SLUG.php
## public/includes
cd includes
update_file requirements.php

echo "Complete!"

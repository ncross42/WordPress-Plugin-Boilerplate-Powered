#!/bin/bash

printf "Plugin name: "
read NAME

printf "Destination folder: "
read FOLDER

printf "Author name: "
read AUTHOR

printf "Email address: "
read EMAIL

printf "Include Grunt support (Y/n): "
read GRUNT

printf "Initialise new git repo (Y/n): "
read NEWREPO

DEFAULT_NAME="Plugin Name"
DEFAULT_CLASS=${DEFAULT_NAME// /_}
DEFAULT_TOKEN=$( tr '[A-Z]' '[a-z]' <<< $DEFAULT_CLASS)
DEFAULT_SLUG=${DEFAULT_TOKEN//_/-}

CLASS=${NAME// /_}
TOKEN=$( tr '[A-Z]' '[a-z]' <<< $CLASS)
SLUG=${TOKEN//_/-}

DST_DIR="$FOLDER/$SLUG"

if [ "$NEWREPO" == "n" ]; then
	git submodule update --recursive
fi

cp -ar $DEFAULT_SLUG $DST_DIR

cd $FOLDER/$SLUG

if [ "$NEWREPO" != "n" ]; then
	echo "Initialising new git repo..."
	git init

	git submodule add https://github.com/WebDevStudios/CPT_Core.git includes/CPT_Core
	git submodule add https://github.com/WebDevStudios/Taxonomy_Core.git includes/Taxonomy_Core
	git submodule add https://github.com/WebDevStudios/CMB2.git admin/includes/CMB2;
	git submodule add https://github.com/jtsternberg/Shortcode_Button.git admin/includes/CMB2-Shortcode
	git submodule add https://github.com/origgami/CMB2-grid.git admin/includes/CMB2-grid
	git submodule add https://github.com/nathanielks/wordpress-admin-notice.git admin/includes/WP-Admin-Notice
	git submodule add https://github.com/voceconnect/wp-contextual-help.git admin/includes/WP-Contextual-Help
	git submodule add https://github.com/Mte90/pointerplus.git admin/includes/PointerPlus
	git submodule add https://github.com/Mte90/CronPlus.git admin/includes/CronPlus
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
	sed "s/$DEFAULT_SLUG/$SLUG/g" $1.tmp > $1

	# 3. change token
	cp $1 $1.tmp
	sed "s/$DEFAULT_TOKEN/$TOKEN/g" $1.tmp > $1

	# 4. change class
	cp $1 $1.tmp
	sed "s/$DEFAULT_CLASS/$CLASS/g" $1.tmp > $1

	# 5. change author
	cp $1 $1.tmp
	sed "s/Your Name/$AUTHOR/g" $1.tmp > $1

	# 6. change email
	cp $1 $1.tmp
	sed "s/email@example.com/$EMAIL/g" $1.tmp > $1
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
mv class-$DEFAULT_SLUG-admin.php class-$SLUG-admin.php
update_file class-$SLUG-admin.php
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

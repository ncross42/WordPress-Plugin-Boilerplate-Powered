#!/bin/bash
set -e

slug="plugin-name"

apigen --source ./ --exclude=*CMB*,*WP-Admin-Notice*,*WP-Contextual-Help*,*CPT_Core*,*Taxonomy_Core*,*Widget-Boilerplate* --destination ./ --title "Wordpress Plugin Boilerplate Powered" > /dev/null

echo "#menu > span:first-child, #menu > a:first-child span {background: url('https://raw.githubusercontent.com/Mte90/WordPress-Plugin-Boilerplate-Powered/master/plugin-name/assets/icon-128x128.png');content: "";height: 128px;width: 128px;display:block;}" >> ./resources/style.css
echo "#menu > span:first-child, #menu > a:first-child, #menu > a:first-child:hover {background-color:transparent;color: transparent;}" >> ./resources/style.css

rm -r plugin-name/
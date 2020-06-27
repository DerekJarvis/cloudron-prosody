#!/bin/bash
set -e

source="/usr/src/prosody-modules"
target="/usr/local/lib/prosody/custom-modules"

cd ${source}

usage() {
	echo "usage: $0 ext-name [ext-name ...]"
	echo "   ie: $0 carbons e2e_policy proxy65"
	echo
	echo 'Possible values for ext-name:'
	find . -mindepth 1 -maxdepth 1 -type d | sort | sed s/\.\\/mod_//g | xargs
}

exts=
for ext; do
	if [ -z "mod_$ext" ]; then
		continue
	fi
	if [ ! -d "mod_$ext" ]; then
		echo >&2 "error: $PWD/mod_$ext does not exist"
		echo >&2
		usage >&2
		exit 1
	fi
	exts="$exts $ext"
done

if [ -z "$exts" ]; then
	usage >&2
	exit 1
fi

for ext in $exts; do
	echo "Installing mod_${ext}"

	echo " - copying to ${target}"
	cp -r "${source}/mod_${ext}" "${target}/"
done

#!/usr/bin/bash

SCRIPT_PATH="${BASH_SOURCE:-$0}"
ABS_SCRIPT_PATH="$(realpath "${SCRIPT_PATH}")"
ABS_DIRECTORY="$(dirname "${ABS_SCRIPT_PATH}")"

source $ABS_DIRECTORY/init_vars.sh

godot --no-window --path $ABS_DIRECTORY/.. \
	-s res://addons/gut/gut_cmdln.gd \
	-gconfig=res://.gutconfig.json

#!/bin/sh
echo -ne '\033c\033]0;Fiber\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Fiber_server.x86_64" "$@"

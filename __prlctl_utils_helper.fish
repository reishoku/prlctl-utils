#!/usr/bin/env fish

# Author: KOSHIKAWA Kenichi

# Requirements:
#   * prlctl
#   * fzf
#   * grep
#   * jq

for cmd in "prlctl" "fzf" "grep" "jq"
  if not command -sq $cmd
    echo "$cmd was not found in PATH."
    exit 1
  end
end

set -lx PRLCTL (/usr/bin/which prlctl)
set -lx GREP   (/usr/bin/which grep)
set -lx FZF    (/usr/bin/which fzf)
set -lx JQ     (/usr/bin/which jq)

function __prlctl_vm_all --wraps prlctl
  $PRLCTL \
    list \
      --all \
      --json \
      --no-header \
      -o "name,uuid,status" \
      --sort status --sort name
end

function __prlctl_vm_running --wraps prlctl
  __prlctl_vm_all | \
    $JQ \
      -r \
      '.[] | select(.status == "running")'
end

function __prlctl_vm_stopped --wraps prlctl
  __prlctl_vm_all | \
    $JQ \
      -r \
      '.[] | select(.status == "stopped")'
end

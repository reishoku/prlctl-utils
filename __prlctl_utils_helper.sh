#!/usr/bin/env zsh

# Author: KOSHIKAWA Kenichi

# Requirements:
#   * prlctl command from Parallels Desktop
#   * fzf    command from github.com/junegunn/fzf
#   * grep   command from system (GNU grep is not mandatory)
#   * jq     command from system (macOS Sequoia or newer) or homebrew

set -eu pipefail

# Check requirements are met
/usr/bin/which -s prlctl || { echo "prlctl was not found in PATH." && exit 1; }
/usr/bin/which -s fzf    || { echo "fzf was not found in PATH." && exit 1; }
/usr/bin/which -s grep    || { echo "grep was not found in PATH." && exit 1; }
/usr/bin/which -s jq    || { echo "jq was not found in PATH." && exit 1; }

PRLCTL="$(/usr/bin/which prlctl)"
FZF="$(/usr/bin/which fzf)"
GREP="$(/usr/bin/which grep)"
JQ="$(/usr/bin/which jq)"

function __prlctl_vm_all {
  ${PRLCTL} \
    list \
      --all \
      --json \
      --no-header \
      -o "name,uuid,status" \
      --sort status --sort name
}

function __prlctl_vm_running {
  __prlctl_vm_all | \
    ${JQ} \
      -r \
      '.[] | select(.status == "running")'
}

function __prlctl_vm_stopped {
  __prlctl_vm_all | \
    ${JQ} \
      -r \
      '.[] | select(.status == "stopped")'
}


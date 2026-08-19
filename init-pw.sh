#!/usr/bin/env bash

set -euo pipefail

if (( $# > 1 )); then
  printf 'usage: %s [target-root]\n' "$0" >&2
  exit 2
fi

target_root="${1:-/mnt}"
password_file="${target_root%/}/var/lib/misc/hashedLoginPassword"
invoking_user="${SUDO_USER:-$(id -un)}"

if [[ "$invoking_user" != "nixos" ]]; then
  printf 'error: this script must be invoked by the nixos live-environment user\n' >&2
  exit 1
fi

if (( EUID != 0 )); then
  printf 'error: run this script as root (for example, sudo %q)\n' "$0" >&2
  exit 1
fi

if [[ ! -d "$target_root" ]]; then
  printf 'error: target root does not exist: %s\n' "$target_root" >&2
  exit 1
fi

if ! command -v mkpasswd >/dev/null 2>&1; then
  printf 'error: mkpasswd is required; enter a shell containing nixpkgs#mkpasswd first\n' >&2
  exit 1
fi

while true; do
  if ! IFS= read -r -s -p 'Enter login password: ' password; then
    printf '\n' >&2
    exit 1
  fi
  printf '\n' >&2

  if ! IFS= read -r -s -p 'Verify login password: ' confirmation; then
    printf '\n' >&2
    exit 1
  fi
  printf '\n' >&2

  if [[ -z "$password" ]]; then
    printf 'The login password cannot be empty. Try again.\n' >&2
  elif [[ "$password" != "$confirmation" ]]; then
    printf 'Passwords do not match. Try again.\n' >&2
  else
    break
  fi
done

password_hash="$(printf '%s' "$password" | mkpasswd --method=yescrypt --stdin)"
unset password confirmation

if [[ "$password_hash" != '$y$'* ]]; then
  unset password_hash
  printf 'error: mkpasswd did not produce a yescrypt password hash\n' >&2
  exit 1
fi

password_dir="${password_file%/*}"
install -d -m 0755 "$password_dir"

temporary_file="$(mktemp "${password_file}.tmp.XXXXXX")"
trap 'rm -f "$temporary_file"' EXIT

printf '%s\n' "$password_hash" > "$temporary_file"
unset password_hash
chmod 0600 "$temporary_file"
chown root:root "$temporary_file"
mv -f "$temporary_file" "$password_file"
trap - EXIT

printf 'Wrote the login password hash to %s\n' "$password_file"

# Simpleprocedure to Hasteninstall your Lessbombsesque Nixcomputer
tldr:
- make hardware config, adjustments to flake as seen fit
- boot live iso, copy over config
- partition with disko
- init password
- nixos-install
- DONE

from there you can implement the private wrapper flake with its agenix secrets management (recommended) or regret your decision and install a better os (optional)

---

```bash
# from any working directory on the live iso
git clone https://github.com/lessbombs/nixfiles.git
cd nixfiles

sudo nix --enable-experimental-features "flakes nix-command" \
  run github:nix-community/disko/ -- \
  --mode destroy,format,mount --flake .#worldlimit

findmnt -R /mnt

sudo ./init-pw.sh /mnt # set this pw to be the same as luks

sudo nixos-install --no-root-passwd --flake .#worldlimit

sudo systemctl reboot

```

it could be even easier.
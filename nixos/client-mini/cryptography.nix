# age and ssh per-host setup; see also ./networking.nix
{ pkgs, ... }:

let
  identityPath = "/var/lib/agenix/age_host_mlkem768x25519_key";
in {
  environment.systemPackages = with pkgs; [ age ];

  system.activationScripts.generateAgeIdentity = {
    deps = [ "specialfs" ];

    text = ''
      ${pkgs.coreutils}/bin/install -d -m 0700 /var/lib/agenix

      if [ ! -e "${identityPath}" ]; then
        umask 0077
        # Generate a native hybrid post-quantum age identity.
        ${pkgs.age}/bin/age-keygen -pq -o "${identityPath}"
      elif ! ${pkgs.age}/bin/age-keygen -y "${identityPath}" >/dev/null; then
        echo "Existing age identity is invalid: ${identityPath}" >&2
        exit 1
      fi
    '';
  };

  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;

    hostKeys = [
      {
        type = "mldsa44-ed25519";
        path = "/etc/ssh/ssh_host_mldsa44_ed25519_key";
      }
      {
        type = "ed25519";
        path = "/etc/ssh/ssh_host_ed25519_key";
      }
    ];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";

      # Only allow SSH access with composite keys for now
      HostKeyAlgorithms = "ssh-mldsa44-ed25519@openssh.com";
      PubkeyAcceptedAlgorithms = "ssh-mldsa44-ed25519@openssh.com";
    };
  };


}
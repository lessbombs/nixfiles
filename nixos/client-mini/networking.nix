{ config, ... }:

{
  services.tailscale.enable = true;

  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;

      # WireGuard/Tailscale transport.
      allowedUDPPorts = [ config.services.tailscale.port ];

      # SSH is reachable only through Tailscale.
      interfaces.tailscale0.allowedTCPPorts = [ 22 ];
    };
  };
}
{ pkgs, lib, inputs, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "flake-self-attrs" ];
      auto-optimise-store = true;
      connect-timeout = 5;
      fallback = true;
      substituters = [ "https://readest.cachix.org" ];
      trusted-public-keys = [
        "readest.cachix.org-1:KvKAePcZZCZB8ytFIAOGdgN3VRdmFHGRMHqMVckbt5c="
      ];
      # todo: self-hosted substituter
    };

    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 60d";
    };

    package = pkgs.unstable.lixPackageSets.latest.lix;
    channel.enable = false; # disable nix-channel related tools and configs
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [ # todo: maybe we shouldn't dump our overlays here
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config = prev.config;
        };
        my = import ../../pkgs { pkgs = final; };
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena;
      })
      inputs.helium.overlays.default 
    ];
  };
}

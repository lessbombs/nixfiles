{ ... }:

{
  # todo: research home.shell options

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .";
      flake-check = "nix flake check";
      please = "sudo";
    };
  };

  programs.fish = {
    enable = true;
  };

  # todo: nushell

  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    # todo: ghostty settings
    # todo: sonokai andromeda theming
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
    };
  };
}

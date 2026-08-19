{ pkgs, myvars, lib, ... }:

{
  users.mutableUsers = false;

  users.users.${myvars.name} = {
    isNormalUser = true;
    description = myvars.fullname;
    
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "libvirtd" 
      "docker"
    ];

    hashedPasswordFile = lib.mkDefault "/var/lib/misc/hashedLoginPassword";
  };

  # todo: move system shells somewhere else
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ bash fish ];
}

{ pkgs, myvars, ... }:

{
  users.users.${myvars.name} = {
    isNormalUser = true;
    description = myvars.fullname;
    
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "libvirtd" 
      "docker"
    ];

  };

  # todo: move system shells somewhere else
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ bash fish ];
}

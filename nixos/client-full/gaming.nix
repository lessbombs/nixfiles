{ myvars, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };

  programs.gamemode.enable = true;
  users.users.${myvars.name}.extraGroups = [ "gamemode" ];
  hardware.graphics.enable32Bit = true;

}

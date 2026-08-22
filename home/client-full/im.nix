{ pkgs, ... }:

{
  programs.discord = {
    enable = true;
    package = (pkgs.unstable.discord.override {
      withOpenASAR = true;
      withVencord = true;
    });
  };

  # todo: matrix, irc
}

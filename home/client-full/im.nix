{ pkgs, ... }:

{
  programs.discord = {
    enable = true;
    package = (pkgs.unstable.discord.override {
      # no video playback w/ hardware accel on openasar for me
      # withOpenASAR = true;
      withVencord = true;
    });
  };

  # todo: matrix, irc
}

{myvars, pkgs, ...}:

{
  home.packages = with pkgs; [ my.tangent ];
  
  programs = {

    anki = {
      enable = true;
      profiles = {
        "${myvars.name}" = {
          default = true;
        };
      };
    };

    obsidian = {
      enable = true;
      package = pkgs.unstable.obsidian;
    };

  };

}
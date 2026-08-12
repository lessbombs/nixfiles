{myvars, ...}:

{
  
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
    };

    # todo: package tangent from source
    # pulling from flathub for now in ./flatpak.nix

  };

}
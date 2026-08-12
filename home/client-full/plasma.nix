{ inputs, pkgs, ... }:

{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  home.packages = with pkgs; [
    rose-pine-cursor
    my.manhattan
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true; # aiming for full reproducibility

    shortcuts = {
      plasmashell."activate application launcher" = ["Alt+F1" "Meta+Shift"];
    };

    krunner = {
      shortcuts.launch = ["Meta" "Search" "Alt+Space"];
      position = "center";
      historyBehavior = "enableSuggestions";
    };

    panels = [
      { # Bottom bar
        location = "bottom";  
        widgets = [
          {
            kickoff = {
              icon = "nix-snowflake-white";
              favoritesDisplayMode = "grid";
              applicationsDisplayMode = "list";
              compactDisplayStyle = true;
              showButtonsFor = "power";
            };
          }

          "org.kde.plasma.marginsseparator"

          {
            iconTasks = {
              launchers = [
                "applications:helium.desktop"
                "applications:com.mitchellh.ghostty.desktop"
                "applications:org.kde.dolphin.desktop"
                # codium
              ];
            };
          }

          "org.kde.plasma.marginsseparator"

          {
            systemTray = {};
          }

          # todo: system tray, notifs, digital clock

        ];
      }

      # todo: media side panel
    ];
    

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      widgetStyle = "breeze";
      colorScheme = "Manhattan";
      cursor = {
        theme = "BreezeX-RosePine-Linux";
        size = 18;
      };

    };
  };
  
}
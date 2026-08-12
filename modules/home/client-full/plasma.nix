{ inputs, pkgs, ... }:

{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  home.packages = with pkgs; [
    rose-pine-cursor
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true;

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
              icon = "nix-snowflake";
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
                # "applications:helium" # todo: what're the right .desktop entries
                # "applications:ghostty"
                "applications:org.kde.dolphin.desktop"
                # codium
              ];
            };
          }

          "org.kde.plasma.marginsseparator"

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
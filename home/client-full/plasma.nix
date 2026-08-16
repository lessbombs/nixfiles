{ inputs, pkgs, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  home.packages = with pkgs; [
    kwin-script-geometry-change
    rose-pine-cursor
    my.manhattan
    # my.motomachi-patched
    my.mplus-fonts
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true; # aiming for full reproducibility

    session = {
      general.askForConfirmationOnLogout = false;
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

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
            systemTray = {
              items.shown = ["org.kde.plasma.notifications"];
            };
          }

          {
            digitalClock = {
              date = {
                format = "isoDate";
                position = "belowTime";
              };
              font = {
                family = "Hack";
                italic = true;
                bold = true;
                size = 10;
              };
            }; 
          }

          {
            pager = {
              general = {
                showWindowOutlines = false;
                showApplicationIconsOnWindowOutlines = false;
              };
            };
          }
        ];
      }

      { # Right panel
        location = "right";
        # meta + z panel shortcut
        widgets = [
          {
            # media playback
          }

          {
            # spacer = 20
          }

          {
            # temperature
          }
        ];
      }
    ];
    
    fonts = {
      general = {
        family = "M PLUS 1";
        pointSize = 10;
      };
      fixedWidth = {
        family = "Hack";
        pointSize = 10;
      };
      small = {
        family = "M PLUS U";
        pointSize = 8;
      };
      toolbar = {
        family = "M PLUS U";
        pointSize = 10;
        weight = "demiBold";
      };
      menu = {
        family = "M PLUS U";
        pointSize = 10;
        weight = "light";
      };
      windowTitle = {
        family = "M PLUS U";
        pointSize = 10;
        weight = "bold";
        style = "italic";
      };
    };

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      widgetStyle = "breeze";
      colorScheme = "Manhattan";
      cursor = {
        theme = "BreezeX-RosePine-Linux";
        size = 24;
      };
    };
    
    configFile."kdeglobals"."General"."AccentColor" = "146,110,228";

  };
  
}

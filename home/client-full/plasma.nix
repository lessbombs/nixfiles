{ inputs, pkgs, myvars, ... }:

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

  xdg.configFile."autostart/krunner.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=KRunner
    Exec=krunner --daemon
  '';

  programs.plasma = {
    enable = true;
    overrideConfig = true; # aiming for full reproducibility

    session = {
      general.askForConfirmationOnLogout = false;
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    powerdevil = rec {
      AC = {
        autoSuspend.action = "nothing";
        dimDisplay = { enable = true; idleTimeout = 60; };
        turnOffDisplay.idleTimeout = 120;
        powerButtonAction = "sleep";
      };
      battery = AC // {
        autoSuspend.action = "sleep";
        autoSuspend.idleTimeout = 120;
        dimDisplay.idleTimeout = 30;
        turnOffDisplay.idleTimeout = 60;
      };
      lowBattery = battery // {
        autoSuspend.idleTimeout = 60;
      };
    };

    input.keyboard = {
      options = [ "caps:swapescape" ];
      repeatDelay = 250;
      repeatRate = 35;
    };

    shortcuts = {
      plasmashell."activate application launcher" = "Meta+Shift";
      plasmashell."cycle-panels" = "Meta+Z";
      "services/org.kde.konsole.desktop"."_launch" = "None";
      "services/com.mitchellh.ghostty.desktop"."_launch" = "Ctrl+Alt+T";
    };

    kwin = {
      cornerBarrier = true;
      edgeBarrier = 0;
      nightLight = {
        enable = true;
        mode = "constant";
        temperature.night = 4500;
      };

      virtualDesktops = {
        names = [
          "Desktop 1"
          "Desktop 2"
          "Desktop 3"
          "Desktop 4"
        ];
        number = 4;
        rows = 2;
      };

      effects = {
        desktopSwitching = {
          animation = "slide";
          navigationWrapping = false;
        };
        windowOpenClose.animation = "scale";
        minimization.animation = "squash";
      };
    };

    kscreenlocker = {
      autoLock = false;
      lockOnResume = true;
      passwordRequiredDelay = 0;
      timeout = 0;
    };

    krunner = {
      shortcuts.launch = [ "Meta" "Search" "Alt+Space" ];
      position = "center";
      historyBehavior = "enableSuggestions";
    };

    panels = [
      { # Bottom bar
        location = "bottom";  
        floating = false;
        height = 40;
        opacity = "adaptive";

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
              items = {
                hidden = [
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.keyboardlayout"

                  # "spotify-client"
                  # "discord_status_icon_1"
                ];
                shown = [
                  "org.kde.plasma.notifications"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.battery"
                  "org.kde.plasma.bluetooth"
                  "Fcitx"
                ];
              };
            };
          }

          {
            digitalClock = {
              date = {
                format = "isoDate";
                position = "belowTime";
              };
              font = {
                family = "M PLUS U";
                weight = 600; # demibold
                italic = true;
                size = 9;
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
        height = 225;
        lengthMode = "fit";
        hiding = "dodgewindows";
        floating = true;

        widgets = [

          "org.kde.plasma.mediacontroller"

          {
            systemMonitor = {
              title = "〜<i>Menschlichkeit,<br>Mündigkeit</i>〜"; 
              showTitle = true;
              # DON'T SET: causes a painful plasmashell restart on every boot
              # showLegend = true; 
              displayStyle = "org.kde.ksysguard.linechart";
              sensors = [
                {
                  name = "cpu/all/averageTemperature";
                  color = myvars.accentColor;
                  label = "CPU Temperature";
                }
              ];

              settings = {
                "org.kde.ksysguard.linechart/General" = { # not respected
                  lineChartFillOpacity = 50;
                  historyAmount = 120;
                  rangeAutoY = false;
                  rangeFromY = 40;
                  rangeToY = 100;
                };
                "org.kde.ksysguard.piechart/General" = {
                  rangeAuto = false;
                };
                Appearance.updateRateLimit = 1000;
              };
            };
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
    
    configFile = {
      kdeglobals = {
        General.AccentColor = myvars.accentColor;
        KDE.AnimationDurationFactor = 0.5;
      };

      kwinrc = {
        Effect-kwin4_effect_geometry_change.Duration = 400;
        Script-desktopchangeosd.PopupHideDelay = 200;
        Plugins = {
          kwin4_effect_geometry_changeEnabled = true;
          desktopchangeosdEnabled = true;
          maximizeEnabled = false;
          screenedgeEnabled = false;
          shakecursorEnabled = false;
        };
        TabBox.LayoutName = "compact";
      };
    };
  }; 
}

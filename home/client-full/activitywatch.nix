{ config, pkgs, ... }:
# todo: package v0.14.3b activitywatch and v0.4.0 awatcher
{
  services.activitywatch = {
    enable = true;
    package = pkgs.unstable.aw-server-rust;

    watchers = {
      awatcher = { 
        package = pkgs.unstable.awatcher;
        
        settingsFilename = "config.toml";
        settings.awatcher.filters = [
          {
            match-app-id = "codium";
            match-title = "● (.*)";
            replace-title = "$1";
          }
          {
            match-app-id = "org.kde.kate";
            match-title = "(.*) \\*(.*)";
            replace-title = "$1$2";
          }
        ];

        extraOptions = [
          "--config"
          "${config.xdg.configHome}/activitywatch/awatcher/config.toml"
        ];
      };
    };
  };
}

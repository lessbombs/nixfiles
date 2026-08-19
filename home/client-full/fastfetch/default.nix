{ ... }:

let
  escape = builtins.fromJSON ''"\u001b"'';
in
{
  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        # TODO: Add the logo source once it is managed by Nix.
        # source = ./logo.png;
        type = "kitty-direct";
        width = 28;
        height = 25;
        padding = {
          top = 1;
          left = 2;
          right = 2;
        };
      };

      display = {
        separator = "🙠🙝  ";
        color = {
          separator = "dim_magenta";
          keys = "magenta";
          title = "magenta";
        };
        constants = [
          "─────────────────────────────────────────────────────────────────────────"
          "│${escape}[73C│${escape}[74D"
        ];
      };

      modules = [
        {
          type = "break";
        }
        {
          format = "{#3}{#keys}╭{$1}╮${escape}[73D {#1}{#36}{user-name}{#}{#3}{at-symbol-colored}{#3}{host-name-colored} ";
          type = "title";
        }
        {
          key = "{$2}{#31} machine ";
          type = "host";
          format = "{vendor} {name}";
        }
        {
          key = "{$2}{#32}󰍹 display ";
          type = "display";
        }
        {
          key = "{$2}{#33} cpu     ";
          type = "cpu";
          showPeCoreCount = false;
          temp = true;
          format = "{name} @ {freq-max} - {temperature}";
        }
        {
          key = "{$2}{#34} gpu     ";
          type = "gpu";
          temp = true;
        }
        {
          key = "{$2}{#35} ram     ";
          type = "memory";
        }
        {
          key = "{$2}{#36} disk 1  ";
          type = "disk";
          folders = "/";
        }
        {
          key = "{$2}{#31} disk 2  ";
          type = "disk";
          folders = "/data";
        }
        {
          key = "{$2}{#32}󰖩 network ";
          type = "wifi";
          format = "{status} {?protocol}({protocol}){?}";
        }
        {
          key = "{$2}{#33}󰂋 battery ";
          type = "battery";
          temp = true;
          format = "{cycle-count} lifetime cycles - {capacity} [{status}]";
        }
        {
          key = "{$2}{#34}{icon} kernel  ";
          type = "kernel";
        }
        {
          key = "{$2}{#35} distro  ";
          type = "os";
        }

        # TODO: Rewrite sysage.fish in Nix before enabling this module.
        # {
        #   key = "{$2}{#36} age     ";
        #   type = "command";
        #   text = "sysage.fish";
        # }

        {
          key = "{$2}{#31} de      ";
          type = "de";
        }
        {
          key = "{$2}{#32} term    ";
          type = "terminal";
        }
        {
          key = "{$2}{#33} shell   ";
          type = "shell";
        }
        {
          key = "{$2}{#34} pkgs    ";
          type = "packages";
        }
        {
          key = "{$2}{#35} uptime  ";
          type = "uptime";
        }
        {
          format = "{#1}{#keys}├{$1}┤";
          type = "custom";
        }
        {
          key = "{$2}{#36} theme   ";
          type = "theme";
          format = "{theme1}";
        }
        {
          key = "{$2}{#31} icons   ";
          type = "icons";
          format = "{icons1}";
        }
        {
          key = "{$2}{#32}{icon} font    ";
          type = "terminalfont";
          format = "{combined}";
        }
        {
          key = "{$2}{#33} cursor  ";
          type = "cursor";
          # format = "{icons1}";
        }
        {
          format = "{#1}{#keys}├{$1}┤";
          type = "custom";
        }
        {
          key = "{$2}{#39} colors  ";
          type = "colors";
          symbol = "block";
          block.range = [
            0
            7
          ];
        }
        {
          format = "{#1}{#keys}╰{$1}╯";
          type = "custom";
        }
      ];
    };
  };
}

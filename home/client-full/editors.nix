{
  inputs,
  pkgs,
  ...
}:

let
  vscodeExtensions =
    inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace-release;
in
{
  home.packages = with pkgs; [
    nil
    nixfmt
    nerd-fonts.hack
  ];

  programs.vscodium = {
    enable = true;
    mutableExtensionsDir = false;

    profiles.default = {
      extensions = with vscodeExtensions; [
        activitywatch.aw-watcher-vscode
        openai.chatgpt
        jnoortheen.nix-ide
      ];

      userSettings = {
        "editor.rulers" = [
          80
          120
        ];
        "workbench.editor.enablePreview" = false;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "git.enableCommitSigning" = true;
        "editor.fontFamily" = "Hack Nerd Font";
        "nix.formatterPath" = "nixfmt";

        "nix.serverSettings" = {
          nil = {
            formatting.command = [ "nixfmt" ];
            diagnostics.ignored = [ "unused-variable" ];
          };
        };

        "editor.fontLigatures" = false;
        "terminal.integrated.customGlyphs" = false;
        "terminal.integrated.fontFamily" = "Hack Nerd Font";
      };
    };
  };

  # helix
}

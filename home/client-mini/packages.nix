{ pkgs, inputs, ... }:

{ # todo: reorganize/rename; packages.nix is undescriptive. essential home utils can go under core.nix
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    tree
    
    helium
  ] ++ [
    inputs.qbz.packages.${pkgs.system}.default
  ];
}

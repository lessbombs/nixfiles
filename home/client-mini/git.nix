{ myvars, config, ... }:
{ 
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    projects = "${config.home.homeDirectory}/repo";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    signing = {
      signByDefault = true;
      format = "ssh";
    };

    includes = [
      {
        condition = "gitdir:${config.xdg.userDirs.projects}/${myvars.name}/";
        contents = {
          user = {
            email = myvars.email;
            name = myvars.fullname;
            signingKey = "~/.ssh/${myvars.name}/signing.pub";
          };
          gpg.ssh.allowedSignersFile = "~/.ssh/${myvars.name}/allowed_signers";
        };
      }
      # work git config is written in the private repo; looks a lot like above
    ];

    settings = {
      init.defaultBranch = "main";
    };

  };
}
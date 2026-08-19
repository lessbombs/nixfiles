{ myvars, config, ... }:
{
  age.secrets = {
    anki-sync = {
      file = ../secrets/anki-sync.age;
      owner = myvars.name;
    };
  };

  home-manager.users.${myvars.name} = {
    programs = {
      anki.profiles.${myvars.name}.sync = {
        username = myvars.email;
        keyFile = config.age.secrets.anki-sync.path;
      };
    };
  };
}
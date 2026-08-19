# `/secrets-template/`

(Not quite ready yet.)

Contains [`secrets-flake.nix`], a wrapper flake intended for use from a private
repository. Secrets and other modules that don't belong in the public flake can
be declared from here; of course, I shouldn't show how it looks in reality, but
my hope is that this template helps to illustrate a general idea of how I manage
my secrets.

(Though I am triggering my `nixos-rebuild`s with a flake like this, ideally the 
public flake should work without any fuss too!)

*Why not keep secrets with the public flake, since agenix already encrypts
them?*: [Harvest now, decrypt later] (albeit I still rotate my keys regularly).



[`secrets-flake.nix`]: /secrets-template/flake.nix
[Harvest now, decrypt later]: https://en.wikipedia.org/wiki/Harvest_now,_decrypt_later
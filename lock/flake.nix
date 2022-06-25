{
  description = "A very basic flake";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = {self, ...}: {
    deploy = {
      nodes.env = ./deploy-nodes.env;
      nodes.config = builtins.fromTOML (builtins.readFile ./config.toml);
    };
  };
}

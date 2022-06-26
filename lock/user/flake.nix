{
  outputs = {self, ...}: {
    deploy = {
      vast.config = ./vast.yaml;
      config = builtins.fromTOML (builtins.readFile ./config.toml);
    };
  };
}

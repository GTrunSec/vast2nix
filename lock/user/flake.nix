{
  outputs = {self, ...}: {
    deploy = {
      nodes.vast = ./vast.yaml;
      nodes.config = builtins.fromTOML (builtins.readFile ./config.toml);
    };
  };
}

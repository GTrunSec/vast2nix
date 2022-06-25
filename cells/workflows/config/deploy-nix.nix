{ env ? "vast-env",
  args ? []
}: {
  bundle = {
    command = "nix";
    args = [
      "bundle"
      "--bundler"
      "github:Ninlives/relocatable.nix"
      "--refresh"
      ".#x86_64-linux.vast.packages.${env}"
    ];
  };
  deploy = {
    command = "./${env}-deploy/bin/${env}.deploy";
    inherit args;
  };
}

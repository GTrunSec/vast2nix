{
  bundle = {
    command = "nix";
    args = [
      "bundle"
      "--bundler"
      "github:Ninlives/relocatable.nix"
      "--refresh"
      ".#x86_64-linux.vast.packages.vast-bin"
    ];
  };
  deploy = {
    command = "./vast-bin-deploy/bin/vast-bin.deploy";
    args = ["-s" "root@192.168.122.126" "-o" "-p 22" "-d" "/opt/vast" "-u"];
  };
}

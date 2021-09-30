{ makeTest, pkgs, self }:
{
  vast-vm-systemd = makeTest
    {
      name = "vast-systemd";
      machine = { config, pkgs, ... }: {
        imports = [
          self.nixosModules.vast
        ];

        virtualisation = {
          memorySize = 4048;
          cores = 2;
        };

        services.vast = {
          enable = true;
          broker = true;
          extraConfig = builtins.readFile ./vast.yaml;
        };
      };
      testScript = ''
        start_all()
        machine.wait_for_unit("network-online.target")
        machine.wait_for_unit("vast.service")
        machine.wait_for_open_port(4000)
        #machine.systemctl("--wait vast-broker.service")
      '';
    }
    {
      inherit pkgs;
      inherit (pkgs) system;
    };
}

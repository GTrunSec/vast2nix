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
          memorySize = 2046;
          cores = 4;
        };

        services.vast = {
          enable = true;
          broker = true;
          extraConfig = {
            log-file = "/var/lib/vast/server.log";
          };
        };
      };
      testScript = ''
        start_all()
        machine.wait_for_unit("network.target")
        machine.wait_for_unit("vast.service")
        machine.wait_for_open_port(4000)
        machine.systemctl("start vast-broker.service")
      '';
    }
    {
      inherit pkgs;
      inherit (pkgs) system;
    };
}

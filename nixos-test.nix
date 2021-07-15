{ makeTest, pkgs, self }:
{
  vast-systemd = makeTest
    {
      name = "vast-systemd-vm-test";
      machine = { config, pkgs, ... }: {
        imports = [
          self.nixosModules.vast
        ];

        virtualisation.memorySize = 2046;

        services.vast = {
          enable = true;
          extraConfig = {
            log-file = "/var/lib/vast/server.log";
          };
        };
      };
      testScript = ''
        start_all()
        machine.wait_for_unit("multi-user.target")
        with subtest("test vast with systemd"):
             machine.wait_for_unit("vast.service")
             #machine.wait_for_open_port(4000)
             machine.systemctl("start --wait vast.service")
      '';
    }
    {
      inherit pkgs;
      inherit (pkgs) system;
    };
}

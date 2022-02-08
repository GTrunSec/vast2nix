{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.services.vast;
  configFile = pkgs.writeText "vast.yaml" cfg.extraConfig;
in
{
  options = {
    services.vast = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable vast endpoint
        '';
      };

      broker = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable broker to vast
        '';
      };

      extraConfig = mkOption {
        default = { };
        description = ''
          extraConfig = builtins.readFile ./config.vast.example.yaml;
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.vast-latest;
        description = "The vast package.";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/vast";
        description = "The file system path used for persistent state.";
      };

      endpoint = mkOption {
        type = types.str;
        # if the confinement is enable, the localhost does not working anymore
        default = "127.0.0.1:4000";
        example = "localhost:4000";
        description = ''
          The host and port to listen at and connect to.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.vast = {
      isSystemUser = true;
      group = "vast";
      home = cfg.dataDir;
    };

    users.groups.vast = { };

    systemd.services.vast-broker = mkIf cfg.broker {
      enable = true;
      description = "Vast import broker Daemon";
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "vast.service" ];
      after = [
        "network-online.target"
        "vast.service"
      ];
      path = [ cfg.package ];
      script = ''
        exec ${cfg.package}/bin/vast --config=${configFile} import broker
      '';
      serviceConfig = {
        User = "vast";
        Group = "vast";
        ExecReload = "/bin/kill -s HUP $MAINPID";
        Restart = "on-failure";
        WorkingDirectory = cfg.dataDir;
        ReadWritePaths = cfg.dataDir;
        RuntimeDirectory = "vast";
        CacheDirectory = "vast";
        StateDirectory = "vast";
        SyslogIdentifier = "vast";
      };
    };

    systemd.services.vast = {
      enable = true;
      description = "Visibility Across Space and Time";
      wantedBy = [ "multi-user.target" ];

      after = [
        "network-online.target"
        #"zeek.service
      ];

      confinement = {
        enable = true;
        binSh = null;
      };

      script = ''
        ln -sf ${configFile} ${cfg.dataDir}/vast.yaml
        exec ${cfg.package}/bin/vast --config=${configFile} start
      '';

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID && ${pkgs.coreutils}/bin/rm ${cfg.dataDir}/vast.db/pid.lock";
        User = "vast";
        WorkingDirectory = cfg.dataDir;
        ReadWritePaths = cfg.dataDir;
        RuntimeDirectory = "vast";
        CacheDirectory = "vast";
        StateDirectory = "vast";
        SyslogIdentifier = "vast";
        PrivateUsers = true;
        DynamicUser = mkForce false;
        PrivateTmp = true;
        ProtectHome = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
      };
    };
  };
}

{
  inputs,
  cell,
}: {
  caf = {
    stream = {
      desired-batch-complexity = {
        value = "50us";
        description = ''
          Processing time per batch.
        '';
      };

      max-batch-delay = {
        value = "15ms";
        description = ''
          Maximum delay for partial batches.
        '';
      };

      credit-round-interval = {
        value = "10ms";
        description = ''
          Time between emitting credit.
        '';
      };
    };

    # When using "stealing" as scheduler policy.
    work-stealing = {
      aggressive-poll-attempts = {
        value = 100;
        description = ''
          Number of zero-sleep-interval polling attempts.
        '';
      };

      aggressive-steal-interval = {
        value = 10;
        description = ''
          Frequency of steal attempts during aggressive polling.
        '';
      };

      moderate-poll-attempts = {
        value = 500;
        description = ''Number of moderately aggressive polling attempts.'';
      };

      moderate-steal-interval = {
        value = 50;
        description = ''
          Frequency of steal attempts during moderate polling.
        '';
      };

      moderate-sleep-duration = {
        value = "50us";
        description = ''
          Sleep interval between poll attempts.
        '';
      };

      relaxed-steal-interval = {
        value = 1;
        description = ''
          Frequency of steal attempts during relaxed polling.
        '';
      };

      relaxed-sleep-duration = {
        value = "10ms";
        description = ''
          Sleep duration between relaxed polling attempts.
        '';
      };
    };

    # Options affecting the internal scheduler.
    scheduler = {
      policy = {
        value = "stealing";
        description = ''
          Accepted values: "stealing" and "sharing".
        '';
      };

      enable-profiling = {
        value = false;
        description = ''
          Configures whether the scheduler generates profiling output.
        '';
      };

      # profiling-output-file { value = "</dev/null>";
      #                       description = ''
      #                       Output file for profiler data (only if profiling is enabled).
      #    '';
      #                       };

      profiling-resolution = {
        value = "100ms";
        description = ''
          Measurement resolution in milliseconds (only if profiling is enabled).
        '';
      };

      # max-threads = {
      #   value = "<number of cores>";
      #   description = ''
      #     Forces a fixed number of threads if set. Defaults to the number of
      #     available CPU cores if starting a VAST node, or *2* for client commands.
      #   '';
      # };

      max-throughput = {
        value = 500;
        description = ''
          Maximum number of messages actors can consume in one run.
        '';
      };
    };
  };
}

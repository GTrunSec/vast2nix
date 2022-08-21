{
  inputs,
  cell,
}: {
  dataDir ? "/var/lib/vast",
  verbosity ? "info",
}: let
  inherit (inputs) std nixpkgs cells-lab;
  inherit (std) yants;
  y = cells-lab.yants.library;
  l = nixpkgs.lib // builtins;
in {
  vast = {
    endpoint = {
      value = "127.0.0.1:42000";
      description = "The host and port to listen at and connect to";
    };

    connection-timeout = {
      value = "10s";
      description = "The timeout for connecting to a VAST server. Set to 0 seconds to wait indefinitely.";
    };

    db-directory = {
      value = "${dataDir}/vast.db";
      description = "The directory for persistent state";
    };

    # The file system path used for log files.
    log-file = {
      value = "${dataDir}/server.log";
      description = "The file system path used for log files.";
    };

    client-log-file = {
      value = "${dataDir}/client.log";
      description = "The file system path used for client log files relative to the current
     working directory of the client. Note that this is disabled by default. If not specified
     no log files are written for clients at all.";
    };

    file-format = {
      value = "[%Y-%m-%dT%T.%e%z] [%n] [%l] [%s=%#] %v";
      description = ''
        Format for printing individual log entries to the
        log-file. For a list of valid format specifiers, see spdlog format specification at
        https://github.com/gabime/spdlog/wiki/3.-Custom-formatting.
      '';
    };

    file-verbosity = {
      value = y.enumCheck ["quiet" "error" "warning" "info" "debug" "trace"] "file-verbosity" verbosity;
      declaration = ''
        Configures the minimum severity of messages written to the log file.
        Possible values= quiet, error, warning, info, verbose, debug, trace.
        File logging is only available for commands that start a node (e.g., vast
        start). The levels above 'verbose' are usually not available in release
        builds.
      '';
    };

    disable-log-rotation = {
      value = false;
      description = ''
        Whether to enable automatic log rotation. If set to false, a new log file
        will be created when the size of the current log file exceeds 10 MiB.
      '';
    };

    log-rotation-threshold = {
      value = "10MiB";
      description = ''
        The size limit when a log file should be rotated.
      '';
    };

    log-queue-size = {
      value = 1000000;
      description = ''
        Maximum number of log messages in the logger queue.
      '';
    };

    console-sink = {
      value = "stderr/journald";
      descpription = ''
        The sink type to use for console logging. Possible values= stderr,
        syslog, journald. Note that 'journald' can only be selected on linux
        systems, and only if VAST was built with journald support.
        The journald sink is used as default if VAST is started as a systemd
        service and the service is configured to use the journal for stderr,
        otherwise the default is the unstructured stderr sink.
      '';
    };

    console = {
      value = "automatic";
      declaration = ''
        Mode for console log output generation. Automatic renders color only when
        writing to a tty.
        Possible values= always, automatic, never. (default automatic)
      '';
    };

    console-format = {
      value = "%^[%T.%e] %v%$";
      description = ''
        Format for printing individual log entries to the console. For a list
        of valid format specifiers, see spdlog format specification at
         https=//github.com/gabime/spdlog/wiki/3.-Custom-formatting.
      '';
    };

    console-verbosity = {
      value = verbosity;
      description = ''
        Configures the minimum severity of messages written to the console.
        For a list of valid log levels, see file-verbosity.
      '';
    };

    schema-dirs = {
      value = [];
      description = ''
        List of directories to look for schema files in ascending order of
        priority.
      '';
    };

    plugin-dirs = {
      value = [];
      description = ''
        Additional directories to load plugins specified using `vast.plugins`
        from.
      '';
    };

    plugins = {
      value = [];
      description = ''
        The plugins to load at startup. For relative paths, VAST tries to find
        the files in the specified `vast.plugin-dirs`. The special values
        'bundled' and 'all' enable autoloading of bundled and all plugins
        respectively. Note= Add `example` or `/path/to/libvast-plugin-example.so`
        to load the example plugin.
      '';
    };

    node-id = {
      value = "node";
      description = ''
        The unique ID of this node.
      '';
    };

    # Spawn a node instead of connecting to one.
    node = {
      value = false;
      description = ''
        Spawn a node instead of connecting to one.
      '';
    };

    max-partition-size = {
      value = 1048576;
      description = ''
        The size of an index shard, expressed in number of events. This should
        be a power of 2.
      '';
    };

    max-resident-partitions = {
      value = 10;
      description = ''
        The number of index shards that can be cached in memory.
      '';
    };

    max-taste-partitions = {
      value = 5;
      description = ''
        The number of index shards that are considered for the first evaluation
        round of a query.
      '';
    };

    max-queries = {
      value = 10;
      declaration = ''
        The amount of queries that can be executed in parallel.
      '';
    };

    # The directory to use for the partition synopses of the catalog.
    catalog-dir = {
      value = "${dataDir}/index";
      description = ''
        The directory to use for the partition synopses of the catalog.
      '';
    };

    catalog-fp-rate = {
      value = 0.01;
      declaration = ''
        The false positive rate for lossy structures in the catalog.
      '';
    };

    store-backend = {
      value = "segment-store";
      description = ''
        The store backend to use. Can be either 'archive', 'segment-store', or
        the name of a user-provided store plugin.
      '';
    };

    segments = {
      value = 10;
      declaration = ''
        The maximum number of segments cached by the archive.
      '';
    };

    max-segment-size = {
      value = 1024;
      declaration = ''
        The maximum size per segment, in MiB.
      '';
    };

    aging-frequency = {
      value = "24h";
      description = ''
        Interval between two aging cycles.
      '';
    };

    aging-query = {
      value = "";
      description = ''
        Query for aging out obsolete data.
      '';
    };

    enable-metrics = {
      value = false;
      description = ''
        Keep track of performance metrics.
      '';
    };

    shutdown-grace-period = {
      value = "3m";
      description = ''
        The period to wait until a shutdown sequence
        finishes cleanly. After the period elapses, the
        shutdown procedure escalates into a "hard kill".
        A value of "0x", where "x" is any duration unit,
        means an infinite grace period without escalation
        into a hard kill.
      '';
    };

    # The configuration of the metrics reporting component.
    metrics = {
      # Configures if and how metrics should be ingested back into VAST.
      self-sink = {
        value = [
          {
            enable = true;
            slice-size = 128;
          }
        ];
        description = ''
          Configures if and how metrics should be ingested back into VAST.
        '';
      };

      # Configures if and where metrics should be written to a file.
      file-sink = {
        value = [
          {
            enable = false;
            real-time = false;
            path = "${dataDir}/vast-metrics.log";
          }
        ];
        description = ''
          Configures if and where metrics should be written to a file.
        '';
      };
    };

    uds-sink = {
      value = [
        {
          enable = false;
          real-time = false;
          path = "${dataDir}/vast-metrics.sock";
          type = "datagram";
        }
      ];
      description = ''
        Configures if and where metrics should be written to a socket.
      '';
    };

    index = {
      default-fp-rate = {
        value = 0.01;
        description = ''
          The default false-positive rate for type synopses.

          rules:
            Every rule adjusts the behaviour of VAST for a set of targets.
            VAST creates one synopsis per target. Targets can be either types
            or field names.

            fp-rate - false positive rate. Has effect on string and address type
                      targets

            create-dense-index - VAST will not create dense index when set to false
            - targets: [:string, :address]
              fp-rate: 0.01
              create-dense-index: false

          The `vast start` command starts a new VAST server process.
        '';
      };
    };

    # The `vast start` command starts a new VAST server process.
    start = {
      print-endpoint = {
        value = false;
        description = ''
          Prints the endpoint for clients when the server is
          ready to accept connections. This comes in handy when
          letting the OS choose an available random port, i.e.,
          when specifying 0 as port value.
        '';
      };

      commands = {
        value = [];
        description = ''
          An ordered list of commands to run inside the node after
          starting. As an example, to configure an auto-starting PCAP
          source that listens on the interface 'en0' and lives inside
          the VAST node, add `spawn source pcap -i en0`.
        '';
      };

      disk-budget-high = {
        value = "0GiB";
        description = ''
          Triggers removal of old data when the disk budget is
          exceeded.
        '';
      };

      disk-budget-low = {
        value = "10GiB";
        description = ''
          When the budget was exceeded, data is erased until the
          disk space is below this value.
        '';
      };

      disk-budget-check-interval = {
        value = 90;
        description = ''
          Seconds between successive disk space checks.
        '';
      };

      disk-budget-step-size = {
        value = 1;
        description = ''
          When erasing, how many partitions to erase in one
          go before rechecking the size of the database
          directory.
        '';
      };

      # FIXME: Commented
      disk-budget-check-binary = {
        value = "";
        description = ''
          Binary to use for checking the size of the
          database directory. If left unset, VAST will
          recursively add up the size of all files in the
          database directory to compute the size. Mainly
          useful for e.g. compressed filesystem where raw
          file size is not the correct metric. Must be the
          absolute path to an executable file, which will
          get passed the database directory as its first
          and only argument.
        '';
      };
    };

    # The `vast count` command counts hits for a query without exporting data.
    count = {
      estimate = {
        value = false;
        description = ''
          Estimate an upper bound by skipping candidate checks.
        '';
      };
    };

    # The `vast dump` command prints configuration objects as JSON.
    dump = {
      # Format output as YAML.
      yaml = {
        value = false;
        description = ''
          Format output as YAML.
        '';
      };
    };

    # The `vast export` command exports query results to stdout or a file.
    export = {
      continuous = {
        value = false;
        description = ''
          Mark a query as continuous.
        '';
      };
      unified = {
        value = false;
        description = ''
          Mark a query as unified.
        '';
      };

      # Mark a query as low priority.
      low-priority = {
        value = false;
        description = ''
          Mark a query as low priority.
        '';
      };

      disable-taxonomies = {
        value = false;
        description = ''
          Dont substitute taxonomy identifiers.
        '';
      };

      # FIXME: commented
      timeout = {
        value = "<infinite>";
        description = ''
          Timeout to stop the export after.
        '';
      };

      # FIXME: commented
      max-events = {
        value = "<infinity>";
        description = ''
          The maximum number of events to export.
        '';
      };

      read = {
        value = "-";
        description = ''
          Path for reading the query or "-" for reading from stdin.
          Note: Setting this option in the config file creates a conflict with
          `vast export` with a positional query argument. This option is only
          listed here for completeness.
        '';
      };

      write = {
        value = "-";
        description = ''
          Path to write events to or "-" for writing to stdout.
        '';
      };

      # Treat the write option as a UNIX domain socket to connect to.
      uds = {
        value = false;
        description = ''
          Treat the write option as a UNIX domain socket to connect to.
        '';
      };

      # The `vast export json` command exports events formatted as JSONL (line-
      # delimited JSON).
      json = {
        # Flatten nested objects into the top-level object.
        flatten = {
          value = false;
          description = ''
            Flatten nested objects into the top-level object.
          '';
        };

        numeric-durations = {
          value = false;
          description = ''
            Render durations as numbers as opposed to human-readable strings.
          '';
        };

        omit-nulls = {
          value = false;
          description = ''
            Omit null fields in JSON objects.
          '';
        };
      };
      # The `vast export pcap` command exports events in the PCAP format.
      pcap = {
        flush-interval = {
          value = 10000;
          description = ''
            Flush to disk after this many packets.
          '';
        };
      };
    };

    # The `vast infer` command tries to infer the schema from data.
    infer = {
      read = {
        value = "-";
        description = ''
          Path to read events from or "-" for reading from stdin.
        '';
      };
      buffer = {
        value = 8192;
        description = ''
          Maximum number of bytes to buffer.
        '';
      };
    };
    # The `vast explore` command explore context around query results.
    explore = {
      # The output format.
      format = {
        value = "json";
        description = ''
          The output format.
        '';
      };

      after = {
        value = "";
        description = ''
          Include all records up to this much time after each result.
        '';
      };

      before = {
        value = "";
        description = ''
          Include all records up to this much time before each result.
        '';
      };

      by = {
        value = "";
        description = ''
          Perform an equijoin on the given field.
        '';
      };

      # FIXME: commented
      max-events = {
        value = "";
        description = ''
          Maximum number of results.
        '';
      };

      max-events-query = {
        value = 100;
        description = ''
          Maximum number of results for initial query.
        '';
      };

      max-events-context = {
        value = 100;
        description = ''
          Maximum number of results per exploration.
        '';
      };
    };
    # The `vast import` command imports data from stdin, files or over the
    # network.
    import = {
      # The maximum number of events to import.
      max-events = {
        value = "";

        description = ''
          The maximum number of events to import.
        '';
      };

      batch-timeout = {
        value = "10s";

        description = ''
          Timeout after which buffered table slices are forwarded to the node.
        '';
      };

      batch-size = {
        value = 65536;
        description = ''
          Upper bound for the size of a table slice. A value of 0 causes the
          batch-size to be unbounded, leaving control of batching to the
          vast.import.read-timeout option only. This should be a power of 2.
        '';
      };

      blocking = {
        value = false;
        description = ''
          Block until the importer forwarded all data.
        '';
      };

      read-timeout = {
        value = "20ms";
        description = ''
          The amount of time that each read iteration waits for new input.
        '';
      };

      listen = {
        value = "";
        description = ''
          The endpoint to listen on ("[host]:port/type").
        '';
      };

      read = {
        value = "-";
        description = ''
          Path to file to read events from or "-" for stdin.
        '';
      };

      uds = {
        value = false;
        description = ''
          Treat the read option as a UNIX domain socket to connect to.
        '';
      };

      # Path to an alternate schema.
      #schema-file: <none>

      # An alternate schema as a string.
      #schema: <none>

      # The `vast import csv` command imports comma-separated values.
      csv = {
        separator = {
          value = ",";
          description = ''
            The single-character separator. Set this to ' ' to parse space-separated
            values, or '\t' to parse tab-separated values.
          '';
        };
      };

      #json = {
      # # Read the event type from the given field (specify as
      # # '<field>[:<prefix>]').
      # #selector= <none>
      #};

      # The `vast import pcap` command imports PCAP logs.
      pcap = {
        # Network interface to read packets from.
        #interface: <none>

        # Skip flow packets after this many bytes.
        #cutoff: <infinity>

        max-flows = {
          value = 1048576;
          description = ''
            Number of concurrent flows to track.
          '';
        };

        max-flow-age = {
          value = 60;
          description = ''
            Maximum flow lifetime before eviction.
          '';
        };

        flow-expiry = {
          value = 10;
          description = ''
            Flow table expiration interval.
          '';
        };

        pseudo-realtime-factor = {
          value = 0;
          description = ''
            Inverse factor by which to delay packets. For example, if 5, then for
             two packets spaced *t* seconds apart, the source will sleep for *t/5*
             seconds.
          '';
        };

        snaplen = {
          value = 65535;
          description = ''
            Snapshot length in bytes.
          '';
        };

        disable-community-id = {
          value = false;
          description = ''
            Disable computation of community id for every packet.
          '';
        };
      };

      # The `vast import test` command imports randomly generated events. Used for
      # debugging and benchmarking only.
      test = {
        seed = {
          value = 0;
          description = ''
            The PRNG seed.
          '';
        };
      };
      # The `vast import zeek` command imports Zeek logs.
      zeek = {
        # Flag to indicate whether the output should contain #open/#close tags.
        # Zeek writes these tags in its logs such that users can gain insight
        # when Zeek processed the corresponding data. By default, VAST
        # does the same. Settings this flag to true skips printing these tags,
        # which may help when fully deterministic output is desired.
        disable-timestamp-tags = {
          value = false;
          description = ''
            Flag to indicate whether the output should contain #open/#close tags.
            Zeek writes these tags in its logs such that users can gain insight
            when Zeek processed the corresponding data. By default, VAST
            does the same. Settings this flag to true skips printing these tags,
            which may help when fully deterministic output is desired.
          '';
        };
      };
    };
    # The `vast pivot` command extracts related events of a given type.
    # For additionally available options, see export.pcap.
    pivot = {
      # The output format.
      format = {
        value = "json";
        description = ''
          The output format.
        '';
      };
    };
    # The `vast status` command prints a JSON-formatted status summary of the
    # node.
    status = {
      detailed = {
        value = false;
        description = ''
          Add more information to the output
        '';
      };

      # Include extra debug information
      debug = {
        value = false;
        description = ''
          Include extra debug information
        '';
      };
    };
  };
}

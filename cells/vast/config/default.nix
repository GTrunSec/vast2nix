{
  inputs,
  cell,
}: {
  default = {
    vast = {
      # The file system path used for persistent state.
      db-directory = "./.cache/vast";
      # The file system path used for log files.
      log-file = "./.cache/server.log";
      # Load all installed plugins.
      plugins = ["all"];
    };
  };
}

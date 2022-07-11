{
  inputs,
  cell,
}: {
  metrics = {
    self-sink = {
      enable = true;
      slice-size = 128;
      slice-type = "arrow";
    };
    file-sink = {
      enable = false;
      real-time = false;
      path = ".cache/vast-metrics.log";
    };
    # Configures if and where metrics should be written to a socket.
    uds-sink = {
      enable = false;
      real-time = false;
      path = "./cache/vast-metrics.sock";
      type = "datagram";
    };
  };
}

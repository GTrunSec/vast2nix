{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib;
in
  builtins.mapAttrs (
    n: v:
      lib.recursiveUpdate v {
        schemas.result = {
          validation = {
            type = "integer";
          };
          example = "enum [ -1 0 1 ]";
        };
      }
  ) {
    Having_Ip_Address = {
      schemas.data = {
        validation.type = "string";
        example = "1.1.1.1";
      };
      schemas.result = {
        rule = {
          "0" = "if IP address is present";
          "1" = "otherwise";
        };
      };
      description = ''
        This is generally an indicator of attempts to collect personal data,
        as many phishing websites employ this trick. All the websites employing
        this trick present in the dataset are associated with phishing websites.
      '';
    };
    Url_length = {
      schemas.data = {
        validation.type = "integer";
      };
      schemas.result.rule = {
        "0" = "if URL Length < 54";
        "-1" = "if 54 ≤ URL Length ≤ 75";
        "1" = "otherwise";
      };
      description = ''
        Phishing websites often hide suspicious parts of their URLs at the
        end of long URLs which redirect the information submitted by users
        or redirect the web page itself. A length of 54 characters has been
        suggested in previous research [27] to separate phishing websites from legitimate ones.
      '';
    };
  }

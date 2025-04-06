{ lib, config, ... }:
let cfg = config.sys.media.printing;
in with lib; {
  options.sys.media.printing = {
    enable = mkEnableOption "Enable printer settings";
  };

  config = mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}

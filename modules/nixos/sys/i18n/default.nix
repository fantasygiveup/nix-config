{ lib, config, ... }:
let cfg = config.sys.i18n;
in with lib; {
  options.sys.i18n = { enable = mkEnableOption "Enable language settings"; };

  config = mkMerge [
    (mkIf cfg.enable {
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LANGUAGE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
    })

    (mkIf config.services.xserver.enable {
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us,pl,ua";
        variant = "";
      };
    })
  ];
}

{ config, lib, ... }:

{
  options.color = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {
      variant = "light";
      bg0 = "eff1f5";
      bg1 = "454545";
      bg2 = "616161";
      bg3 = "565656";
      bg4 = "ececec";
      fg0 = "4c4f69";
      fg1 = "e0e0e0";
      a0 = "bcc0cc";
      a1 = "d20f39";
      a2 = "40a02b";
      a3 = "df8e1d";
      a4 = "1e66f5";
      a5 = "ea76cb";
      a6 = "04a5e5";
      a7 = "dce0e8";
      a8 = "bcc0cc";
      a9 = "de0332";
      a10 = "37ab20";
      a11 = "ec8e10";
      a12 = "1462ff";
      a13 = "f26ecd";
      a14 = "0090e9";
      a15 = "434872";
      g1 = "cccccc";
      g2 = "0a4ed3";
      g3 = "9dbff9";
      g4 = "9f6414";
      g5 = "f0d2a7";
      g6 = "bc0d33";
      g7 = "f8a8b9";
      g8 = "f7ead3";
      g9 = "ff9800";
    };
    description = ''
      Catppuccin Latte is the light theme variant.
    '';
  };
}

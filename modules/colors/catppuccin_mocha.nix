{ config, lib, ... }:

{
  options.color = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {
      variant = "dark";
      bg0 = "1e1e2e";
      bg1 = "454545";
      bg2 = "616161";
      bg3 = "565656";
      bg4 = "ececec";
      fg0 = "cdd6f4";
      fg1 = "e0e0e0";
      a0 = "45475a";
      a1 = "f38ba8";
      a2 = "a6e3a1";
      a3 = "f9e2af";
      a4 = "89b4fa";
      a5 = "f5c2e7";
      a6 = "89dceb";
      a7 = "11111b";
      a8 = "4d4d52";
      a9 = "ec92a8";
      a10 = "addba9";
      a11 = "f4e2b4";
      a12 = "8fb4f4";
      a13 = "f1c6e7";
      a14 = "90d7e4";
      a15 = "d0d6f1";
      g1 = "464668";
      g2 = "b9d2fb";
      g3 = "2574f8";
      g4 = "fcf6e6";
      g5 = "cf8d0c";
      g6 = "f6bacb";
      g7 = "ec2d62";
      g8 = "9c6b0c";
      g9 = "ff9800";
    };
    description = ''
      Catppuccin Mocha is the dark theme variant.
    '';
  };
}

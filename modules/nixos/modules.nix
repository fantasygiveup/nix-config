{ lib, ... }:
let
  files = lib.fileset.toList
    (lib.fileset.fileFilter (file: file.name == "default.nix") ./.);
in builtins.map (file: import file) files

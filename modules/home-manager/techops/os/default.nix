{ lib, config, pkgs, ... }:

let cfg = config.techops.os;
in with lib; {
  options.techops.os = {
    enable = mkEnableOption "Enable system configuration tools";
  };

  config = mkIf cfg.enable {
    xdg.configFile."clang-format/clang-format".source =
      ./clang-format/clang-format;

    home.packages = with pkgs; [
      # autopoint envsubst gettext gettext.sh gettextize msgattrib msgcat msgcmp msgcomm msgconv msgen
      # msgexec msgfilter msgfmt msggrep msginit msgmerge msgunfmt msguniq ngettext recode-sr-latin
      # xgettext
      gettext

      # aclocal automake
      automake

      # addr2line ar as c++ c++filt cc cpp dwp elfedit g++ gcc gnat gnatbind gnatchop gnatclean gnatkr
      # gnatlink gnatls gnatmake gnatname gnatprep gprof ld ld.bfd ld.gold nm objcopy objdump ranlib
      # readelf size strings strip
      gnat

      pkg-config

      ccls # lsp for cpp

      # clang-apply-replacements clang-change-namespace clang-check clang-doc clang-extdef-mapping
      # clang-format clang-include-cleaner clang-include-fixer clang-linker-wrapper clang-move
      # clang-offload-bundler clang-offload-packager clang-pseudo clang-query clang-refactor
      # clang-rename clang-reorder-fields clang-repl clang-scan-deps clang-tidy clangd
      clang-tools

      # cmake cpack ctest
      cmake
    ];
  };
}

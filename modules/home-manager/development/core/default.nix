{ lib, config, pkgs, ... }:

let cfg = config.development.core;
in {
  options.development.core = {
    enable = lib.mkEnableOption
      "Enable the collection of compilers, linters, checkers, formatters, lsp servers, etc.";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."clang-format/clang-format".source =
      ./clang-format/clang-format;
    xdg.configFile."eslint/eslintrc.json".source = ./eslint/eslintrc.json;
    xdg.configFile."prettier/prettier.config.js".source =
      ./prettier/prettier.config.js;
    xdg.configFile."stylua/stylua.toml".source = ./stylua/stylua.toml;
    xdg.configFile."yamllint/config.yaml".source = ./yamllint/config.yaml;

    home.packages = [
      pkgs.ansible
      pkgs.ccls # c++ lsp
      pkgs.clang-tools
      pkgs.cmake
      pkgs.delve # golang debugger
      pkgs.emmet-ls # emmet support based on lsp
      pkgs.erun # elixir <file.exs> wrapper
      pkgs.eslint
      pkgs.go
      pkgs.golangci-lint
      pkgs.golines
      pkgs.gopls # go lsp
      pkgs.gotools # set of go language tools
      pkgs.libxml2 # xmllint
      pkgs.lua-language-server
      pkgs.luajit # lua interpreter
      pkgs.luarocks # lua package manager
      pkgs.nixd # nix lsp
      pkgs.nixfmt-classic # nix formatter
      pkgs.nodePackages.eslint # javascript linter
      pkgs.nodePackages.prettier
      pkgs.nodePackages.typescript-language-server
      pkgs.nodejs # javascript/typescript interpreter
      pkgs.pgformatter # sql formatter # TODO: integrate with neovim
      pkgs.prettierd
      pkgs.pyright # python formatter
      pkgs.rlwrap # enable the emacs navigation.
      pkgs.sbcl # common lisp compiler
      pkgs.schemacrawler # generate graphs from sql databases
      pkgs.shfmt # shell files formatter
      pkgs.stylua
      pkgs.stylua
      pkgs.tailwindcss-language-server
      pkgs.terraform
      pkgs.terraform-ls
      pkgs.typescript
      pkgs.unstable.elixir
      pkgs.unstable.elixir-ls
      pkgs.unstable.erlang
      pkgs.vscode-langservers-extracted # cssls
      pkgs.yamllint
      pkgs.yapf # python formatter # TODO: inegrate with neovim
    ];

    programs.zsh.shellAliases = {
      luajit = "${pkgs.rlwrap}/bin/rlwrap ${pkgs.luajit}/bin/luajit";
    };
  };
}

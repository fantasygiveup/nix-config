{ lib, config, pkgs, ... }:

let cfg = config.techops.dev;
in {
  options.techops.dev = {
    enable = lib.mkEnableOption
      "Enable a collection of the base programming language tools";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."eslint/eslintrc.json".source = ./eslint/eslintrc.json;
    xdg.configFile."prettier/prettier.config.js".source =
      ./prettier/prettier.config.js;
    xdg.configFile."stylua/stylua.toml".source = ./stylua/stylua.toml;
    xdg.configFile."yamllint/config.yaml".source = ./yamllint/config.yaml;

    home.packages = with pkgs; [
      ansible
      delve # go debugger
      emmet-ls # lsp for emmet snippets
      erun # elixir script interface
      eslint
      gnumake # make
      go
      golangci-lint
      golines
      gopls # go lsp
      gotools # set of go language tools
      inotify-tools # required by elixir mix
      jq # cli json processor
      libxml2 # xmllint
      lua-language-server
      luajit # lua interpreter
      luarocks # lua package manager
      nixd # nix lsp
      nixfmt-classic # nix formatter
      nodePackages.eslint # javascript linter
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodejs # javascript/typescript interpreter
      pgformatter # sql formatter # TODO: integrate with neovim
      prettierd
      pyright # python formatter
      rlwrap # enable the emacs navigation.
      sbcl # common lisp compiler
      schemacrawler # generate graphs from sql databases
      shfmt # shell files formatter
      stylua
      tailwindcss-language-server
      terraform
      terraform-ls
      typescript
      unstable.elixir
      unstable.elixir-ls
      unstable.erlang
      vscode-langservers-extracted # cssls
      yamllint
      yapf # python formatter # TODO: inegrate with neovim
      yq # jq but for yaml
    ];

    # Enable iex persisting command history.
    home.sessionVariables = { ERL_AFLAGS = "-kernel shell_history enabled"; };

    programs.zsh.shellAliases = {
      luajit = "${pkgs.rlwrap}/bin/rlwrap ${pkgs.luajit}/bin/luajit";
      psqldev =
        ''${pkgs.postgresql}/bin/psql -h localhost -p 5432 -U postgres -p ""'';
    };
  };
}

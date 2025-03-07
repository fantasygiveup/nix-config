# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./main-user.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "st321"; # Define your hostname.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking.
  networking.networkmanager.enable = true;

  # Bluetooth.
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot =
    true; # powers up the default Bluetooth controller on boot
  # Using Bluetooth headset buttons to control media player.
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
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

  services.logind.extraConfig = ''
    HandleLidSwitchExternalPower=ignore
  '';

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ua";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Postgresql.
  services.postgresql = {
    enable = true;
    # Fix elixir language mix psql integration issue. We need set `trust` to avoid auth problem for
    # local development.
    authentication = pkgs.lib.mkOverride 10 ''
      # default value of services.postgresql.authentication
      local all all              trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = { defaultUserShell = pkgs.zsh; };

  main-user = {
    enable = true;
    userName = "idanko";
    userFullName = "Illia Danko";
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "IosevkaTerm" ]; })
      ubuntu_font_family
      corefonts # Microsoft free fonts
      fira-code # Monospace font with programming ligatures
      fira-mono # Mozilla's typeface for Firefox OS
      font-awesome
      google-fonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
      roboto # Android
      source-han-sans
    ];
    fontconfig = {
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>
            <match target="font">
                <edit name="antialias" mode="assign">
                    <!-- false,true -->
                    <bool>true</bool>
                </edit>
                <edit name="hinting" mode="assign">
                    <!-- false,true -->
                    <bool>true</bool>
                </edit>
                <edit name="autohint" mode="assign">
                    <!-- false,true -->
                    <bool>true</bool>
                </edit>
                <edit mode="assign" name="hintstyle">
                    <!-- hintnone,hintslight,hintmedium,hintfull -->
                    <const>hintslight</const>
                </edit>
                <edit name="rgba" mode="assign">
                    <!-- rgb,bgr,v-rgb,v-bgr -->
                    <const>rgb</const>
                </edit>
                <edit mode="assign" name="lcdfilter">
                    <!-- lcddefault,lcdlight,lcdlegacy,lcdnone -->
                    <const>lcddefault</const>
                </edit>
                <!-- https://wiki.archlinux.org/title/Microsoft_fonts !-->
                <edit name="embeddedbitmap" mode="assign">
                    <bool>false</bool>
                </edit>
            </match>
            <!-- Fallback fonts preference order -->
            <alias>
                <family>sans-serif</family>
                <prefer>
                    <family>Ubuntu</family>
                    <family>Noto Color Emoji</family>
                </prefer>
            </alias>
            <alias>
                <family>serif</family>
                <prefer>
                    <family>Ubuntu</family>
                    <family>Noto Color Emoji</family>
                </prefer>
            </alias>
            <alias>
                <family>monospace</family>
                <prefer>
                    <family>Ubuntu Mono</family>
                    <family>Noto Color Emoji</family>
                </prefer>
            </alias>
            <!-- https://wiki.archlinux.org/title/Microsoft_fonts !-->
            <alias binding="same">
                <family>Helvetica</family>
                <accept>
                    <family>Arial</family>
                </accept>
            </alias>
            <alias binding="same">
                <family>Times</family>
                <accept>
                    <family>Times New Roman</family>
                </accept>
            </alias>
            <alias binding="same">
                <family>Courier</family>
                <accept>
                    <family>Courier New</family>
                </accept>
            </alias>
        </fontconfig>
      '';
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Enable docker.
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    automake
    bc
    dmidecode
    dnsutils
    dos2unix # Convert between DOS and Unix line endings
    ethtool
    fd
    file
    fzf
    gdb
    gettext
    git
    gnat # core development tools: compilers, linkers, etc.
    gnumake
    hdparm
    htop
    inotify-tools # required by elixir mix
    iperf
    ispell
    jq # json parser
    lshw
    lsof
    neofetch
    netcat
    nmap
    openssl
    p7zip
    pbzip2 # parallel (de-)compression
    pciutils
    pigz
    pixz
    pkg-config
    psmisc # provides: fuser, killall, pstree, peekfd
    python3
    ripgrep
    rsync
    tree
    unzip
    usbutils
    wget
    whois
    yq # jq but for yaml
    zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "docker-compose"
          "fzf"
          "gcloud"
          "git"
          "history"
          "kubectl"
          "mix"
          "npm"
          "postgres"
          "rsync"
          "rust"
          "yarn"
        ];
        theme = "intheloop";
      };
    };
  };

  home-manager = {
    # also pass inputs to home-manager modules.
    extraSpecialArgs = { inherit inputs; };
    users = { "idanko" = import ./home.nix; };
  };

  # Disable system auto upgrade (default).
  system.autoUpgrade.enable = false;
  programs.wireshark.enable = true;

  # To make the linker (ldd) works with the not nix native binaries.
  programs.nix-ld.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

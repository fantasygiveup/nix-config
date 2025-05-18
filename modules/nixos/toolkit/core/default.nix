{ lib, config, pkgs, ... }:
let cfg = config.toolkit.core;
in with lib; {
  options.toolkit.core = {
    enable = mkEnableOption "Enable system core packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # b2sum base32 base64 basename basenc cat chcon chgrp chmod chown chroot cksum comm coreutils cp
      # csplit cut date dd df dir dircolors dirname du echo env expand expr factor false fmt fold
      # groups head hostid id install join kill link ln logname ls md5sum mkdir mkfifo mknod mktemp mv
      # nice nl nohup nproc numfmt od paste pathchk pinky pr printenv printf ptx pwd readlink realpath
      # rm rmdir runcon seq sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf sleep sort
      # split stat stdbuf stty sum sync tac tail tee test timeout touch tr true truncate tsort tty
      # uname unexpand uniq unlink uptime users vdir wc who whoami yes
      coreutils-full

      gnumake # make

      # fuser killall peekfd prtstat pslog pstree pstree.x11
      psmisc

      # lspci pcilmr setpci
      pciutils

      # lsusb lsusb.py usb-devices usbhid-dump usbreset
      usbutils

      lshw # list hardware
      dmidecode # hardware info
      lsof # list open files

      file
      home-manager
      tree
      unstable.neovim

      p7zip
      unzip
      zip

      # nc ocspcheck openssl
      netcat

      # dnsdomainname ftp hostname ifconfig logger ping ping6 rcp rexec rlogin rsh talk telnet tftp traceroute whois
      inetutils

      # dig nslookup nsupdate
      dnsutils

      # ncat nmap nping
      nmap

      wget
      curl
    ];
  };
}

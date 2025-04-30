{
  "common" = import ../common;

  "misc/fonts/core" = import ./misc/fonts/core;

  "wm/gnome3" = import ./wm/gnome3;
  "wm/i3" = import ./wm/i3;

  "toolkit/core" = import ./toolkit/core;
  "toolkit/net" = import ./toolkit/net;
  "toolkit/extra" = import ./toolkit/extra;
  "toolkit/postgres" = import ./toolkit/postgres;
  "toolkit/wireshark" = import ./toolkit/wireshark;
  "toolkit/mullvad-vpn" = import ./toolkit/mullvad-vpn;
  "toolkit/gnupg" = import ./toolkit/gnupg;

  "user/main" = import ./user/main;

  "sys/net/core" = import ./sys/net/core;
  "sys/i18n" = import ./sys/i18n;
  "sys/time" = import ./sys/time;
  "sys/media/sound" = import ./sys/media/sound;
  "sys/media/bluetooth" = import ./sys/media/bluetooth;
  "sys/media/printing" = import ./sys/media/printing;
  "sys/virt/docker" = import ./sys/virt/docker;
}

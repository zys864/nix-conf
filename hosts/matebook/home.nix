
{ pkgs, ... }:

{
  imports = [

  ];

  home = { # Specific packages for desktop
    packages = with pkgs; [
      # Applications

    ];
  };

  services = { # Applets
    blueman-applet.enable = true; # Bluetooth
  };
}

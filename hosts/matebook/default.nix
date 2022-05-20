{ config, pkgs, lib, user, ... }:

{
  imports = # For now, if applying to other system, swap files
    [ (import ./hardware-configuration.nix) ]
    ++ # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    (import ../../modules/desktop/virtualisation) ++ # Virtual Machines & VNC
    (import ../../modules/hardware); # Hardware devices

  boot = { # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = { # For legacy boot:
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Limit the amount of configurations
      };
      efi.canTouchEfiVariables = true;
      timeout = 2; # Grub auto select time
    };
  };

  environment = { # Packages installed system wide
    systemPackages = with pkgs;
      [ # This is because some options need to be configured.

      ];
  };

  services = {
    blueman.enable = true; # Bluetooth
    printing = { # Printing and drivers for TS5300
      enable = true;
      drivers = [
        pkgs.cnijfilter2
      ]; # There is the possibility cups will complain about missing cmdtocanonij3. I guess this is just an error that can be ignored for now.
    };
    avahi = { # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = { # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    samba = { # File Sharing over local network
      enable = true; # Don't forget to set a password:  $ smbpasswd -a <user>
      shares = {
        share = {
          "path" = "/home/${user}";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
    xserver = { # In case, multi monitor support
      videoDrivers = [ # Video Settings
        "nvidia"
      ];
    };
  };
}

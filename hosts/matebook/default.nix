{ config, pkgs, lib, user, ... }:

{
  imports = # For now, if applying to other system, swap files
    [ (import ./hardware-configuration.nix) ]
    ++ # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    (import ../../modules/desktop/virtualisation) ++ # Virtual Machines & VNC
    (import ../../modules/hardware); # Hardware devices

  boot = { # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    loader = { # EFI Boot
      efi = { canTouchEfiVariables = true; };
      grub = { # Most of grub is set up for dual boot
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true; # Find all boot options
        configurationLimit = 2;
      };
      timeout = 1; # Grub auto select time
    };
  };

  environment = { # Packages installed system wide
    systemPackages = with pkgs;
      [ # This is because some options need to be configured.
      #kde
      libsForQt5.ark
      libsForQt5.kate
      libsForQt5.kweather
      libsForQt5.kde-gtk-config
      libsForQt5.kompare
      libsForQt5.krdc
      libsForQt5.bismuth # 平铺桌面

      falkon
      kalendar
      yakuake
      kcolorchooser
      ];
  };

  services = {
    xserver = { # In case, multi monitor support
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    desktopManager.plasma5.runUsingSystemd = true;
    videoDrivers = [ # Video Settings
        "nvidia"
      ];
    };
  };
  programs = {
    kdeconnect.enable = true;
    # kde 磁盘管理软件，仅仅添加到 systemPackages 是用不了，需要 suid 提权
    partition-manager.enable = true;
    # 用 kleopatra 软件可能需要这个
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "qt";
    };
  };
}

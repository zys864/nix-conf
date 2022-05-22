{ config, lib, pkgs, inputs, user, location, ... }:

{
  imports = # Import window or display manager.
    [
      ../modules/editors/nvim # ! Comment this out on first install !
    ];

  users.users.${user} = { # System User
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "camera"
      "networkmanager"
      "lp"
      "kvm"
      "libvirtd"
    ];
    shell = pkgs.zsh; # Default shell
  };
  security.sudo.wheelNeedsPassword =
    false; # User does not need to give password when using sudo.

  time.timeZone = "Asia/Shanghai"; # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { # Extra locale settings that need to be overwritten
      LC_TIME = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
    };
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";	                    # or us/azerty/etc
  # };

  fonts.fonts = with pkgs; [ # Fonts
    cascadia-code # NixOS
    jetbrains-mono
    font-awesome # Icons
    corefonts # MS
    (nerdfonts.override { # Nerdfont Icons override
      fonts = [ "FiraCode" ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [ # Default packages install system-wide
      neovim
      wget
      curl
      ripgrep
      fd
      bat
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
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      desktopManager.plasma5.runUsingSystemd = true;
    };
    openssh = { # SSH
      enable = true;
      # allowSFTP = true;
    };
    sshd.enable = true;
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
  nix = { # Nix Package Manager settings
    settings = {
      auto-optimise-store = true; # Optimise syslinks
    };
    gc = { # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # 使用镜像源
    binaryCaches = lib.mkBefore [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    package = pkgs.nixFlakes; # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      
              experimental-features = nix-command flakes
              keep-outputs          = true
              keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true; # Allow proprietary software.

  system = { # NixOS settings
    autoUpgrade = { # Allow auto update
      # enable = true;
      channel =
        "https://mirror.sjtu.edu.cn/nix-channels/store";
    };
    stateVersion = "21.11";
  };

}

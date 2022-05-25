{ config, lib, pkgs, inputs, user, location, ... }:

{
  imports = 
    [
      ../modules/editors/nvim 
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

    ];
  };

  services = {
    
    openssh = { # SSH
      enable = true;
      # allowSFTP = true;
    };
    sshd.enable = true;
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

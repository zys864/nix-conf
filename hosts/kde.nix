{ config, lib, pkgs, inputs, user, location, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # 用 systemd 管理 plasma session 加速启动
  services.xserver.desktopManager.plasma5.runUsingSystemd = true;

  ## 以上配置即可启用 kde 桌面
  ## 以下配置按需选择定制：

  # 色彩配置服务
  services.colord.enable = true;

  # 地理位置服务
  services.geoclue2.enable = true;

  programs.kdeconnect.enable = true;

  # kde 磁盘管理软件，仅仅添加到 systemPackages 是用不了，需要 suid 提权
  programs.partition-manager.enable = true;

  # 用 kleopatra 软件可能需要这个
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  environment.systemPackages = with pkgs; [
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
}

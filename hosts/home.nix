{ config, lib, pkgs, user, ... }:

{
  imports = # Home Manager Modules
    (import ../modules/editors) ++ (import ../modules/programs)
    ++ (import ../modules/services) ++ (import ../modules/shell);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs;
      [

        # Apps
        firefox # Browser
      ];

    stateVersion = "21.11";
  };

  programs = { home-manager.enable = true; };

}

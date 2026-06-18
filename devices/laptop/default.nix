args@{ config, pkgs, inputs, ... }:
let 
  mesa-pkgs = 
    pkgs;
    #inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in
{
  local = {
    base.gui.full.enable = true;
    base.laptop.enable = true;
  };

  swapDevices = [ {
    device = "/.swapfile";
    size = 4000; # 4 GB
  } ];

  # monitor config with xrandr command
  services.xserver.displayManager.setupCommands = "${pkgs.xrandr}/bin/xrandr --output eDP --mode 1920x1200 --rate 120";

  ### amd gpu
  hardware = {
    amdgpu = {
      opencl.enable = true;
      # load drivers early in boot process
      initrd.enable = true;
    };
    graphics = {
      package   = mesa-pkgs              .mesa;
      package32 = mesa-pkgs.pkgsi686Linux.mesa;
    };
  };

  ### set up eduroam wifi
  # this is the .p12 file from the easyroam website encrypted using `sops encrypt -i`
  # NEVER OPEN THE ENRYPTED FILE! it might break it, causing easyroam-cert-setup to fail
  sops.secrets.easyroam = {
    sopsFile = ./easyroam.p12;
    key = "data";
    # recommended by nix-easyroam
    restartUnits = [ "easyroam-network-manager-setup.service" ];
  };
  # to reconfigure, run `sudo systemctl restart easyroam-network-manager-setup`
  # if connection doesnt work, check permissions and user/group of /run/easyroam/*,
  # and possible change them using the corresponding services.easyroam settings
  services.easyroam = {
    enable = true;
    networkmanager.enable = true;
    pkcsFile = config.sops.secrets.easyroam.path;
  };
}

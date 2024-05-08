# useful config / tools for laptops
args@{ pkgs, variables, secrets, ... }:
{
  networking.wireless.enable = true;

  # enable touchpad support
  services.xserver.libinput.enable = true;

  # eduroam wifi authentication
  networking.wireless.networks.eduroam.auth = ''
    key_mgmt=WPA-EAP
    eap=PWD
    identity="${secrets.eduroam.email}"
    password="${secrets.eduroam.password}"
  '';
}
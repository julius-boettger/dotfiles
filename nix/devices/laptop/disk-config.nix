# disk config using disko. i don't use this yet, but i plan to.
# https://github.com/nix-community/disko
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        # efi system partition
        esp = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "encrypted";
            askPassword = true; # set password when running disko
            settings.allowDiscards = true; # recommended for ssd
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # override existing partition
              subvolumes = {
                "/main" = {
                  mountpoint = "/";
                  swap.".swapfile".size = "8G";
                };
                "/home" = {
                  mountpoint = "/home";
                };
                "/nix" = {
                  mountpoint = "/nix";
                  # don't save last access time
                  mountOptions = [ "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
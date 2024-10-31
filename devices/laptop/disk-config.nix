# disk config using disko
# https://github.com/nix-community/disko
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        # efi system partition
        esp = {
          type = "EF00";
          size = "1G";
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
                  swap.".swapfile".size = "4G";
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
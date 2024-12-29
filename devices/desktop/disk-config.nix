# disk config using disko
# https://github.com/nix-community/disko
{
  disko.devices.disk = {
    # operating system disk
    nixos = {
      type = "disk";
      device = "/dev/nvme1n1"; # newer ssd
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
          main = {
            size = "100%";
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
    # encrypted data disk
    data = {
      type = "disk";
      device = "/dev/nvme0n1"; # older ssd
      content = {
        type = "gpt";
        partitions.luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "encrypted";
            askPassword = true; # set password when running disko
            initrdUnlock = false; # don't prompt passphrase on boot
            settings.allowDiscards = true; # recommended for ssd
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
            };
          };
        };
      };
    };
  };
}

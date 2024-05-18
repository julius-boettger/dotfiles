# disk config using disko. i don't use this yet, but i plan to.
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
            size = "512M";
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
            askPassword = true; # ask for password when running disko
            settings.allowDiscards = true; # recommended for ssd
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
            };
            # may be necessary to prevent passphrase prompt on boot
            #initrdUnluck = false; 
          };
        };
      };
    };
  };
}
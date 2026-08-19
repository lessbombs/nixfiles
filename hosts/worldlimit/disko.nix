{ ... }:
let
  commonMountOptions = [
    "compress=zstd:1"
    "noatime"
    "discard=async"
  ];
in {
  disko.devices.disk.main = {
    type = "disk";
    # prefer a stable /dev/disk/by-id path before running disko
    device = "/dev/disk/by-id/nvme-Samsung_SSD_9100_PRO_1TB_S7YENS0L201045B";

    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ 
              "fmask=0177"
              "dmask=0077"
              "noexec,nosuid,nodev"  # Security: no execution, ignore setuid, no device nodes 
            ];
          };
        };

        root = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypt";
            settings = {
              allowDiscards = true;
              bypassWorkqueues = true;
            };
            
            initrdUnlock = true;

            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # Override existing partition
              # Subvolumes must set a mountpoint in order to be mounted,
              # unless their parent is mounted

              mountpoint = "/mnt/btr_pool";
              mountOptions = [ "subvolid=5" ] ++ commonMountOptions;

              subvolumes = {
                "@snapshots" = { };
                "@" = { 
                  mountpoint = "/";
                  mountOptions = commonMountOptions;
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = commonMountOptions;
                };
                "@srv" = {
                  mountpoint = "/srv";
                  mountOptions = commonMountOptions;
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = commonMountOptions;
                };
              };
            };
          };
        };
      };
    };
  };
}

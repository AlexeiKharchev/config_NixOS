# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/" = {
      device = "/dev/disk/by-uuid/dfa0c9c5-56dc-4b72-882d-f783cba6a1a7";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd:5" ];
    };

  fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/4d2d7c1b-3440-437f-993c-7c3d0b6c88bc";
      fsType = "ext2";
    };

  fileSystems."/home" = {
      device = "/dev/disk/by-uuid/f2ddd23c-e8fd-42cf-899d-b5a8a8b0b1e8";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zlib:5" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
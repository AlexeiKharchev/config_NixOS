{ config, lib, pkgs, ... }:
let
  strNewLine = "\n";
  strGrub2MenuFunctions = builtins.readFile /boot/grub/parts/funcs.cfg;
  strGrub2MenuMint      = builtins.readFile /boot/grub/parts/Mint.cfg;
  strGrub2MenuGeoLinux  = builtins.readFile /boot/grub/parts/GeoLinux.cfg;
  strGrub2MenuGoboLinux = builtins.readFile /boot/grub/parts/GoboLinux.cfg;
  strGrub2MenuWindows   = builtins.readFile /boot/grub/parts/Windows.cfg;
  strGrub2Menu = "${strGrub2MenuFunctions}" + "${strNewLine}" + "${strGrub2MenuMint}" + "${strNewLine}" + "${strGrub2MenuGeoLinux}" + "${strNewLine}" + "${strGrub2MenuGoboLinux}" + "${strNewLine}" + "${strGrub2MenuWindows}";
in
{
  boot = {
    initrd = {
      supportedFilesystems = {
        btrfs = true;
        zfs = lib.mkForce false;
      };
      availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];  # ext2
      # kernelModules = [ ]; # "kvm-intel"
    };
    #extraModulePackages = [ ]; default []

    # updating GRUB2 menu...
    # Define on which hard drive you want to install Grub.
    loader.grub = {
      enable = true;  # Use the GRUB 2 boot loader.
      device = "/dev/sda"; # or "nodev" for efi only
     # splashImage="";
      backgroundColor = "#7EBAE4";
     # font = "";
      fontSize = 16;
     # default = "0"; # which line is default

     # efiSupport = true;
     # efiInstallAsRemovable = true;
     # efiSysMountPoint = "/boot/efi";

      extraEntries = "${strGrub2Menu}";
    };
  };
}

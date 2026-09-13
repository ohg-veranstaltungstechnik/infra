{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules = ["ahci" "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = ["dm-snapshot"];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

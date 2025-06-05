{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "uas"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [ ];
    };
    kernelModules = [
      "kvm-intel"
      "btintel"
    ];
    extraModulePackages = [ ];
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

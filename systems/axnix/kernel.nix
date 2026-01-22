{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
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

  hardware = {
    graphics.enable = true;
    amdgpu.opencl.enable = true;
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

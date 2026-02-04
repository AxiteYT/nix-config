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
      "kvm-amd"
      "i2c-dev"
      "i2c-piix4"
    ];
    kernelParams = [
      "amd_pstate=active"
      "iommu=pt"
      "acpi_enforce_resources=lax"
    ];
    extraModulePackages = [ ];
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

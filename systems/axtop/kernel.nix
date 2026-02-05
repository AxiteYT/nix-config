{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  boot.kernelModules = [ "hid-microsoft" ];
  boot.kernelPatches = [
    {
      name = "disable-rust";
      patch = null;
      extraConfig = ''
        RUST n
      '';
    }
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

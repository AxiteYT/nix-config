{
  pkgs,
  lib,
  config,
  ...
}:
{
  nixpkgs.config.nvidia.acceptLicense = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true; # Disable if issues with sleep/suspend
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaSettings = true;
      open = true;
    };
    graphics = {
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}

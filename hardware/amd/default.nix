{ pkgs, ... }:
{
  # Enable GPU Drivers
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa.opencl # Enables Rusticl (OpenCL) support
      ];
    };
    amdgpu.opencl.enable = true;
  };

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  # LACT
  environment.systemPackages = with pkgs; [ lact ];
  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };

  # HIP hard-code workaround
  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
}

{ pkgs, ... }:
{
  # Enable GPU Driivers
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
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

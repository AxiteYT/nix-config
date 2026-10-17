{ inputs, ... }:
{
  imports = [ inputs.artcraft.nixosModules.default ];

  # Upstream also exposes system fonts where the apps' text tools look for them.
  programs.artcraft.enable = true;
}

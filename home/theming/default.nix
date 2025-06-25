{ pkgs, ... }:
{
  gtk.theme.name = "Adwaita-dark";
  qt.style.name = "adwaita-dark";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 24;
  };
}

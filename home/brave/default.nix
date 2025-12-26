{ ... }:
{
  # Preserve the current Brave profile preferences/bookmarks without syncing caches.
  xdg.configFile."BraveSoftware/Brave-Browser/Default/Preferences".source = ./Preferences;
  xdg.configFile."BraveSoftware/Brave-Browser/Default/Bookmarks".source = ./Bookmarks;
}

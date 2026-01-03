{ pkgs, ... }:

{
  # Ship a local desktop entry so launchers (wofi, etc.) use the basic password store.
  home.file.".local/share/applications/brave-browser.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Brave Web Browser
    GenericName=Web Browser
    Comment=Access the internet
    Icon=brave-browser
    Categories=Network;WebBrowser;
    Exec=${pkgs.brave}/bin/brave --password-store=basic %U
    Terminal=false
    StartupNotify=true
    MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;
    Actions=new-window;new-private-window;

    [Desktop Action new-window]
    Name=New Window
    Exec=${pkgs.brave}/bin/brave --password-store=basic

    [Desktop Action new-private-window]
    Name=New Incognito Window
    Exec=${pkgs.brave}/bin/brave --password-store=basic --incognito
  '';

  # Keep the portal desktop-id variant hidden but aligned with the same flags to avoid duplicates.
  home.file.".local/share/applications/com.brave.Browser.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Brave Web Browser
    NoDisplay=true
    Hidden=true
    NotShowIn=Hyprland;GNOME;KDE;Plasma;XFCE;
    Icon=brave-browser
    Categories=Network;WebBrowser;
    Exec=${pkgs.brave}/bin/brave --password-store=basic %U
    Terminal=false
    StartupNotify=true
    Actions=new-window;new-private-window;

    [Desktop Action new-window]
    Name=New Window
    Exec=${pkgs.brave}/bin/brave --password-store=basic

    [Desktop Action new-private-window]
    Name=New Incognito Window
    Exec=${pkgs.brave}/bin/brave --password-store=basic --incognito
  '';
}

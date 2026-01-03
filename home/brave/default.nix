{ ... }:

{
  # Override the Brave launcher to force a basic password store.
  xdg.desktopEntries."brave-browser" = {
    name = "Brave Web Browser";
    genericName = "Web Browser";
    comment = "Access the internet";
    exec = "brave --password-store=basic %U";
    terminal = false;
    icon = "brave-browser";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "application/pdf"
      "application/rdf+xml"
      "application/rss+xml"
      "application/xhtml+xml"
      "application/xhtml_xml"
      "application/xml"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/webp"
      "text/html"
      "text/xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    startupNotify = true;
    type = "Application";
    actions = {
      new-window = {
        name = "New Window";
        exec = "brave --password-store=basic";
      };
      new-private-window = {
        name = "New Incognito Window";
        exec = "brave --password-store=basic --incognito";
      };
    };
  };
}

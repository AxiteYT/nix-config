{ pkgs, config, ... }:
  let
    colors = config.lib.stylix.colors;
    hex = c: "#${c}";
    hexa = a: c: "#${c}${a}";
  in
{
  home = {
    packages = with pkgs; [
      wofi
    ];
  };

  home.file = {
    ".config/wofi/config" = {
      text = ''
        width=40%
        height=40%
        location=0
        prompt=Search...
        filter_rate=100
        allow_markup=false
        no_actions=true
        halign=fill
        orientation=vertical
        content_halign=fill
        insensitive=true
        allow_images=true
        image_size=20
        hide_scroll=true
      '';
    };
    ".config/wofi/style.css" = {
      text = ''
        :root {
          --bg: ${hexa "66" colors.base00};
          --bg-weak: ${hexa "40" colors.base00};
          --fg: ${hex colors.base06};
          --accent: ${hex colors.base0D};
          --muted: ${hex colors.base03};
        }
        /* The name of the window itself */
        #window {
          background-color: var(--bg);
          box-shadow: 0 10px 15px -3px var(--bg-weak),
            0 4px 6px -4px var(--bg-weak);
          border-radius: 1rem;
          font-size: 1.2rem;
          /* The name of the box that contains everything */
        }
        #window #outer-box {
          /* The name of the search bar */
          /* The name of the scrolled window containing all of the entries */
        }
        #window #outer-box #input {
          background-color: var(--bg);
          color: var(--fg);
          border: none;
          border-bottom: 1px solid var(--muted);
          padding: 0.8rem 1rem;
          font-size: 1.5rem;
          border-radius: 1rem 1rem 0 0;
        }
        #window #outer-box #input:focus,
        #window #outer-box #input:focus-visible,
        #window #outer-box #input:active {
          border: none;
          outline: 2px solid transparent;
          outline-offset: 2px;
        }
        #window #outer-box #scroll {
          /* The name of the box containing all of the entries */
        }
        #window #outer-box #scroll #inner-box {
          /* The name of all entries */
          /* The name of all boxes shown when expanding  */
          /* entries with multiple actions */
        }
        #window #outer-box #scroll #inner-box #entry {
          color: var(--fg);
          background-color: var(--bg-weak);
          padding: 0.6rem 1rem;
          /* The name of all images in entries displayed in image mode */
          /* The name of all the text in entries */
        }
        #window #outer-box #scroll #inner-box #entry #img {
          width: 1rem;
          margin-right: 0.5rem;
        }
        #window #outer-box #scroll #inner-box #entry:selected {
          color: var(--fg);
          background-color: var(--accent);
          outline: none;
        }

      '';
    };
    ".config/wofi/power.sh" = {
      executable = true;
      text = ''
        #!/bin/sh

        entries="⏾ Suspend\n⭮ Reboot\n⏻ Shutdown"

        selected=$(echo -e $entries|wofi --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

        case $selected in
          suspend)
            exec systemctl suspend;;
          reboot)
            exec systemctl reboot;;
          shutdown)
            exec systemctl poweroff -i;;
        esac
      '';
    };
  };
}

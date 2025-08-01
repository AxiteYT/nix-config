{ pkgs, config, ... }:
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
        @define-color base00 #282828;
        @define-color base01 #3C3836;
        @define-color base02 #504945;
        @define-color base03 #665C54;
        @define-color base04 #BDAE93;
        @define-color base06 #D5C4A1;
        @define-color base06 #EBDBB2;
        @define-color base07 #FBF1C7;
        @define-color base08 #FB4934;
        @define-color base09 #FE8019;
        @define-color base0A #FABD2F;
        @define-color base0B #B8BB26;
        @define-color base0C #8EC07C;
        @define-color base0D #83A598;
        @define-color base0E #D3869B;
        @define-color base0F #D65D0E;

        window {
            opacity: 0.9;
            border:  0px;
            border-radius: 10px;
            font-family: monospace;
            font-size: 18px;
        }

        #input {
        	border-radius: 10px 10px 0px 0px;
            border:  0px;
            padding: 10px;
            margin: 0px;
            font-size: 28px;
        	color: #8EC07C;
        	background-color:rgb(45, 76, 94);
        }

        #inner-box {
        	margin: 0px;
        	color: @base06;
        	background-color: @base00;
        }

        #outer-box {
        	margin: 0px;
        	background-color: @base00;
            border-radius: 10px;
        }

        #selected {
        	background-color: #608787;
        }

        #entry {
        	padding: 0px;
            margin: 0px;
        	background-color: @base00;
        }

        #scroll {
        	margin: 5px;
        	background-color: @base00;
        }

        #text {
        	margin: 0px;
        	padding: 2px 2px 2px 10px;
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

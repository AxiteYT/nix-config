{
  pkgs,
  lib,
  ...
}:
{
  programs.wlogout = {
    enable = true;
    style = ''
      * {
        background-image: none;
      }

      window {
        background-color: alpha(#16191C, 0.8);
      }

      button {
        background-color: #171D23;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:focus, button:active, button:hover {
        background-color: #1D252C;
      }

      #lock {
        opacity: 0.8;
        background-image: image(url("${../assets/wlogout/icons/lock.png}"), url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
        opacity: 0.8;
        background-image: image(url("${../assets/wlogout/icons/logout.png}"), url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
        opacity: 0.8;
        background-image: image(url("${../assets/wlogout/icons/suspend.png}"), url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
        opacity: 0.8;
        background-image: image(url("${../assets/wlogout/icons/hibernate.png}"), url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
        opacity: 0.8;
        background-image: image(url("${../assets/wlogout/icons/shutdown.png}"), url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
        opacity: 0.8;
        background-image: image(url("${../assets/wlogout/icons/reboot.png}"), url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }
    '';
  };
}

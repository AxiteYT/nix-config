{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}

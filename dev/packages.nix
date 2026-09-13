{
  perSystem = {pkgs, ...}: {
    devshells.default.devshell.packages = [
      pkgs.sops
      pkgs.just
    ];
  };
}

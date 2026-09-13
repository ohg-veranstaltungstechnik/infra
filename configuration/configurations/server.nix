{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    ../modules/common
    ../modules/nixos/ssh
    ../modules/common/sops.nix
  ];

  custom = {
    ssh.enable =
      lib.mkDefault true;

    sops.enable =
      lib.mkDefault true;
  };
}

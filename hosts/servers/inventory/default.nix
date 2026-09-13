{
  provider = "local";
  type = "nixos";
  system = "x86_64-linux";

  deploy = {
    enable = true;
    targetHost = "inventory-deploy";
    targetPort = 22;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}

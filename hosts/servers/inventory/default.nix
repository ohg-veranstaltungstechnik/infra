{
  provider = "local";
  type = "nixos";
  system = "x86_64-linux";

  deploy = {
    enable = true;
    targetHost = "inventory";
    targetPort = 22;
    targetUser = "deploy";
    buildOnTarget = true;
  };

  modules = [
    ./configuration.nix
  ];
}

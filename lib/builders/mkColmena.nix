{
  inputs,
  self,
  nixpkgs,
  hosts,
  lib,
  ...
}: let
  colmenaHosts =
    lib.filterAttrs (
      _: host:
        host.system == "x86_64-linux" && host.deploy.enable == true
    )
    hosts;
in
  inputs.colmena.lib.makeHive (
    {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };

        specialArgs = {
          inherit inputs self hosts;
        };
      };
    }
    // lib.mapAttrs
    (_name: host: {
      deployment = {
        targetHost = host.deploy.targetHost;
        targetUser = host.deploy.targetUser;
        targetPort = host.deploy.targetPort;
        buildOnTarget = host.deploy.buildOnTarget;
      };

      imports = host.modules;
    })
    colmenaHosts
  )

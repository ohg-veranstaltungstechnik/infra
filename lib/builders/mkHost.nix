{
  inputs,
  self,
  hosts,
}: _name: host: let
  builders = {
    nixos = inputs.nixpkgs.lib.nixosSystem;
  };

  builder =
    builders.${host.type}
        or (throw "Unknown host type '${host.type}'");
in
  builder {
    inherit (host) system modules;

    specialArgs = {
      inherit self inputs host hosts;
    };
  }

{
  imports = [
    ./motd.nix
    ./packages.nix
  ];
  perSystem.devshells.default.devshell = {
    name = "OHG Veranstaltungstechnik devshell";
    meta.description = "This is a devshell for development of the OHG Veranstaltungstechnik infrastructure flake";
  };
}

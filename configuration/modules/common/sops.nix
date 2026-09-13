{
  self,
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    custom.sops.enable =
      lib.mkEnableOption "sops";
  };

  config = lib.mkIf config.custom.sops.enable {
    sops = {
      # defaultSopsFile = "${self}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        keyFile =
          if pkgs.stdenv.hostPlatform.isDarwin
          then "Users/xm0se/.config/sops/age/keys.txt"
          else "/var/lib/sops-nix/key.txt";
        sshKeyPaths = [];
      };
    };
  };
}

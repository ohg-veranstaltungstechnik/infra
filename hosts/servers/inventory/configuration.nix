{
  pkgs,
  config,
  self,
  ...
}: {
  imports = [
    ./shelf.nix
    ./hardware-configuration.nix
    ./disko.nix
    (self + "/configuration/configurations/server.nix")
  ];

  sops.defaultSopsFile = "${self}/secrets/inventory.yaml";

  networking = {
    hostName = "inventory";
    firewall.enable = false;
  };

  time.timeZone = "Europe/Berlin";

  sops.secrets = {
    "userPasswords/moritz".neededForUsers = true;
    "userPasswords/root".neededForUsers = true;
  };

  users = {
    mutableUsers = false;
    users = {
      moritz = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        home = "/moritz";
        hashedPasswordFile = config.sops.secrets."userPasswords/moritz".path;
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINO16vY+YdQ1neU5XCSo6yVQ6Un39tgAALk3gZJ1xgsJ inventory-moritz"];
      };
      deploy = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPassword = "!";
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDlb1UC5S1YD9qQaUqQA+0hTwJwKrlRt1mCbObP8+qBU inventory-deploy"];
      };
      root = {
        home = "/root";
        hashedPasswordFile = config.sops.secrets."userPasswords/root".path;
      };
    };
  };

  services.xserver.xkb.layout = "us";
  security.sudo.extraRules = [
    {
      users = ["deploy"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.sops
    pkgs.git
    pkgs.wget
  ];

  system.stateVersion = "26.11";
}

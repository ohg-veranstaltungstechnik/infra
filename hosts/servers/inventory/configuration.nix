{
  pkgs,
  config,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    (self + "/configuration/configurations/server.nix")
  ];

  custom.sops.enable = false;
  sops = {
    defaultSopsFile = "${self}/secrets/server-01.yaml";
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [];
    };
  };

  networking = {
    hostName = "inventory";
    firewall.enable = true;
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
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSsrnuLMIV2uOssQvdy8yCyqh/qLb2KzsBG85FlB6qB server-01-moritz"];
      };
      deploy = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        hashedPassword = "!";
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjNR/+qtZJn3g6thm437eINn++e+ADzHhlHEmA14UW8 server-01-deploy"];
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

  environment.systemPackages = [
    pkgs.vim
    pkgs.sops
    pkgs.git
    pkgs.wget
  ];

  system.stateVersion = "26.11";
}

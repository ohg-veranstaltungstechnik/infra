{
  config,
  lib,
  ...
}: {
  options = {
    custom.ssh.enable =
      lib.mkEnableOption "ssh";
  };

  config = lib.mkIf config.custom.ssh.enable {
    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          UseDns = false;
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };
      fail2ban = {
        enable = true;
      };
    };
  };
}

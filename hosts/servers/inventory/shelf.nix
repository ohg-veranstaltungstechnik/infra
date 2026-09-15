{
  self,
  config,
  ...
}: {
  sops = {
    secrets = let
      secretsFile = "${self}/secrets/services/shelf.yaml";
      secrets = [
        "supabase/anon_key"
        "supabase/service_role_key"
        "supabase/postgres_passord"
        "shelf/session_secret"
        "shelf/invite_token_secret"
        "smtp/smtp_pwd"
        "maptiler/maptiler_token"
      ];
    in
      builtins.listToAttrs (map (name: {
          inherit name;
          value.sopsFile = secretsFile;
        })
        secrets);

    templates."shelf-secrets.env".content = ''
      SUPABASE_ANON_PUBLIC=${config.sops.placeholder."supabase/anon_key"}
      SUPABASE_SERVICE_ROLE=${config.sops.placeholder."supabase/service_role_key"}

      DATABASE_URL=postgres://supabase_admin:${config.sops.placeholder."supabase/postgres_passord"}@supabase-db:5432/postgres?pgbouncer=true
      DIRECT_URL=postgres://supabase_admin:${config.sops.placeholder."supabase/postgres_passord"}@supabase-db:5432/postgres

      SESSION_SECRET=${config.sops.placeholder."shelf/session_secret"}
      INVITE_TOKEN_SECRET=${config.sops.placeholder."shelf/invite_token_secret"}

      SMTP_PWD=${config.sops.placeholder."smtp/smtp_pwd"}
      MAPTILER_TOKEN=${config.sops.placeholder."maptiler/maptiler_token"}
    '';
  };

  virtualisation.oci-containers.containers.shelf = {
    image = "ghcr.io/shelf-nu/shelf.nu:latest";

    ports = [
      "3000:8080"
    ];

    environment = {
      SUPABASE_URL = "https://supabase.xm0se.dev";

      SERVER_URL = "http://192.168.2.6:3000";
      DISABLE_SSO = "true";
      DISABLE_SIGNUP = "true";

      NODE_ENV = "production";

      SMTP_HOST = "smtp.protonmail.ch";
      SMTP_PORT = "587";
      SMTP_USER = "moritz@xm0se.dev";
      SMTP_FROM = "moritz@xm0se.dev";

      NEXT_PUBLIC_ENABLE_BARCODES = "true";
      FEATURE_ALTERNATIVE_BARCODES = "true";

      ENABLE_PREMIUM_FEATURES = "false";
    };

    environmentFiles = [
      "${config.sops.templates."shelf-secrets.env".path}"
    ];

    autoStart = true;

    extraOptions = [
      "--network=supabase_default"
    ];
  };
}

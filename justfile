[linux]
build bin="":
    sudo nixos-rebuild switch --flake ~/dotfiles#{{ bin }}
up:
    nix flake update

gc:
    sudo nix-collect-garbage --delete-old

deploy bin="":
    colmena apply {{ if bin == "" { "" } else { "--on " + bin } }}

infastructure bin="":
    nix run .#terranix.{{ if bin == "" { "apply" } else { bin } }}

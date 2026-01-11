Upgrade NixOS Packages
`sudo nix flake update`

Switch to new build
`sudo nixos-rebuild switch --flake .#geo-nix`

Run garbage collection
`sudo nix-collect-garbage -d`

optimize store
`sudo nix store optimise`
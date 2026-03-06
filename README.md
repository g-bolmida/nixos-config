Upgrade NixOS Packages
`sudo nix flake update`

Switch to new build
`sudo nixos-rebuild switch --flake .#geo-nix`

Run garbage collection
`sudo nix-collect-garbage -d`

optimize store
`sudo nix store optimise`

If taskbar items start dissapearing, run this:
- https://github.com/NixOS/nixpkgs/issues/308252#issuecomment-2543048917
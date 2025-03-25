{
  description = "ethan.haus";

  nixConfig = {
    extra-substituters = [ "https://ethan-haus.cachix.org" ];

    extra-trusted-public-keys = [
      "ethan-haus.cachix.org-1:gF27wCplP3mrLzWG7aVl2ReP9n3vkVdlhWVmeQyLVo4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { config, system, pkgs, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = let
            tf = pkgs.writeShellScriptBin "tf" ''
              ${pkgs.terraform}/bin/terraform -chdir=deploy $@
            '';
          in with pkgs; [
            cachix
            nixfmt-classic
            nodejs_22
            nodePackages_latest.pnpm
            sops
            tf
          ];

          shellHook = ''
            export SOPS_AGE_KEY_FILE="/Users/$USER/.config/sops/age/keys.txt"

            export VERCEL_API_TOKEN=$(sops -d --extract '["VERCEL_API_TOKEN"]' ./secrets.yaml)
          '';
        };
      };
    };
}

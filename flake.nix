{
  description = "ethan.haus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      imports = with inputs; [ devenv.flakeModule ];

      perSystem = { config, system, pkgs, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };

        devenv.shells.default = {
          packages = let
            tf = pkgs.writeShellScriptBin "tf" ''
              ${pkgs.terraform}/bin/terraform -chdir=deploy $@
            '';
          in with pkgs; [ nodejs_22 nodePackages_latest.pnpm sops tf ];

          enterShell = ''
            export SOPS_AGE_KEY_FILE="/Users/$USER/.config/sops/age/keys.txt"

            export RENDER_API_KEY=$(sops -d --extract '["RENDER_API_KEY"]' ./secrets.yaml)
            export RENDER_OWNER_ID=$(sops -d --extract '["RENDER_OWNER_ID"]' ./secrets.yaml)
          '';
        };
      };
    };
}

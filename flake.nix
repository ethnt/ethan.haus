{
  description = "ethan.haus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];

      imports = with inputs; [ devenv.flakeModule ];

      perSystem = { config, system, pkgs, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };

        devenv.shells.default = {
          packages = with pkgs; [ nodejs_22 nodePackages_latest.pnpm ];
        };
      };
    };
}

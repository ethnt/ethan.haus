{
  description = "ethan.haus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ nodejs_22 nodePackages_latest.pnpm ];
        };
      });
}

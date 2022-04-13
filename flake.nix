{
  description = "ethan.haus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = {
          build = pkgs.stdenv.mkDerivation rec {
            name = "ethan.haus-${version}";
            version = "0.1.0";
            src = self;

            buildInputs = with pkgs; [ zola ];

            checkPhase = ''
              zola check
            '';

            installPhase = ''
              zola build -o $out
            '';
          };
        };

        defaultPackage = packages.build;

        apps = {
          server = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "serve" ''
              ${pkgs.zola}/bin/zola serve
            '';
          };
        };

        defaultApp = apps.server;

        devShell = pkgs.mkShell { buildInputs = with pkgs; [ zola ]; };

        checks = {
          site = pkgs.runCommand "check" { } ''
            cd ${self}
            ${pkgs.zola}/bin/zola check
            mkdir $out
          '';
        };
      });
}

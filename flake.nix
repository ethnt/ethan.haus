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
        apps = {
          build = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "build" ''
              ${pkgs.zola}/bin/zola build
            '';
          };

          server = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "serve" ''
              ${pkgs.zola}/bin/zola serve
            '';
          };
        };

        defaultApp = apps.build;

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

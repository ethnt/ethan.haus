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

          deploy = flake-utils.lib.mkApp {
            drv = let build = self.packages.${system}.build;
            in pkgs.writeShellScriptBin "deploy" ''
              export AWS_ACCESS_KEY_ID=$(${pkgs.sops}/bin/sops -d --extract '["aws_access_key_id"]' ./secrets.yaml)
              export AWS_SECRET_ACCESS_KEY=$(${pkgs.sops}/bin/sops -d --extract '["aws_secret_access_key"]' ./secrets.yaml)

              ${pkgs.awscli}/bin/aws s3 sync ${build} s3://ethan.haus
            '';
          };
        };

        defaultApp = apps.server;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ sops terraform zola ];

          shellHook = ''
            export AWS_ACCESS_KEY_ID=$(sops -d --extract '["aws_access_key_id"]' ./secrets.yaml)
            export AWS_SECRET_ACCESS_KEY=$(sops -d --extract '["aws_secret_access_key"]' ./secrets.yaml)
          '';
        };

        checks = {
          # # Broken due to DNS resolution issues (see https://github.com/ethnt/ethan.haus/issues/1)
          # site = pkgs.runCommand "check" { } ''
          #   cd ${self}
          #   ${pkgs.zola}/bin/zola check
          #   mkdir $out
          # '';
        };
      });
}

{
  description = "yet another todo mvc repo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils/master";
    easy-ps = {
      url = "github:justinwoo/easy-purescript-nix/master";
      flake = false;
    };
    devshell.url = "github:numtide/devshell/master";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, easy-ps, devshell, ... }:
    let
      overlay = final: prev: {
        purs = (final.callPackage easy-ps { }).purs;
        purs-tidy = (final.callPackage easy-ps { }).purs-tidy;
        spago = (final.callPackage easy-ps { }).spago;
        spago2nix = (final.callPackage easy-ps { }).spago2nix;
      };
    in {
      inherit overlay;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay overlay ];
        };

      in rec {
        devShell = pkgs.devshell.mkShell {
          name = "purescript-by-example";
          imports = [ (pkgs.devshell.extraModulesDir + "/git/hooks.nix") ];
          git.hooks.enable = true;
          git.hooks.pre-commit.text = "${pkgs.treefmt}/bin/treefmt";
          commands = [
            {
              name = "node";
              category = "javascript";
              package = "nodejs";
            }
            {
              name = "spago";
              category = "purescript";
              package = "spago";
            }
            {
              name = "purs-tidy";
              category = "purescript";
              package = "purs-tidy";
            }
            {
              name = "purs";
              category = "purescript";
              package = "purs";
            }
            {
              name = "spago2nix";
              category = "purescript";
              package = "spago2nix";
            }
          ];
          packages = [
            pkgs.nodePackages.purescript-language-server
            pkgs.nodePackages.pscid

            # Others
            pkgs.treefmt
            pkgs.nixpkgs-fmt
          ];
        };
      });
}

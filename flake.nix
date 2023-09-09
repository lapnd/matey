{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixos-generators }: {
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux; in rec {
        iso = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            ./overlays.nix
            ./configuration.nix
          ];
          format = "iso";
        };
      };
  };
}
  #flake-utils.lib.eachDefaultSystem (system:
  #let
  #  pkgs = nixpkgs.legacyPackages.${system};
  #in
  #{
  #  packages = {
  #    hello = pkgs.hello;
  #    matey = pkgs.stdenv.mkDerivation {
  #      pname = "iimatey";
  #      src = pkgs.fetchFromGithub {
  #        owner = "ii";
  #        repo = "matey";
  #        rev = "/2f38e83f28db065cdc4f3f1c15c654869165f3a4";
  #        sha256 = "";
  #      };
  #    };
  #  };
  #});
  # devShell

  # optional arguments:
  # explicit nixpkgs and lib:
  # pkgs = nixpkgs.legacyPackages.x86_64-linux;
  # lib = nixpkgs.legacyPackages.x86_64-linux.lib;
  # additional arguments to pass to modules:
  # specialArgs = { myExtraArg = "foobar"; };

  # you can also define your own custom formats
  # customFormats = { "myFormat" = <myFormatModule>; ... };
  # format = "myFormat";
  # systemd.services.tmuxspawn = {
  #   enable = true;
  #   path = [
  #     wgtunnel
  #     matey
  #     pkgs.vim
  #     # iittyd
  #     pkgs.ttyd
  #     pkgs.tmux
  #     pkgs.wireguard-tools
  #   ];
  #   script = ''
  #     ${matey.outPath}/bin/matey start
  #   '';
  # };

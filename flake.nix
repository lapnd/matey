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

    nixpkgs.overlays = [
      (final: prev: {
        ttyd = prev.ttyd.overrideAttrs {
          src = prev.fetchGitHub {
            user = "ii";
            repo = "ttyd";
            rev = "936c048686b4c300860d78311f0efb46d41997be";
            sha256 = "";
          };
        };
      })
    ];

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

    packages.x86_64-linux = 
    let pkgs = nixpkgs.legacyPackages.x86_64-linux; in rec {
      hello = pkgs.hello;
      matey = pkgs.stdenv.mkDerivation {
        name = "iimatey";
        src = pkgs.fetchFromGitHub {
          owner = "ii";
          repo = "matey";
          rev = "/2f38e83f28db065cdc4f3f1c15c654869165f3a4";
          sha256 = "sha256-CFlJJTb1av4EVapOBgOsCOXHK29A9pFr8bJ1rwVIA3U=";
        };
        installPhase = ''
          mkdir -p $out/bin
          cp $src/iimatey $out/bin
        '';
      };
      #wgtunnel = pkgs.buildGoPackage {
      wgtunnel = pkgs.buildGoModule {
        pname = "wgtunnel";
        version = "0.1.2";

        src = pkgs.fetchFromGitHub {
          owner = "ii";
          repo = "wgtunnel";
          rev = "b578e62cbabd20b82e408dd4bfdc5b56cc252328";
          sha256 = "sha256-+V4l385Ks9VSxVT5tFDfenEoScEt8/VcUFlJb9I0Pjw=";
        };
        vendorHash = "sha256-ZC1LJW7UbgJITXG/0uGlaw1p+DvEQA0cCKwz8bLbAxw=";
      };
      iso = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          {
            services.getty.autologinUser = "root";
            programs.bash.interactiveShellInit = ''
              ${matey.outPath}/bin/iimatey start
            '';
            systemd.services.tmuxspawn = {
              enable = true;
              path = [
                wgtunnel
                matey
              ];
              script = ''
                ${matey.outPath}/bin/matey start
              '';
            };
            environment.systemPackages = [
              wgtunnel
              pkgs.ttyd
              pkgs.tmux
            ];
          }
        ];
        format = "iso";
        
        # optional arguments:
        # explicit nixpkgs and lib:
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # lib = nixpkgs.legacyPackages.x86_64-linux.lib;
        # additional arguments to pass to modules:
        # specialArgs = { myExtraArg = "foobar"; };
        
        # you can also define your own custom formats
        # customFormats = { "myFormat" = <myFormatModule>; ... };
        # format = "myFormat";
      };
    };
  };
}

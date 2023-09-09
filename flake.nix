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
    # devShell 
    packages.x86_64-linux = 
    let pkgs = nixpkgs.legacyPackages.x86_64-linux; in rec {
      iimatey = pkgs.stdenv.mkDerivation {
        name = "iimatey";
        # TODO: use git patches
        src = ./.;
        # buildInputs = [ iittyd ]  ;
        buildInputs = [ pkgs.ttyd ]  ;
        installPhase = ''
          mkdir -p $out/bin
          cp $src/iimatey $out/bin
        '';
      };
      #iittyd = pkgs.stdenv.mkDerivation rec {
      #  pname = "ttyd";
      #  version = "2.7.3";
      #  src = pkgs.fetchFromGitHub {
      #  owner = "ii";
      #  repo = pname;
      #  rev = "e27e67a49ea3071ec0fa8cad55202749b5d452fc";
      #  sha256 = "sha256-T5Tx+2R294Ri4vauMndctAwvla3th+tt+wDUeFu2zZI=";
      #};

      #nativeBuildInputs = with pkgs; [ pkg-config cmake xxd ];
      #buildInputs = with pkgs; [ openssl libwebsockets json_c libuv zlib ];
    
      #outputs = [ "out" "man" ];
    
      #meta = {
      #  description = "Share your terminal over the web";
      #  homepage    = "https://github.com/tsl0922/ttyd";
      #  license     = nixpkgs.lib.licenses.mit;
      #  maintainers = [ nixpkgs.lib.maintainers.thoughtpolice ];
      #  platforms   = nixpkgs.lib.platforms.all;
      #};
      #};
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
            services.getty.autologinUser = "root";
            programs.bash.interactiveShellInit = ''
              ${iimatey.outPath}/bin/iimatey start
            '';
            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxrp79vrta/Ye4uRsESi5q3SjjpOzlHV1CdowdZaz/LguDcoMsgDzods5swl123EiqpxTd0Re/E1Rby5XccKm+5bJNQTyOJvpL5shm7You99kdb/K2W8n0+8DymP2ws/bnAklRLt8vmj6EZ6VFnQDvoCCJgORoK46ZEeW1EiM9EcP5l+wmjaYytEdsoGBFsuuOBAJ7baXGMqFvYSfZ8j76Vdp/FxFoLEHNKOVCtaLr0j3octDFxfaPX3gt65exZuaA4NE6xZ3uwjrccaQL3nrTrAqWBzcDS9SfmmnTWcN5AcgrXHqc9yRpz7MbWWiP60DAiboTuBxg4sdvO89WKSNNztZfpON+XvvwMDvBuUuwpn4fEziunoaotkzPAwKY1GVzU+RANvQD9l7zBUd/haPrK7NgAn7FkPLiov0MAJgvCt80AgrZHh4VsM3scNkLhhMzLx5bA6gbo4UuSTZxZSg9lzy1wtQ+TnZDHAAVpl8bT4dEGEsYK3ue3fCyqIGofUM= root@nix-sharing-io"
             ] ;
            # networking.firewall.allowedTCPPorts = [ 22 ]; 
            services.openssh.enable=true;
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
            environment.systemPackages = [
              wgtunnel
              pkgs.ttyd
              pkgs.vim
              # iittyd
              iimatey
              pkgs.tmux
              pkgs.wireguard-tools
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

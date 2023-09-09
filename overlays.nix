{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      iimatey = final.stdenv.mkDerivation {
        name = "iimatey";
        # TODO: use git patches
        src = ./.;
        buildInputs = [ final.ttyd ]  ;
        installPhase = ''
          mkdir -p $out/bin
          cp $src/iimatey $out/bin
        '';
      };
      wgtunnel = final.buildGoModule {
        pname = "wgtunnel";
        version = "0.1.2";
        src = final.fetchFromGitHub {
          owner = "ii";
          repo = "wgtunnel";
          rev = "b578e62cbabd20b82e408dd4bfdc5b56cc252328";
          sha256 = "sha256-+V4l385Ks9VSxVT5tFDfenEoScEt8/VcUFlJb9I0Pjw=";
        };
        vendorHash = "sha256-ZC1LJW7UbgJITXG/0uGlaw1p+DvEQA0cCKwz8bLbAxw=";
      };
      ttyd = prev.ttyd.overrideAttrs {
        src = prev.fetchFromGitHub {
          owner = "ii";
          repo = "ttyd";
          rev = "936c048686b4c300860d78311f0efb46d41997be";
          sha256 = "sha256-BU30ClHTVcBzaDYVKBmOtDO2XHY3bEzHIzE/YEYmljU=";
        };
      };
    })
  ];
}

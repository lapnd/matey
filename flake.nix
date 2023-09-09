{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
  };

  outputs = { self, nixpkgs }: {

    nixpkgs.overlays = [
      (final: prev: {
        ttyd = prev.ttyd.overrideAttrs {
          src = builtins.fetchGit  {
            url = "https://github.com/ii/ttyd.git";
            rev = "936c048686b4c300860d78311f0efb46d41997be";
            sha256 = "";
          };
        };
      })
    ];

  };
}

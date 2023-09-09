{ config, lib, pkgs, ... }:

{
  services.getty.autologinUser = "root";
  programs.bash.interactiveShellInit = ''
    ${pkgs.iimatey.outPath}/bin/iimatey start
  '';
  environment.systemPackages = with pkgs; [
    wgtunnel
    iimatey
    ttyd
    vim
    tmux
    wireguard-tools
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxrp79vrta/Ye4uRsESi5q3SjjpOzlHV1CdowdZaz/LguDcoMsgDzods5swl123EiqpxTd0Re/E1Rby5XccKm+5bJNQTyOJvpL5shm7You99kdb/K2W8n0+8DymP2ws/bnAklRLt8vmj6EZ6VFnQDvoCCJgORoK46ZEeW1EiM9EcP5l+wmjaYytEdsoGBFsuuOBAJ7baXGMqFvYSfZ8j76Vdp/FxFoLEHNKOVCtaLr0j3octDFxfaPX3gt65exZuaA4NE6xZ3uwjrccaQL3nrTrAqWBzcDS9SfmmnTWcN5AcgrXHqc9yRpz7MbWWiP60DAiboTuBxg4sdvO89WKSNNztZfpON+XvvwMDvBuUuwpn4fEziunoaotkzPAwKY1GVzU+RANvQD9l7zBUd/haPrK7NgAn7FkPLiov0MAJgvCt80AgrZHh4VsM3scNkLhhMzLx5bA6gbo4UuSTZxZSg9lzy1wtQ+TnZDHAAVpl8bT4dEGEsYK3ue3fCyqIGofUM= root@nix-sharing-io"
  ] ;
  services.openssh.enable=true;
}

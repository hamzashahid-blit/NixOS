{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "adi1090x-plymouth";
  version = "0.0.1";

  src = builtins.fetchGit {
    url = "https://github.com/adi1090x/plymouth-themes";
  };

  buildInputs = with pkgs; [
    git
  ];

  configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
  '';

  buildPhase = ''
  '';

  installPhase = ''
    cp -r pack_3/lone pack_3/loader $out/share/plymouth/themes
    cat pack_3/lone/lone.plymouth | sed "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/lone/lone.plymouth
    cat pack_3/loader/loader.plymouth | sed "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/loader/loader.plymouth
  '';
}

{ pkgs ? import <nixpkgs> {} }:
let
  version = "0.8.11";
  pname = "pokewilds";
  unpacked-zip = pkgs.fetchzip {
    url = "https://github.com/SheerSt/pokewilds/releases/download/v${version}/pokewilds-linux64.zip";
    hash = "sha256-WFBxBmyldFuQxcwkqvsynNz4T61XF1TJI4jnRsGlwUA=";
  };
in
pkgs.appimageTools.wrapType2 {
  inherit version pname;
  src = "${unpacked-zip}/PokeWilds-x64";
}


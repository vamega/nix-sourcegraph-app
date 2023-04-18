 {
   stdenv,
   lib,
   fetchzip,
   autoPatchelfHook,
 }:
 stdenv.mkDerivation rec {
   pname = "sourcegraph-app";
   version = "2023.03.27+210185.ae7f7";

   src = let
     sources = rec {
       x86_64-linux = fetchzip {
         url = "https://storage.googleapis.com/sourcegraph-app-releases/2023.03.27+210185.ae7f75/sourcegraph_2023.03.27+210185.ae7f75_linux_amd64.zip";
         hash = "sha256-D+T9VRWCsccittmTljHcID0xy/gUmlKPz6qAsVZbjng=";
       };
       x86_64-darwin = fetchzip {
         url = "https://storage.googleapis.com/sourcegraph-app-releases/2023.03.23+209542.7216ba/sourcegraph_2023.03.23+209542.7216ba_darwin_all.zip";
         hash = "sha256-KbPQ3msMdqUmj9xFQ1OJHmTWrsX9ITfQo9CzAyz/zr8";
       };
       aarch64-darwin = x86_64-darwin;
     };
   in
     sources.${stdenv.hostPlatform.system};

   nativeBuildInputs = lib.optionals (!stdenv.isDarwin) [
     autoPatchelfHook
   ];

   buildInputs = [
     stdenv.cc.cc.lib
   ];

   installPhase = ''
     install -m755 -D sourcegraph $out/bin/sourcegraph
   '';

   meta = with lib; {
     homepage = "https://sourcegraph.com";
     description = "Sourcegraph App";
     platforms = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];
   };
 }

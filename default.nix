{ mkDerivation, base, fast-logger, heavy-logger, hpack
, monad-control, stdenv, text, text-format-heavy
}:
mkDerivation {
  pname = "heavy-log-shortcuts";
  version = "1.0.1";
  src = ./.;
  libraryHaskellDepends = [
    base fast-logger heavy-logger monad-control text text-format-heavy
  ];
  libraryToolDepends = [ hpack ];
  preConfigure = "hpack";
  homepage = "https://github.com/jappeace/template#readme";
  description = "Simle api for heavy logger";
  license = stdenv.lib.licenses.mit;
}

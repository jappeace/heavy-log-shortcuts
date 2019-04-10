{ mkDerivation, base, fast-logger, heavy-logger, hpack
, monad-control, stdenv, text, text-format-heavy
}:
mkDerivation {
  pname = "heavy-log-shortcuts";
  version = "1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base fast-logger heavy-logger monad-control text text-format-heavy
  ];
  libraryToolDepends = [ hpack ];
  preConfigure = "hpack";
  homepage = "https://github.com/jappeace/template#readme";
  license = stdenv.lib.licenses.mit;
}

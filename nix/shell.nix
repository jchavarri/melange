{ lib
, mkShell
, nodejs_latest
, packages
, system
, yarn
, cacert
, curl
, ocamlPackages
, git
, python3
, nodePackages
, release-mode ? false
}:

let
  derivations = lib.filterAttrs (_: value: lib.isDerivation value) packages;
  # outputs = dream2nix.makeFlakeOutputs {
  # systems = [ system ];
  # config.projectRoot = ../jscomp/build_tests/monorepo;
  # source = ../jscomp/build_tests/monorepo;
  # };
  # npmPackages = lib.trace "${builtins.toJSON( ( outputs))}" outputs.packages."${system}".monorepo;

in

mkShell {
  inputsFrom = lib.attrValues derivations;
  nativeBuildInputs = with ocamlPackages; [
    ocamlformat
    utop
    ocaml-lsp
    merlin
    python3
    nodejs_latest
    yarn
    nodePackages.mocha
  ] ++ lib.optionals release-mode ([
    cacert
    curl
    ocamlPackages.dune-release
    git
  ]);
  shellHook = ''
    PATH=$PWD/_build/install/default/bin:$PATH
  '';
}

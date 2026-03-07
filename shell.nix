{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.flutter
    pkgs.openjdk17
    pkgs.git
    pkgs.curl
    pkgs.unzip
  ];

  shellHook = ''
    export JAVA_HOME=${pkgs.openjdk17}
    export PATH=$JAVA_HOME/bin:$PATH
    echo "Java and Flutter are ready!"
  '';
}
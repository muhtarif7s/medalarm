{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [
    pkgs.unzip
    pkgs.gcc
    pkgs.clang
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    pkgs.gtk3
    pkgs.glib
    pkgs.cairo
    pkgs.pango
    pkgs.harfbuzz
    pkgs.gdk-pixbuf
    pkgs.atk
  ];

  env = {
    PKG_CONFIG_PATH =
      "${pkgs.gtk3.dev}/lib/pkgconfig:"
      + "${pkgs.glib.dev}/lib/pkgconfig:"
      + "${pkgs.cairo.dev}/lib/pkgconfig:"
      + "${pkgs.pango.dev}/lib/pkgconfig:"
      + "${pkgs.harfbuzz.dev}/lib/pkgconfig:"
      + "${pkgs.gdk-pixbuf.dev}/lib/pkgconfig:"
      + "${pkgs.atk.dev}/lib/pkgconfig";
  };

  idx = {
    extensions = [
      "Dart-Code.dart-code"
      "Dart-Code.flutter"
    ];

    workspace = {
      onCreate = {
        install-deps = "flutter pub get";
      };
    };

    previews = {
      enable = true;
      previews = {
        web = {
          command = [
            "flutter"
            "run"
            "--machine"
            "-d"
            "web-server"
            "--web-hostname"
            "0.0.0.0"
            "--web-port"
            "$PORT"
          ];
          manager = "flutter";
        };
      };
    };
  };
}

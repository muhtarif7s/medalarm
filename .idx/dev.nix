# To learn more about how to use Nix to configure your environment
# see: https://firebase.google.com/docs/studio/customize-workspace
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.flutter
    pkgs.unzip
    pkgs.rclone
    pkgs.cmake
  ];

  # Sets environment variables in the workspace
  env = {};

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "dart-code.dart-code"
      "dart-code.flutter"
    ];

    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        install-dependencies = "flutter pub get";
      };
      # To run something each time the workspace is (re)started, use the `onStart` hook
      onStart = {
        run-app = "flutter run --machine -d web-server --web-hostname 0.0.0.0 --web-port $PORT";
      };
    };

    # Enable previews and customize configuration
    previews = [
      {
        id = "flutter";
        command = [
          "flutter"
          "run"
          "-d"
          "web-server"
          "--web-hostname"
          "0.0.0.0"
          "--web-port"
          "$PORT"
        ];
        manager = "flutter";
      }
    ];
  };
}
{ pkgs, ... }: {
channel = "stable-23.11";

packages = [
pkgs.unzip
];

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
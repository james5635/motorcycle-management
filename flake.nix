{
  description = "Flutter 3.13.x";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };

        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ "34.0.0" "28.0.3" "36.0.0"];
          # platformVersions   = [ "34" "28" ];
          platformVersions   = [ "36" ];
          abiVersions        = [ "x86_64" ];

          includeEmulator    = true;
          includeSystemImages = true;

          systemImageTypes = [ "google_apis_playstore" ];
        };

        androidSdk = androidComposition.androidsdk;

      in {
        devShell = pkgs.mkShell {
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          ANDROID_HOME     = "${androidSdk}/libexec/android-sdk";

          buildInputs = with pkgs; [
            flutter
            androidSdk
            jdk17
          ];

          shellHook = ''
            export PATH=$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$PATH
          '';
        };
      });
}

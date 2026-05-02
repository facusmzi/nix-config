{ pkgs ? import <nixpkgs> {} }:

let
  vencord-custom = pkgs.stdenv.mkDerivation rec {
    pname = "vencord";
    version = "1.14.1-fork";

    src = pkgs.fetchFromGitHub {
      owner = "facusmzi";
      repo = "Vencord";
      rev = "master";
      hash = "sha256-+8c+npMlT68oszmYGgUKDK2J7rqiSVsSfd3QAJ9rmsw=";  # ← Reemplazá esto con el hash que te dé nix-build
    };

    patches = [ ./fix-deps.patch ];

    postPatch = ''
      substituteInPlace packages/vencord-types/package.json \
        --replace-fail '"@types/react": "18.3.1"' '"@types/react": "19.0.12"'
    '';

    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit pname src patches postPatch;
      pnpm = pkgs.pnpm_10;
      fetcherVersion = 2;
      hash = "sha256-K9rjPsODn56kM2k5KZHxY99n8fKvWbRbxuxFpYVXYks=";
    };

    nativeBuildInputs = with pkgs; [
      git
      nodejs
      pnpmConfigHook
      pnpm_10
    ];

    env = {
      VENCORD_REMOTE = "facusmzi/Vencord";
      VENCORD_HASH = version;
    };

    buildPhase = ''
      runHook preBuild
      pnpm run build -- --standalone --disable-updater
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist/ $out
      cp package.json $out
      runHook postInstall
    '';
  };

in
  pkgs.discord.override {
    withVencord = true;
    vencord = vencord-custom;
  }

{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, makeWrapper
, writeScript
, webkitgtk_4_1
, gtk3
, cairo
, gdk-pixbuf
, glib
, gsettings-desktop-schemas
, dbus
, openssl
, librsvg
, libsoup_3
, alsa-lib
, nspr
, nss
, cups
, libdrm
, mesa
, expat
, libxkbcommon
, xorg
}:

stdenv.mkDerivation rec {
  pname = "yaak";
  version = "2025.9.1";

  src = fetchurl {
    url = "https://github.com/mountain-loop/yaak/releases/download/v${version}/yaak_${version}_amd64.deb";
    hash = "sha256-kiEfLVk66c/zI2VtvULw2BxqJZ6SKWs6q66l3gg25t0=";
  };

  passthru.updateScript = writeScript "update-yaak" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    set -euo pipefail

    # Obtener la última versión desde GitHub releases
    latestVersion=$(curl --fail --silent https://api.github.com/repos/mountain-loop/yaak/releases/latest | jq --raw-output .tag_name | sed 's/^v//')

    # Verificar si ya está actualizado
    if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then
      echo "Already at latest version $latestVersion"
      exit 0
    fi

    echo "Updating from $UPDATE_NIX_OLD_VERSION to $latestVersion"

    # Actualizar la versión y hash automáticamente
    update-source-version yaak "$latestVersion"
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    cairo
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    dbus
    openssl
    librsvg
    libsoup_3
    alsa-lib
    nspr
    nss
    cups
    libdrm
    mesa
    expat
    libxkbcommon
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share
    cp -r usr/bin/* $out/bin/
    cp -r usr/lib/* $out/lib/

    if [ -d usr/share ]; then
      cp -r usr/share/* $out/share/
    fi

    runHook postInstall
  '';

  postFixup = ''
    # Mover el binario original
    mv $out/bin/yaak-app $out/bin/.yaak-app-unwrapped

    # Crear wrapper con todas las variables necesarias para GTK
    makeWrapper $out/bin/.yaak-app-unwrapped $out/bin/yaak-app \
      --set GDK_PIXBUF_MODULE_FILE "${gdk-pixbuf.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [ gtk3 gdk-pixbuf librsvg ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}:${glib.getSchemaDataDirPath gsettings-desktop-schemas}" \
      --set GSETTINGS_SCHEMA_DIR "${glib.getSchemaDataDirPath gsettings-desktop-schemas}" \
      --prefix GTK_PATH : "${gtk3}/lib/gtk-3.0" \
      --set GTK_EXE_PREFIX "${gtk3}" \
      --set GTK_DATA_PREFIX "${gtk3}"

    # Symlink principal
    ln -sf $out/bin/yaak-app $out/bin/yaak
  '';

  meta = with lib; {
    description = "Desktop API client for REST, GraphQL, WebSocket, SSE, and gRPC";
    longDescription = ''
      Yaak is a fast, privacy-first API client built with Tauri, Rust, and React.
      It supports REST, GraphQL, WebSocket, Server-Sent Events, and gRPC requests.
      Features include workspace organization, environment variables, OAuth 2.0,
      and a plugin system.
    '';
    homepage = "https://yaak.app";
    downloadPage = "https://yaak.app/download";
    changelog = "https://github.com/mountain-loop/yaak/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ]; # Agregar tu nombre aquí si vas a mantenerlo
    platforms = [ "x86_64-linux" ];
    mainProgram = "yaak";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

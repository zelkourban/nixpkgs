{ lib
, stdenv
, fetchFromGitHub
, cmake
, asciidoc
, pkg-config
, boost179
, cmark
, coeurl
, curl
, libevent
, libsecret
, lmdb
, lmdbxx
, mtxclient
, nlohmann_json
, olm
, qtbase
, qtgraphicaleffects
, qtimageformats
, qtkeychain
, qtmacextras
, qtmultimedia
, qtquickcontrols2
, qttools
, re2
, spdlog
, wrapQtAppsHook
, voipSupport ? true
, gst_all_1
, libnice
}:

stdenv.mkDerivation rec {
  pname = "nheko";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    rev = "v${version}";
    hash = "sha256-2daXxTbpSUlig47y901JOkWRxbZGH4qrvNMepJbvS3o=";
  };

  nativeBuildInputs = [
    asciidoc
    cmake
    lmdbxx
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    boost179
    cmark
    coeurl
    curl
    libevent
    libsecret
    lmdb
    mtxclient
    nlohmann_json
    olm
    qtbase
    qtgraphicaleffects
    qtimageformats
    qtkeychain
    qtmultimedia
    qtquickcontrols2
    qttools
    re2
    spdlog
  ] ++ lib.optional stdenv.isDarwin qtmacextras
  ++ lib.optionals voipSupport (with gst_all_1; [
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override { qt5Support = true; })
    gst-plugins-bad
    libnice
  ]);

  cmakeFlags = [
    "-DCOMPILE_QML=ON" # see https://github.com/Nheko-Reborn/nheko/issues/389
  ];

  preFixup = lib.optionalString voipSupport ''
    # add gstreamer plugins path to the wrapper
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Desktop client for the Matrix protocol";
    homepage = "https://github.com/Nheko-Reborn/nheko";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ekleog fpletz ];
    platforms = platforms.all;
    # Should be fixable if a higher clang version is used, see:
    # https://github.com/NixOS/nixpkgs/pull/85922#issuecomment-619287177
    broken = stdenv.hostPlatform.isDarwin;
  };
}

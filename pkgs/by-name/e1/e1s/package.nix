{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "e1s";
  version = "1.0.34";

  src = fetchFromGitHub {
    owner = "keidarcy";
    repo = "e1s";
    rev = "v${version}";
    hash = "sha256-fxo7TQjFrp2BbXz7bwMC5AuacKpyi5UmAMEVBmR91ko=";
  };


  #vendorHash = "sha256-fxo7TQjFrp2BbXz7bwMC5AuacKpyi5UmAMEVBmR91ko=";
  vendorHash = "sha256-pM6win2W6HqjIg9QBblDl3ptKEI6sANliXkpwlFnTb0=";

  meta = with lib; {
    description = "Easily Manage AWS ECS Resources in Terminal 🐱";
    homepage = "https://github.com/keidarcy/e1s";
    changelog = "https://github.com/derailed/e1s/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "e1s";
    maintainers = with maintainers; [ keidarcy mdb ezafeire ];
  };
}

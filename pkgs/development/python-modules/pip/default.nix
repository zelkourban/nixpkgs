{ lib
, python
, buildPythonPackage
, bootstrapped-pip
, fetchPypi
, mock
, scripttest
, virtualenv
, pretend
, pytest
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pip";
  version = "19.3.1";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21207d76c1031e517668898a6b46a9fb1501c7a4710ef5dfd6a40ad9e6757ea7";
  };

  nativeBuildInputs = [ bootstrapped-pip ];

  # pip detects that we already have bootstrapped_pip "installed", so we need
  # to force it a little.
  pipInstallFlags = [ "--ignore-installed" ];

  checkInputs = [ mock scripttest virtualenv pretend pytest ];
  # Pip wants pytest, but tests are not distributed
  doCheck = false;

  meta = {
    description = "The PyPA recommended tool for installing Python packages";
    license = lib.licenses.mit;
    homepage = https://pip.pypa.io/;
    priority = 10;
  };
}

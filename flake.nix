{
  description = "Python project with uv template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {self, ...}:
    with inputs;
      flake-utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs {
          inherit system;
          overlay = [];
        };
        caelestia-cli = pkgs.python3Packages.buildPythonPackage {
          pname = "caelestia";
          version = "1.0";
          format = "pyproject";
          src = ./.;
          propagatedBuildInputs = with pkgs; [
            python3Packages.pillow
            python3Packages.materialyoucolor
          ];
          nativeBuildInputs = with pkgs; [
            python3Packages.hatchling
            python3Packages.hatch-vcs
          ];
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [uv sass];
          shellHook = ''
            uv sync && source .venv/bin/activate
          '';
        };
        packages = {
          default = caelestia-cli;
          caelestia-cli = caelestia-cli;
        };
      });
}

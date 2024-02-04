{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      nativeBuildInputs = with pkgs; [
        meson
        ninja
        pkg-config
        python3
        python3.pkgs.pyelftools
      ];
      buildInputs = with pkgs; [
        libelf
        libpcap
        zlib
        python3
      ];
      dpdk = pkgs.stdenv.mkDerivation {
        name = "dpkg";
        src = ./.;
        mesonFlags = [
          "-Dmax_numa_nodes=1"
        ];
        inherit buildInputs nativeBuildInputs;
      };
    in {
      defaultPackage = dpdk;
      devShell = pkgs.mkShell {
        buildInputs = buildInputs ++ [ pkgs.tshark ];
        inherit nativeBuildInputs;
        shellHook = ''
          export TMPDIR="/var/tmp";
        '';
      };
    }
  );
}

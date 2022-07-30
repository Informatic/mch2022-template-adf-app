{ sources ? import nix/sources.nix }:
let
  pkgs = import sources.nixpkgs {
    overlays = [
      (import "${sources.nixpkgs-esp-dev}/overlay.nix")
    ];
  };

in pkgs.mkShell {
  name = "esp-idf";

  buildInputs = with pkgs; [
    gcc-xtensa-esp32-elf-bin
    openocd-esp32-bin
    esp-idf
    esptool

    # Tools required to use ESP-IDF.
    git
    wget
    gnumake

    flex
    bison
    gperf
    pkgconfig

    cmake
    ninja

    ncurses5

    # Required by tools/
    (python3.withPackages (ps: [ ps.pyusb ]))
  ];
}

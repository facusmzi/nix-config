{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    cargo-watch
    cargo-expand
    cargo-edit
    cargo-nextest
  ];

  environment.variables = {
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
    RUST_BACKTRACE = "1";
  };
}

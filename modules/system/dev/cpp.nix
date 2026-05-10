{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Compiladores
    gcc
    clang

    # Build systems
    cmake
    ninja
    meson
    pkg-config
    gnumake

    # LSP + herramientas de análisis (clangd, clang-format, clang-tidy)
    clang-tools

    # Debugger — lldb-dap es el adaptador DAP que usa tu config de Emacs
    lldb

    # Generación de compile_commands.json (necesario para clangd en proyectos CMake)
    bear

    # Profiling / análisis
    valgrind
    gdb
  ];

  environment.variables = {
    # Hint para que clangd encuentre las cabeceras de sistema de gcc
    # (útil cuando el compilador activo es clang pero el stdlib es libstdc++)
    CPLUS_INCLUDE_PATH = "${pkgs.gcc}/include/c++/${pkgs.gcc.version}";
  };
}

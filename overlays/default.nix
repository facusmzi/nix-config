final: prev: {
  # Importar paquetes personalizados
  yaak = prev.callPackage ./yaak/default.nix {};
  vencord-plugins-third = prev.callPackage ./vencord-plugins-third/default.nix {}; # es vencord solo con un plugin de terceros que es vc-message-logger-enhanced

  # Aquí podés agregar más paquetes en el futuro:
  # mi-otro-paquete = prev.callPackage ./mi-otro-paquete/default.nix {};
}

{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;  # solo KVM, sin emuladores extra innecesarios
      runAsRoot = true;
      swtpm.enable = true;      # TPM virtual (necesario para Windows 11)
      # ovmf ya viene incluido con qemu_kvm por defecto en nixos-25.11
      vhostUserPackages = with pkgs; [ virtiofsd ]; # carpetas compartidas host↔guest
    };
  };

  programs.virt-manager.enable = true;

  # dnsmasq: DNS y DHCP para la red virtual default de libvirt
  environment.systemPackages = with pkgs; [
    dnsmasq
    virt-viewer  # cliente SPICE/VNC ligero, alternativa a la ventana integrada
  ];

  # Permitir tráfico de la interfaz virtual de libvirt
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  users.users.facusmzi.extraGroups = [ "libvirtd" ];
}

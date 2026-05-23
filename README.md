# NixOS Config

---

## Instalación desde cero con Disko

### Requisitos previos

- USB con NixOS live (graphical o minimal)
- Conexión a internet

---

### 1. Bootear el live y conectarse a internet

```bash
# Wifi
nmtui

# Verificar conectividad
ping -c 2 nixos.org
```

---

### 2. Identificar el disco

```bash
ls -l /dev/disk/by-id/
```

Buscá el disco destino (sin `-part1`, `-part2`, el disco entero).
Editá `disko.nix` y reemplazá el campo `device`:

```nix
device = "/dev/disk/by-id/nvme-TU-ID-AQUI";
```

> **Atención:** disko borra TODO lo que haya en ese disco.

---

### 3. Formatear y montar con disko

```bash
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode destroy,format,mount \
  ~/disko.nix
```

Escribí `yes` cuando lo pida. Al terminar todo queda montado en `/mnt`.

Verificá:
```bash
lsblk
mount | grep /mnt
```

---

### 4. Clonar la config en /mnt

```bash
nix-shell -p git

sudo git clone https://github.com/facusmzi/nix-config.git /mnt/etc/nixos/nix-config
```

---

### 5. Generar hardware-configuration

```bash
sudo nixos-generate-config --no-filesystems --root /mnt
```

Copiarlo al repo:

```bash
sudo cp /mnt/etc/nixos/hardware-configuration.nix \
  /mnt/etc/nixos/nix-config/hosts/NOMBRE_HOST/hardware-configuration.nix
```

Editarlo para agregar los `fileSystems`:

```bash
sudo nano /mnt/etc/nixos/nix-config/hosts/NOMBRE_HOST/hardware-configuration.nix
```

Contenido final (los módulos del kernel los dejás como los generó, solo agregás lo de abajo):

```nix
{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Módulos generados automáticamente — no tocar
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];   # o kvm-intel según la CPU
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@var" "compress=zstd" "noatime" ];
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@tmp" "compress=zstd" "noatime" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" "compress=zstd" "noatime" ];
  };

  fileSystems."/var/lib/libvirt" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@vm" "noatime" "nodatacow" ];
  };

  fileSystems."/var/lib/containers" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@containers" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/disk-main-EFI";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-partlabel/disk-main-swap"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # Para Intel reemplazar por:
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
```

---

### 6. Instalar

```bash
sudo nixos-install --flake /mnt/etc/nixos/nix-config#NOMBRE_HOST --root /mnt
```

Te va a pedir contraseña de root al final.

---

### 7. Setear contraseña del usuario

`nixos-install` solo setea la contraseña de root. Antes de reiniciar:

```bash
sudo nixos-enter --root /mnt
passwd facusmzi
exit
```

---

### 8. Reiniciar

```bash
sudo reboot
```

Si aparece un diálogo de GNOME pidiendo contraseña o dice "operation inhibited":

```bash
sudo systemctl reboot --force
```

---

### disko.nix

Guardalo en `hosts/NOMBRE_HOST/disko.nix`. Recordá reemplazar el `device` con el ID real del disco antes de correrlo.

```nix
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-REEMPLAZAR";
        content = {
          type = "gpt";
          partitions = {
            EFI = {
              name = "EFI";
              size = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              name = "swap";
              size = "16G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              name = "nixos";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-L" "nixos" ];
                subvolumes = {
                  "@root"       = { mountpoint = "/";                   mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@home"       = { mountpoint = "/home";               mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@nix"        = { mountpoint = "/nix";                mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@var"        = { mountpoint = "/var";                mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@tmp"        = { mountpoint = "/tmp";                mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@snapshots"  = { mountpoint = "/.snapshots";         mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@vm"         = { mountpoint = "/var/lib/libvirt";    mountOptions = [ "noatime" "nodatacow" ]; };
                  "@containers" = { mountpoint = "/var/lib/containers"; mountOptions = [ "compress=zstd" "noatime" ]; };
                };
              };
            };
          };
        };
      };
    };
  };
}
```

---

## Post-instalación (primer boot)

### 1. Clonar el repo

```bash
nix-shell -p git
git clone git@github.com:facusmzi/nix-config.git ~/nix-config
cd ~/nix-config
```

---

### 2. Copiar hardware-configuration y primer rebuild

```bash
cp /etc/nixos/hardware-configuration.nix ~/nix-config/hosts/NOMBRE_HOST/hardware-configuration.nix
git add hosts/NOMBRE_HOST/hardware-configuration.nix
git commit -m "feat: hardware-configuration NOMBRE_HOST"
git push

sudo nixos-rebuild switch --flake ~/nix-config#NOMBRE_HOST
```

---

### 3. Configurar sops

```bash
mkdir -p ~/.config/sops/age
sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt

# Obtener la clave pública (necesaria para agregar este host a .sops.yaml)
sudo ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
```

Luego, desde una máquina que ya tenga acceso a los secretos:
1. Agregar la clave pública al `.sops.yaml`
2. Correr `sops updatekeys ~/nix-config/secrets/common.yaml`
3. Commitear y pushear

Hacer pull en la máquina nueva y rebuild de nuevo.

---

### 4. Generar claves SSH

```bash
ssh-keygen -t ed25519 -f ~/.ssh/key1 -C "cuenta1"
ssh-keygen -t ed25519 -f ~/.ssh/key2 -C "cuenta2"
```

---

### 5. Agregar claves a GitHub

**Cuenta principal:**
```bash
cat ~/.ssh/key1.pub
```
1. Ir a https://github.com/settings/keys
2. Click "New SSH key" → pegar la clave → "Add SSH key"

**Cuenta secundaria:**
```bash
cat ~/.ssh/key2.pub
```
1. Iniciar sesión con la cuenta secundaria
2. Ir a https://github.com/settings/keys
3. Click "New SSH key" → pegar la clave → "Add SSH key"

---

### 6. Probar conexión SSH

```bash
ssh -T git@github.com
ssh -T git@github.com-work
```

---

### 7. Repos de la cuenta secundaria

```bash
mkdir -p ~/work
cd ~/work
git clone git@github.com-work:usuario2/repo.git
```

---

### Editor para sops

```bash
EDITOR="kate --block" sops ~/nix-config/secrets/common.yaml
```

---

## Reinstalar en una máquina existente (clave sops perdida)

Cuando reinstalás NixOS en una máquina que ya estaba en el repo, la clave host SSH cambia y sops ya no puede abrir los secretos anteriores. El archivo encriptado con la clave vieja es irrecuperable — hay que recrearlo.

**1. Primer rebuild** (va a fallar home-manager pero está bien por ahora):
```bash
sudo nixos-rebuild switch --flake ~/nix-config#NOMBRE_HOST
```

**2. Generar la nueva clave age:**
```bash
mkdir -p ~/.config/sops/age
sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
sudo ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
```

**3. Actualizar `.sops.yaml`** con la nueva clave pública:
```yaml
keys:
  - &nily  age1NUEVA_CLAVE_AQUI
```

**4. Borrar el secreto viejo y recrearlo:**
```bash
rm ~/nix-config/secrets/common.yaml
EDITOR="kate --block" sops ~/nix-config/secrets/common.yaml
```

**5. Commitear y rebuild:**
```bash
git add -A
git commit -m "fix: actualizar clave sops NOMBRE_HOST"
git push
sudo nixos-rebuild switch --flake ~/nix-config#NOMBRE_HOST
```

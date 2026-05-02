# NixOS Config — Post-instalación

Pasos para tener todo funcionando después de instalar NixOS en una máquina nueva.

---

## 1. Clonar el repo

```bash
nix-shell -p git
git clone git@github.com:facusmzi/nix-config.git ~/nix-config
cd ~/nix-config
```

---

## 2. Primer rebuild

```bash
sudo nixos-rebuild switch --flake ~/nix-config#NOMBRE_HOST
```

Reemplazá `NOMBRE_HOST` con el host correspondiente (`nily`, `nixi`, etc.).

---

## 3. Configurar sops

```bash
# Generar la clave age local a partir de la clave host SSH
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

## 4. Generar claves SSH

```bash
# Clave principal (cuenta 1)
ssh-keygen -t ed25519 -f ~/.ssh/key1 -C "cuenta1"

# Clave secundaria (cuenta 2)
ssh-keygen -t ed25519 -f ~/.ssh/key2 -C "cuenta2"
```

---

## 5. Agregar claves a GitHub

**Cuenta principal:**
```bash
cat ~/.ssh/key1.pub
```
1. Ir a https://github.com/settings/keys
2. Click "New SSH key"
3. Pegar la clave pública
4. Click "Add SSH key"

**Cuenta secundaria:**
```bash
cat ~/.ssh/key2.pub
```
1. Cerrar sesión e iniciar con la cuenta secundaria
2. Ir a https://github.com/settings/keys
3. Click "New SSH key"
4. Pegar la clave pública
5. Click "Add SSH key"

---

## 6. Probar conexión SSH

```bash
# Cuenta principal
ssh -T git@github.com

# Cuenta secundaria (usa el host alias definido en ssh.nix)
ssh -T git@github.com-work
```

---

## 7. Repos de la cuenta secundaria

Los repos de la cuenta secundaria tienen que estar en `~/work/` para que git use automáticamente las credenciales correctas:

```bash
mkdir -p ~/work
cd ~/work
git clone git@github.com-work:usuario2/repo.git
```

---

## Editor para sops

```bash
EDITOR="kate --block" sops ~/nix-config/secrets/common.yaml
```

{ config, lib, pkgs, ... }:

let
  cfg = config.services.nixMonitor;

  monitorBin = pkgs.writeShellScriptBin "nix-monitor-daemon" ''
    set -euo pipefail
    LOG="${cfg.logFile}"

    log() {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
    }

    prev_system=$(readlink -f /run/current-system 2>/dev/null || echo "")

    log "=== nix-monitor iniciado ==="

    ${pkgs.inotify-tools}/bin/inotifywait -m -q \
      -e create -e moved_to \
      /nix/var/nix/profiles \
      --format '%f' 2>/dev/null | while read -r name; do

      case "$name" in

        # nixos-rebuild switch
        system)
          curr=$(readlink -f /run/current-system 2>/dev/null || echo "")
          if [[ -n "$curr" && "$curr" != "$prev_system" ]]; then
            log "--- nixos-rebuild switch ---"
            if [[ -n "$prev_system" ]]; then
              ${pkgs.nvd}/bin/nvd diff "$prev_system" "$curr" 2>/dev/null >> "$LOG" || true
            fi
            prev_system="$curr"
          fi
          ;;

        # nix profile install / home-manager
        profile|default)
          curr=$(readlink -f /nix/var/nix/profiles/per-user/${cfg.user}/profile 2>/dev/null || echo "")
          log "--- perfil de usuario actualizado: $curr ---"
          ;;

      esac
    done
  '';

  # Detecta nix-shell -p, nix run, nix build etc via gcroots
  gcMonitorBin = pkgs.writeShellScriptBin "nix-gcroot-monitor" ''
    set -euo pipefail
    LOG="${cfg.logFile}"

    log() {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
    }

    ${pkgs.inotify-tools}/bin/inotifywait -m -q \
      -e create -e delete \
      /nix/var/nix/gcroots/auto \
      --format '%e %f' 2>/dev/null | while read -r event name; do

      case "$event" in
        CREATE)
          target=$(readlink -f "/nix/var/nix/gcroots/auto/$name" 2>/dev/null || echo "?")
          log "--- nix-shell/run: nuevo gcroot → $target ---"
          ;;
        DELETE)
          log "--- nix-shell: gcroot eliminado: $name ---"
          ;;
      esac
    done
  '';

  # Detecta flake updates mirando flake.lock
  flakeMonitorBin = pkgs.writeShellScriptBin "nix-flake-monitor" ''
    set -euo pipefail
    LOG="${cfg.logFile}"
    FLAKE_DIR="${cfg.flakeDir}"

    log() {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
    }

    [[ -f "$FLAKE_DIR/flake.lock" ]] || exit 0

    ${pkgs.inotify-tools}/bin/inotifywait -m -q \
      -e close_write \
      "$FLAKE_DIR/flake.lock" \
      --format '%f' 2>/dev/null | while read -r _; do
      log "--- flake.lock actualizado (nix flake update) ---"
      ${pkgs.git}/bin/git -C "$FLAKE_DIR" diff flake.lock 2>/dev/null >> "$LOG" || true
    done
  '';

  # Comando para ver el log en vivo
  nixLogBin = pkgs.writeShellScriptBin "nix-log" ''
    case "''${1:-}" in
      --all)
        cat "${cfg.logFile}"
        ;;
      --clear)
        > "${cfg.logFile}"
        echo "Log limpiado."
        ;;
      *)
        tail -f "${cfg.logFile}"
        ;;
    esac
  '';

  # Comando manual para espiar una app
  watchAppBin = pkgs.writeShellScriptBin "watch-app" ''
    WATCH_DIR="''${1:-$HOME}"
    TMP=$(mktemp -d)
    LOG="$TMP/watch.log"

    echo ""
    echo "Monitoreando: $WATCH_DIR"
    echo "Abrí la app y presioná Ctrl+C cuando termines"
    echo ""

    ${pkgs.inotify-tools}/bin/inotifywait -r -m -q \
      --format '%T %e %w%f' \
      --timefmt '%H:%M:%S' \
      --exclude '(\.git|\.cache/thumbnails)' \
      "$WATCH_DIR" > "$LOG" 2>/dev/null &
    PID=$!

    cleanup() {
      kill "$PID" 2>/dev/null || true
      echo ""
      echo "======================================="
      echo "  CREADOS"
      echo "======================================="
      grep " CREATE " "$LOG" | grep -v "ISDIR" | awk '{print "  " $1 "  " $3}' || echo "  (ninguno)"
      echo ""
      echo "  CARPETAS CREADAS"
      grep "CREATE.*ISDIR" "$LOG" | awk '{print "  " $1 "  " $3}' || echo "  (ninguna)"
      echo ""
      echo "======================================="
      echo "  MODIFICADOS"
      echo "======================================="
      grep " MODIFY\| CLOSE_WRITE" "$LOG" | awk '{print "  " $1 "  " $3}' | sort -u || echo "  (ninguno)"
      echo ""
      echo "======================================="
      echo "  ELIMINADOS"
      echo "======================================="
      grep " DELETE " "$LOG" | awk '{print "  " $1 "  " $3}' || echo "  (ninguno)"
      echo ""
      echo "Log completo guardado en: $LOG"
    }

    trap cleanup INT TERM
    wait "$PID"
  '';

in
{
  options.services.nixMonitor = {
    enable = lib.mkEnableOption "Monitor automático de cambios de nix";

    user = lib.mkOption {
      type = lib.types.str;
      description = "Usuario principal del sistema";
      example = "facusmzi";
    };

    logFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/log/nix-changes.log";
      description = "Archivo donde se loguean los cambios";
    };

    flakeDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.services.nixMonitor.user}/nix-config";
      description = "Directorio de la flake config";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      watchAppBin
      nixLogBin
      pkgs.nvd
      pkgs.inotify-tools
    ];

    # Monitor principal: rebuilds y perfiles
    systemd.services.nix-monitor = {
      description = "Monitor de nixos-rebuild y perfiles nix";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${monitorBin}/bin/nix-monitor-daemon";
        Restart = "always";
        RestartSec = "3s";
        User = "root";
      };
    };

    # Monitor de nix-shell / nix run
    systemd.services.nix-gcroot-monitor = {
      description = "Monitor de nix-shell y nix run";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${gcMonitorBin}/bin/nix-gcroot-monitor";
        Restart = "always";
        RestartSec = "3s";
        User = "root";
      };
    };

    # Monitor de flake updates
    systemd.services.nix-flake-monitor = {
      description = "Monitor de flake.lock";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${flakeMonitorBin}/bin/nix-flake-monitor";
        Restart = "always";
        RestartSec = "3s";
        User = cfg.user;
      };
    };

    # Rotar el log para que no crezca indefinidamente
    services.logrotate.settings.nix-monitor = {
      files = cfg.logFile;
      frequency = "weekly";
      rotate = 4;
      compress = true;
      missingok = true;
      notifempty = true;
    };
  };
}

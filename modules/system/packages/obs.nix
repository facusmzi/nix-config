{ config, pkgs, lib, ... }:

let
  users = [ "facusmzi" ];
in
{
  # ─── Sistema ───────────────────────────────────────────────
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="OBS Virtual Camera" exclusive_caps=1 max_buffers=2
  '';

  programs.obs-studio.enableVirtualCamera = true;

  users.users.facusmzi.extraGroups = [ "video" ];

  # ─── Home Manager ──────────────────────────────────────────
  home-manager.users = lib.genAttrs users (_: {
    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
        droidcam-obs
      ];
    };
  });
}

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nix.registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 14d";

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.substituters = ["https://dawidd6.cachix.org"];
  nix.settings.trusted-public-keys = ["dawidd6.cachix.org-1:dvy2Br48mAee39Yit5P+jLLIUR3gOa1ts4w4DTJw+XQ="];
  nix.settings.trusted-users = ["@wheel" "root"];
  nix.settings.warn-dirty = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
  ];

  systemd.user.services.nix-gc-user = {
    inherit (config.systemd.services.nix-gc) description;
    inherit (config.systemd.services.nix-gc) script;
    inherit (config.systemd.services.nix-gc) startAt;
    after = ["nix-gc.service"];
  };

  systemd.user.timers.nix-gc-user = {
    inherit (config.systemd.timers.nix-gc) timerConfig;
    after = ["nix-gc.timer"];
  };

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      if [[ -e /run/current-system ]]; then
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
      fi
    '';
  };
}

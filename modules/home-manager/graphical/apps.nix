{pkgs, ...}: {
  home.packages = with pkgs; [
    filezilla
    gimp
    gnome.gnome-tweaks
    google-chrome
    gpick
    inkscape
    keepassxc
    pavucontrol
    spotify
    virt-manager
    vorta
    vscode
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [];
    };
    "org/virt-manager/virt-manager" = {
      system-tray = true;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
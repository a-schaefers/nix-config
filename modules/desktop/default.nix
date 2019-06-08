{ config, pkgs, lib, ... }:
with lib;
with import ../../util;
{
options.modules.desktop.enable = mkEnableOption "modules.desktop";
config = mkIf config.modules.desktop.enable {

# windows 10 dual-boot compat
time.hardwareClockInLocalTime = true;

# alsa
sound.enable = true;

# some basic fonts
fonts.fonts = with pkgs; [
dejavu_fonts
source-code-pro
noto-fonts
liberation_ttf
hack-font
fantasque-sans-mono
terminus_font
];

# components of my desktop setup
modules.desktop = enableMultiple [
"apps"
"dev"
"pulse"
"xorg"
"opengl"
"sddm"
"exwm"
];

};
}
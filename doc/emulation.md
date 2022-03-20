# RetroArch
https://www.retroarch.com/index.php?page=linux-instructions
```
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub org.libretro.RetroArch
flatpak update --user org.libretro.RetroArch
```
DON'T USE THE SOFTWARE STORE ON FEDORA 35. Retroarch installation is broken.
USE GNOME XORG, GNOME WAYLAND DOES NOT PLAY WITH RETROARCH
- Dolphin can't make save files under GNOME Wayland, but has no problem with GNOME Xorg (Pokemon XD)
- Windowing is messed up on GNOME Wayland (https://bleepcoder.com/retroarch/316630922/window-not-composited-on-gnome-wayland-flatpak)

## retrolib cores (for powerful x86 machines)
### Nintendo
- Gameboy: mGBA
- Gamecube: Dolphin
- NES: FCEUmm
- n64: Mupen64Plus-Next
- SNES: Snes9x Current
## Sony
- Playstation: Beetle PSX
- Playstation 2: PCSX2

## Troubleshooting
### PCSX2
- Retroarch doesn't recognize the PS2 ISO's, but will recognize the .7z compressed versions but crash when trying to play them.
https://www.reddit.com/r/RetroArch/comments/92ppqr/retroarch_not_recognizing_psx_games_crashing_on/
https://github.com/libretro/RetroArch/issues/4717
So it seems like retroarch does not play well with .7z files and also I need special PSX games with a `bin` dir

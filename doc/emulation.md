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

There are multiple ways to get a good font setup working for my terminal and gui apps. Here's one:

Download Noto Sans Mono Nerd Font from [here](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Noto/Sans-Mono/complete/Noto%20Sans%20Mono%20Regular%20Nerd%20Font%20Complete.ttf) or use a local copy.

Put it in `~/.local/share/fonts` and run `fc-cache -f` to rebuild the font cache.

Use `gnome-fonts` to look at it.

Make sure there is an entry in `~/.config/fontconfig/fonts.conf` to set the spacing to 100 or else it will render with wide gaps in Kitty.

```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
<match target="scan">
    <test name="family">
        <string>NotoSansMono Nerd Font</string>
    </test>
    <edit name="spacing">
        <int>100</int>
    </edit>
</match>
</fontconfig>
```

Now you can use the font family `NotoSansMono Nerd Font`.

The regular Noto Sans Mono fonts can be downloaded with `dnf install google-noto-sans-mono-fonts`

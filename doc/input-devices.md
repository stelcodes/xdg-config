# Keyboards
## For Fedora 35 and tty
```
sudo loadkeys <<< 'keycode 58 = Escape'
```
## For Fedora 35 and X11
```
dnf install setxkbmap
setxkbmap -option caps:escape
```

# Trackpads
## For Fedora 35 and X11
https://gist.github.com/111A5AB1/d353af199fd523d33f222850834f9cc5
```
dnf install xinput
xinput --list
```
My 2013 MacBook Air trackpad name is listed as `bcm5974	id=11	[slave  pointer  (2)]`
```
xinput --list-props 11
```
Option we'd like to set is `libinput Natural Scrolling Enabled (318):	0`
```
xinput --set-prop 11 318 1
```

# General Settings
Uncheck "Delete cookies and site data when Firefox is closed"

# userContent.css
- Change the css of any website
- Find profile directory by `Menu->Help->More Troubleshooting Information->Profile Directory`
- Create new dir called `chrome`
- Symlink with `ln -s ~/.config/files/userContent.css ~/.mozilla/firefox/<profile-dir>/chrome/userContent.css`

# about:config
`browser.chrome.toolbar_tips = false`
Smaller tab bar:
`browser.uidensity = 1`
For userContent.css support:
`toolkit.legacyUserProfileCustomizations.stylesheets = true`
Make tabs visible in fullscreen:
`browser.fullscreen.autohide = false`

# Extensions
## TabSessionManager
https://addons.mozilla.org/en-US/firefox/addon/tab-session-manager
- Settings found in files/tab-session-manager-settings.json
## Vimium C
https://addons.mozilla.org/en-US/firefox/addon/vimium-c/
```
map H previousTab
map L nextTab
map J goBack
map K goForward
unmap <a-c>
```
## Adguard
https://addons.mozilla.org/en-US/firefox/addon/adguard-adblocker/
## DarkReader
https://addons.mozilla.org/en-US/firefox/addon/darkreader
## Dracula Theme
https://addons.mozilla.org/en-US/firefox/addon/dracula-dark-colorscheme

# Random
Use this js to see what firefox sees your keycodes as:
```
data:text/html,<ul id="list"></ul><script>window.addEventListener("keydown", function (e) { var log = "keycode=" + e.keyCode + " (0x" + e.keyCode.toString(16).toUpperCase() + ")"; var textNode = document.createTextNode(log); var li = document.createElement("li"); li.insertBefore(textNode, null); var ul = document.getElementById("list"); ul.insertBefore(li, ul.firstChild); setTimeout(function () { ul.removeChild(li); }, 5000); }, true);</script>
```


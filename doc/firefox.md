# General Settings
Uncheck "Delete cookies and site data when Firefox is closed"

# userContent.css
- Change the css of any website
- Find profile directory by `Menu->Help->More Troubleshooting Information->Profile Directory`
- Create new dir called `chrome`
- Symlink with `ln -s ~/.config/files/userContent.css ~/.mozilla/firefox/<profile-dir>/chrome/userContent.css`

# about:config
```
browser.uidensity = 1
# For userChrome support
toolkit.legacyUserProfileCustomizations.stylesheets = true
browser.chrome.toolbar_tips = false
```
# Extensions
## TabSessionManager
- Tab Session Manager
  - Settings found in files/tab-session-manager-settings.json
- Vimium C
```
map H previousTab
map L nextTab
map J goBack
map K goForward
unmap <a-c>
```
- Adguard
- DarkReader

# Random
Use this js to see what firefox sees your keycodes as:
```
data:text/html,<ul id="list"></ul><script>window.addEventListener("keydown", function (e) { var log = "keycode=" + e.keyCode + " (0x" + e.keyCode.toString(16).toUpperCase() + ")"; var textNode = document.createTextNode(log); var li = document.createElement("li"); li.insertBefore(textNode, null); var ul = document.getElementById("list"); ul.insertBefore(li, ul.firstChild); setTimeout(function () { ul.removeChild(li); }, 5000); }, true);</script>
```


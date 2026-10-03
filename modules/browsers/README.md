# Resources for userChrome and userContent

## userChrome.css

Styles the browser's own UI ("chrome"):tabs, the address bar, context menus, sidebar, bookmarks bar, etc. This is where most "ricing" happens (vertical tabs, hidden buttons, compact urlbar, custom borders/colors).

## userContent.css

styles Firefox's internal pages: about:newtab, about:preferences, about:addons, error pages, view-source, PDF viewer, etc. Not regular websites — that would break the web and isn't what this file is for.

## How to

Prerequisites (both are disabled by default):

about:config → set toolkit.legacyUserProfileCustomizations.stylesheets to true. In your profile folder (about:support → Profile Folder), create a chrome/ directory. Put userChrome.css and/or userContent.css inside it, restart Firefox

### Where to actually learn/rice:

r/FirefoxCSS — the de facto hub; tons of finished snippets and screenshots you can dissect
userchrome.org — small but has the canonical "how it works" writeups and a snippet library
GitHub topic firefox-userchrome — full dotfiles-style repos (some tuned for tiling WMs, which given niri you'll find more relevant than the Windows-oriented ones)
Browser devtools trick: open about:preferences or the browser UI itself in the Browser Toolbox (needs devtools.chrome.enabled + devtools.debugger.remote-enabled in about:config, then Ctrl+Shift+Alt+I) — this lets you inspect Firefox's actual UI elements and IDs live, which is how most existing snippets were reverse-engineered in the first place. That's the real skill: less "copy tutorials," more "poke the chrome DOM yourself."

### Edit prefs.js using nix

`user.js`file is something that's read-only, since it's managed by home-manager in Nix. When making changes to Firefox using the UI options, copy the `prefs.js` file to a different place and then make the changes using the UI. Now we can diff the two files, see the changes made and write it in Nix. Also, the `programs.firefox.policies` is translated into `user.js` file. So if there's a policy setting that affects the `prefs.js`/`user.js` file, then prefer that over the settings options.

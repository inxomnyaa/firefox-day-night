# After Firefox updates

Firefox occasionally renames its internal CSS variables. Symptoms: some part goes back to grey/white.

- Check `about:support` → "Profile Folder" is the profile you installed into, and the pref
  `toolkit.legacyUserProfileCustomizations.stylesheets` is `true` in `about:config`.
- Find the current variable names for the browser UI. Firefox maps theme colors to CSS
  variables in `ThemeVariableMap.sys.mjs` and `LightweightThemeConsumer.sys.mjs`:
  ```
  F=/var/lib/flatpak/app/org.mozilla.firefox/current/active/files/lib/firefox
  mkdir -p /tmp/ffomni && cd /tmp/ffomni
  unzip -qo $F/browser/omni.ja 'modules/*Theme*' 'chrome/browser/skin/*' 2>/dev/null
  unzip -qo $F/omni.ja 'modules/*Theme*' 'chrome/toolkit/skin/*' 2>/dev/null
  grep -A2 '"--' modules/ThemeVariableMap.sys.mjs modules/LightweightThemeConsumer.sys.mjs
  ```
  Then rename the matching lines in the `:root:not([lwtheme])` block of `userChrome.css`.
- Live inspection: enable `devtools.chrome.enabled` + `devtools.debugger.remote-enabled`
  in about:config, open the Browser Toolbox (Ctrl+Alt+Shift+I), pick the grey element
  and look at which `var(--…)` its background uses.
- New tab page variables live in the newtab add-on CSS
  (`chrome/browser/builtin-addons/newtab/data/css/activity-stream.css` inside `browser/omni.ja`;
  look for `--newtab-` variables and `.top-site-outer .tile` / `.search-wrapper`).
  Note: Mozilla also pushes newer newtab versions directly into the profile
  (`extensions/newtab@mozilla.org.xpi`), so the page can change without a Firefox update.
- Newer Firefox UI pieces are web components (e.g. `moz-page-nav-button`, the about:addons /
  settings sidebar) that redefine their color variables on `:host`. Setting those variables on
  `:root` does nothing there; set them on the element itself (`moz-page-nav-button { --var: … }`).
  Token definitions: `chrome/toolkit/content/global/elements/*.tokens.css` inside `omni.ja`.
- Unrelated known glitch: if the new tab "customize" panel shows raw IDs like
  `newtab-wallpaper-category-title-…`, that's a newtab add-on newer than Firefox itself.
  It fixes itself when Firefox updates; it's not the theme.

## Why not a normal Firefox theme
Static themes can't switch with the system unless Mozilla signs them, and release
Firefox won't keep unsigned ones. The CSS approach on top of "System theme — auto" avoids that.

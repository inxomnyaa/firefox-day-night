# Firefox Day/Night

Firefox colors that follow your system's light/dark mode: purple at night, warm orange during the day. Covers the toolbar, tabs, menus, sidebar, new tab page and about: pages.

It's plain CSS (`userChrome.css` / `userContent.css`) on top of Firefox's built-in **System theme — auto**, so no add-on or signing is needed.

## Install

```sh
git clone https://github.com/inxomnyaa/firefox-day-night
firefox-day-night/install.sh
```

Then pick **System theme — auto** in `about:addons` → Themes and restart Firefox.

To change colors, edit the `--c-*` variables at the top of `userChrome.css` (night block first, then day) and the matching ones in `userContent.css`.

If a Firefox update turns something grey or white again, see [docs/after-updates.md](docs/after-updates.md).

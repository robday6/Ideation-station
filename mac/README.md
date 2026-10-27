# Ideate for Mac

A native Mac window around the Ideate web app. The page in `../index.html` is bundled into the app when you build, so the web version stays the single source and the Mac app picks up every change on the next build.

## Build and run

Needs Xcode (or its command line tools) and macOS 14 or later.

```
cd mac
./build.sh --install
open ~/Applications/Ideate.app
```

## What's native

- Its own window, Dock icon and menus (copy and paste, zoom with Cmd + and Cmd -, reload with Cmd R).
- Judge's "add screens" opens the Mac file picker; you can also drag files in from Finder.
- Web links open in your default browser.
- Saved sets, chats and decks are kept by the app between launches. They are separate from anything saved in a browser.
- Right-click > Inspect Element for debugging.

## Not yet

- **Claude features are off.** Generating decks, Talk and Judge show "needs Claude, which isn't available in this view". Wiring in an Anthropic API key (stored in the Keychain) is the next step when wanted.
- **Only runs on this Mac.** It is signed ad hoc. Sharing it needs an Apple Developer account to sign and notarise it.

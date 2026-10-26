# Agent brief: Ideate prototype

This folder is for the scheduled agent that works on the prototype overnight. Read this file first on every run.

## The job

Move `index.html` (the Ideation Station prototype, eight modes) towards **Ideate**, the new structure designed in Figma and documented in the claude.ai Project "Ideation-station" (`ideate/*.md`). One backlog item per run, small and working.

## Rules

1. **Work on the `agent/ideate` branch only.** Never commit to `main`, never merge, never force-push. Rob reviews the draft pull request and merges himself.
2. **One item per run.** Take the first unticked item in `BACKLOG.md`. If it is too big for one run, split it into smaller items in the backlog, do the first, and leave the rest.
3. **Keep it working.** Every commit must leave the page usable. Don't remove an existing feature until its replacement works. Keep existing `localStorage` keys readable so saved sets, chats and decks survive.
4. **Stay a single HTML file.** No build step, no frameworks, no new external dependencies beyond Google Fonts. The page must still work as a claude.ai artifact (`window.claude.use("sample")`).
5. **Follow the spec, don't invent product.** If the docs don't say how something should work, pick the simplest version and note the assumption in `LOG.md`. If an item depends on an open question (see `05-decisions-and-open-questions.md`), skip it and say why.
6. **Writing style for UI copy and notes:** UK English, plain language, no em dashes.
7. **Check before committing:** extract the scripts and run them through `node --check`; load the page in a headless browser if one is available and confirm there are no console errors; test the screen you changed.

## The target structure (summary)

Full detail lives in the Project docs: `01-product-structure.md`, `02-screens.md`, `04-design-language.md`, `08-blind-spots.md`, `11-design-system.md`. If the Projects tool is available, read the relevant one before starting an item.

- **Context** first: the brief is the first piece of context, shared by every part.
- **Home:** "What do you need right now?" with five doors.
- **Five parts in flow order:** Challenge (Provoke, Muse, Persona, Oracle, Blind spots), Talk it through (eight voices, Coach is now a voice), Edit your ideas (keep, maybe, cut, then "Craft the keepers"), Craft (Concept, Storyboard, Journey, Screen), Judge (six lenses: Brief fit, User, Craft, Business, Fairness, Thinking; severities Warm, Straight, Hard).
- **Your ideas** replaces history: everything saved, with its trail.
- **Design language:** near-black ground, greyscale UI, colour only for characters. Space Grotesk for UI, Space Mono for metadata, frog Serif for display where available (fall back to a serif). One thing at a time, type-led, one primary action per screen.

## Each run

1. `git fetch origin main agent/ideate` and check out `agent/ideate`. If `main` has moved, rebase onto it; if there are conflicts, stop and report.
2. Read `BACKLOG.md` and the latest entries in `LOG.md`.
3. Do the item. Check it (rule 7).
4. Tick it in `BACKLOG.md`, add an entry to the top of `LOG.md` (date, item, what changed, assumptions, anything Rob should look at).
5. Commit and push. Make sure a draft pull request from `agent/ideate` to `main` exists; update its description with the latest log entry.
6. Send a short summary (one or two lines) as the run's final message.

If the backlog is empty, don't make work up: say so and stop.

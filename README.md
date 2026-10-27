# Ideate

Ideate (previously Ideation Station) is a design ideation toolkit in a single HTML page. It helps designers broaden their thinking about a brief through eight modes:

- **Provoke**: eight provocateur stances across three tones, drawn as Oblique Strategies-style cards.
- **Talk**: an open conversation about the brief, in any of the other voices.
- **Coach**: GROW coaching questions (Goal, Reality, Options, Way forward) that build into a plan.
- **Muse**: references from other worlds, from near to far.
- **Persona**: hear from the people affected by the work.
- **Edit**: sort your ideas into keep, maybe and cut.
- **Oracle**: look ahead at what happens if this ships.
- **Judge**: critique your work against the brief, one lens at a time.

## Running it

Open `index.html` in a browser. The built-in example decks work anywhere.

Generating new decks, Talk, and Judge call Claude through the claude.ai artifact runtime (`window.claude.use("sample")`), so those features only work when the page is published as a Claude artifact. Everything else is stored in the browser's local storage.

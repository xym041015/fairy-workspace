import pathlib
base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual")

# ---------- hero-projection-manager.js + index.js: observe the renamed root too ----------
for rel, pairs in {
  "src/client/hero-projection-manager.js": [
    ("`${OFFICIAL_SELECTORS.conversation}, ${OFFICIAL_SELECTORS.phaseHero}", "`${OFFICIAL_SELECTORS.conversation}, ${OFFICIAL_SELECTORS.conversationAlt}, ${OFFICIAL_SELECTORS.phaseHero}"),
    ("`${OFFICIAL_SELECTORS.conversation}, ${OFFICIAL_SELECTORS.phaseActive}", "`${OFFICIAL_SELECTORS.conversation}, ${OFFICIAL_SELECTORS.conversationAlt}, ${OFFICIAL_SELECTORS.phaseActive}"),
  ],
  "src/client/index.js": [
    ("const STAGE_SURFACE_SELECTOR = OFFICIAL_SELECTORS.conversation;", "const STAGE_SURFACE_SELECTOR = `${OFFICIAL_SELECTORS.conversation}, ${OFFICIAL_SELECTORS.conversationAlt}`;"),
    ("`${OFFICIAL_SELECTORS.sidebar}, ${OFFICIAL_SELECTORS.conversation}, ${OFFICIAL_SELECTORS.balance}`", "`${OFFICIAL_SELECTORS.sidebar}, ${OFFICIAL_SELECTORS.conversation}, ${OFFICIAL_SELECTORS.conversationAlt}, ${OFFICIAL_SELECTORS.balance}`"),
  ],
}.items():
    p = base / rel
    s = p.read_text()
    for old, new in pairs:
        assert old in s, (rel, old[:60])
        s = s.replace(old, new, 1)
    p.write_text(s)
    print("patched", rel)

# ---------- style.js: CSS must match both conversation roots ----------
p = base / "src/client/style.js"
s = p.read_text()
child_old = 'html[data-dsh-fairy-visual] [data-slot="conversation"]>[data-phase]'
assert child_old in s, "child combinator anchor"
child_new = child_old + ',html[data-dsh-fairy-visual] [data-slot="main.conversation"]>[data-phase]'
s = s.replace(child_old, child_new, 1)
for attr in ["data-conversation-scroll", "data-input-scroll"]:
    old = '[data-slot="conversation"] [' + attr + ']'
    assert old in s, attr
    new = old + ',[data-slot="main.conversation"] [' + attr + ']'
    s = s.replace(old, new)

# modal recession must also cover the whole composer surface (status strip included)
old = 'html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-dock="true"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-composer-card="true"]{visibility:hidden!important}'
assert old in s, "visibility anchor"
new = old + 'html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-composer-seat],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-slot="conversation.composer"]{visibility:hidden!important}'
s = s.replace(old, new, 1)
p.write_text(s)
print("style.js patched")
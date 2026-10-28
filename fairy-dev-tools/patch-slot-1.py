import pathlib
base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual")

# ---------- dom-adapter.js ----------
p = base / "src/client/dom-adapter.js"
s = p.read_text()
old = '  conversation: \'[data-slot="conversation"]\','
assert old in s, "conversation selector anchor"
new = old + "\n  conversationAlt: '[data-slot=\"main.conversation\"]',"
s = s.replace(old, new, 1)

old = "function conversation(doc = document) { return officialNode('conversation', doc); }"
assert old in s, "conversation resolver anchor"
new = ("function conversation(doc = document) {\n"
       "  // DSH renamed the conversation surface slot; accept both names so the\n"
       "  // persistent HDD composition keeps binding on either layout.\n"
       "  return officialNode('conversation', doc) || officialNode('conversationAlt', doc);\n"
       "}")
s = s.replace(old, new, 1)

# scroll targets must union both conversation roots
old = """const HDD_SCROLL_TARGETS = Object.freeze([
  { key: 'history', selector: `${OFFICIAL_SELECTORS.sidebar} ${OFFICIAL_SELECTORS.sessionTree}` },
  { key: 'conversation', selector: `${OFFICIAL_SELECTORS.conversation} ${OFFICIAL_SELECTORS.conversationScroll}` },
  { key: 'input', selector: `${OFFICIAL_SELECTORS.conversation} ${OFFICIAL_SELECTORS.inputScroll}` },
]);"""
assert old in s, "scroll targets anchor"
new = """const conversationDescendant = (descendant) => [
  `${OFFICIAL_SELECTORS.conversation} ${descendant}`,
  `${OFFICIAL_SELECTORS.conversationAlt} ${descendant}`,
].join(',');

const HDD_SCROLL_TARGETS = Object.freeze([
  { key: 'history', selector: `${OFFICIAL_SELECTORS.sidebar} ${OFFICIAL_SELECTORS.sessionTree}` },
  { key: 'conversation', selector: conversationDescendant(OFFICIAL_SELECTORS.conversationScroll) },
  { key: 'input', selector: conversationDescendant(OFFICIAL_SELECTORS.inputScroll) },
]);"""
s = s.replace(old, new, 1)

# semantic surface list must include the renamed root
old = "  OFFICIAL_SELECTORS.conversation,\n  OFFICIAL_SELECTORS.shellOverlay,"
assert old in s, "semantic surface anchor"
s = s.replace(old, "  OFFICIAL_SELECTORS.conversation,\n  OFFICIAL_SELECTORS.conversationAlt,\n  OFFICIAL_SELECTORS.shellOverlay,", 1)
p.write_text(s)
print("dom-adapter patched")
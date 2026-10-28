import pathlib

base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual")

# 1) dom-adapter.js
p = base / "src/client/dom-adapter.js"
s = p.read_text()
old = """  settingsDialog: '[data-slot="sidebar.settings"] [role="dialog"]',"""
assert old in s, "selector anchor"
s = s.replace(old, old + """
  modalDialog: '[role="dialog"][aria-modal="true"]',""", 1)
old = "function settingsDialog(doc = document) { return officialNode('settingsDialog', doc); }"
assert old in s, "resolver anchor"
s = s.replace(old, old + """
function modalDialog(doc = document) { return officialNode('modalDialog', doc); }""", 1)
old = """  settingsDialog,
  sidebarResizeHandle,"""
assert old in s, "export anchor"
s = s.replace(old, """  settingsDialog,
  modalDialog,
  sidebarResizeHandle,""", 1)
p.write_text(s)

# 2) semantic-markers-manager.js
p = base / "src/client/semantic-markers-manager.js"
s = p.read_text()
old = "settingsDialog, sidebarOpenControl"
assert old in s, "import anchor"
s = s.replace(old, "settingsDialog, modalDialog, sidebarOpenControl", 1)
old = "    const nextModalOpen = Boolean(settingsDialog(document));"
assert old in s, "compute anchor"
s = s.replace(old, "    const nextModalOpen = Boolean(settingsDialog(document) || modalDialog(document));", 1)
old = "      attributeFilter: ['aria-expanded', 'aria-label', 'aria-selected', OFFICIAL_ATTRIBUTES.phase, OFFICIAL_ATTRIBUTES.slot],"
assert old in s, "filter anchor"
s = s.replace(old, "      attributeFilter: ['aria-expanded', 'aria-label', 'aria-selected', 'aria-modal', 'role', OFFICIAL_ATTRIBUTES.phase, OFFICIAL_ATTRIBUTES.slot],", 1)
p.write_text(s)

# 3) style.js
p = base / "src/client/style.js"
s = p.read_text()
anchor = "  el.textContent = cssSections.map(({ css }) => css).join('');"
assert anchor in s, "style anchor"
css = "html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] .dsh-fairy-stage,html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-material=\"true\"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-mascot-scale-control=\"true\"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-mascot-scale-base=\"true\"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-mascot-animation-speed-base=\"true\"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-voice-control=\"true\"]{display:none!important}html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-dock=\"true\"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-dock=\"true\"] *{pointer-events:none!important}html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-dock=\"true\"]::before,html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-composer-card=\"true\"]::before{display:none!important}html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-composer-card=\"true\"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-seat=\"true\"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-input-scroll]{background:transparent!important;background-color:transparent!important;background-image:none!important;border-color:transparent!important;box-shadow:none!important}"
modal_css = ("  // While any official modal (settings, onboarding, plugin market, ...) is open the\n"
             "  // persistent HDD chrome recedes so the input surface cannot collide with it.\n"
             "  appendSection('modal', `" + css + "`);\n")
s = s.replace(anchor, modal_css + anchor, 1)
p.write_text(s)
print("patched all three files")
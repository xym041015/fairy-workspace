import pathlib
base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual")
p = base / "src/client/style.js"
s = p.read_text()
anchor = "  el.textContent = cssSections.map(({ css }) => css).join('');"
assert anchor in s
css = "html[data-dsh-fairy-visual] [data-dsh-fairy-composer-dock=\"true\"] [data-dsh-fairy-composer-voice-control=\"true\"],html[data-dsh-fairy-visual] [data-dsh-fairy-composer-dock=\"true\"] [data-dsh-fairy-composer-send-control=\"true\"],html[data-dsh-fairy-visual] [data-dsh-fairy-composer-dock=\"true\"] [data-dsh-fairy-mascot-scale-base=\"true\"],html[data-dsh-fairy-visual] [data-dsh-fairy-composer-dock=\"true\"] [data-dsh-fairy-mascot-scale-control=\"true\"],html[data-dsh-fairy-visual] [data-dsh-fairy-composer-dock=\"true\"] [data-dsh-fairy-mascot-animation-speed-base=\"true\"],html[data-dsh-fairy-visual] [data-dsh-fairy-composer-dock=\"true\"] [data-dsh-fairy-mascot-animation-speed-control=\"true\"]{grid-row:auto!important;grid-column:auto!important}html[data-dsh-fairy-visual] [data-composer-card=\"true\"][data-dsh-fairy-composer-attachments-active=\"true\"] [data-input-scroll]{position:relative!important;z-index:2!important}"
block = ("  // Layout corrections for the renamed conversation surface: absolutely\n"
         "  // positioned dock hardware must share one containing block, and the\n"
         "  // attachment substrate must stay behind the input text.\n"
         "  appendSection('composer-dock-layout', `" + css + "`);\n")
if "composer-dock-layout" not in s:
    s = s.replace(anchor, block + anchor, 1)
    p.write_text(s)
    print("layout section added")
else:
    print("already present")
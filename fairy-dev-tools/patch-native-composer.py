import pathlib
base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual")

# constants.js: explicit switch for the HDD composer dock projection
p = base / "src/client/constants.js"
s = p.read_text()
anchor = "export const POWER_TOGGLE_WIDTH = 82;"
assert anchor in s, "constants anchor"
flag = ("// The HDD composer dock projection owns a fixed-height, grid-placeable input\n"
        "// surface. This DSH layout keeps the workspace control inside the composer's\n"
        "// accessory row and renders the official dock slot hidden, so the projection\n"
        "// deforms the official input area. Keep the native composer surface enabled\n"
        "// and leave the dock code in place for layouts that match its contract.\n"
        "export const COMPOSER_DOCK_ENABLED = false;\n\n")
s = s.replace(anchor, flag + anchor, 1)
p.write_text(s)

# index.js: gate the mount
p = base / "src/client/index.js"
s = p.read_text()
old = "const { SETTINGS_NAMESPACE, STYLE_ID, MODE_ATTR, POWER_MODE_ATTR, THEME_ATTR, POWER_TOGGLE_WIDTH, POWER_TOGGLE_HEIGHT, DEFAULT } = require('./constants.js');"
assert old in s, "import anchor"
s = s.replace(old, old.replace("DEFAULT }", "COMPOSER_DOCK_ENABLED, DEFAULT }"), 1)
old2 = "        lifecycle.add(mountComposerDock(controller), 'stage-host:composer-dock');"
assert old2 in s, "mount anchor"
new2 = ("        // The native composer surface stays in charge unless the dock contract\n"
        "        // matches this layout (see COMPOSER_DOCK_ENABLED).\n"
        "        if (COMPOSER_DOCK_ENABLED) lifecycle.add(mountComposerDock(controller), 'stage-host:composer-dock');")
s = s.replace(old2, new2, 1)
p.write_text(s)
print("dock projection gated")
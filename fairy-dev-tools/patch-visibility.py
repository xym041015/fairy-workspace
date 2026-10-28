import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual") / "src/client/style.js"
s = p.read_text()
anchor = 'html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-dock="true"] *{pointer-events:none!important}'
assert anchor in s, "anchor"
addition = 'html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-dsh-fairy-composer-dock="true"],html[data-dsh-fairy-visual][data-dsh-fairy-modal-open] [data-composer-card="true"]{visibility:hidden!important}'
if addition not in s:
    s = s.replace(anchor, anchor + addition, 1)
    p.write_text(s)
    print("visibility rule added")
else:
    print("already present")
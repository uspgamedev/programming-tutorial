
local dialog = {}
local text = ""

function dialog.setText (the_text)
  text = the_text
end

function dialog.draw (g)
  g.setColor(COLORS.TEXT)
  g.rectangle('line', 10, 10, 380, 130)
  g.printf(text, 10 + 10, 10 + 10, 380, 'left')
end

return dialog


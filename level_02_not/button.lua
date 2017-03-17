
local button = {}

local button_list = {}
local selected    = 1

function button.new (id)
  table.insert(button_list, id)
end

function button.getSelected ()
  return button_list[selected]
end

function button.cursorUp ()
  selected = (selected == 1) and (#button_list) or (selected - 1)
end

function button.cursorDown ()
  selected = (selected % (#button_list)) + 1
end

function button.draw (g)
  for i,id in ipairs(button_list) do
    g.push()
    g.translate(10, (i-1)*50 + 10)
    if i == selected then
      g.setColor(COLORS.HIGHLIGHT)
      g.rectangle('fill', 0, 0, 180, 30)
    end
    g.setColor(COLORS.TEXT)
    g.rectangle('line', 0, 0, 180, 30)
    local pad = (30 - g.getFont():getHeight())/2
    g.printf(id, 0, pad, 180, 'center')
    g.pop()
  end
end

return button



local replace = string.gsub

hooksecurefunc("ActionButton_UpdateHotkeys", function(self)
    local hotkey = _G[self:GetName()..'HotKey']
    local text = hotkey:GetText()

    text = replace(text, '(s%-)', 'S-')
    text = replace(text, '(a%-)', 'A-')
    text = replace(text, '(c%-)', 'C-')
    text = replace(text, '(st%-)', 'C-') -- german control 'Steuerung'

    for i = 1, 30 do
        text = replace(text, _G['KEY_BUTTON'..i], 'M'..i)
    end

    for i = 1, 9 do
        text = replace(text, _G['KEY_NUMPAD'..i], 'Nu'..i)
    end

    text = replace(text, KEY_MOUSEWHEELUP, 'MU')
    text = replace(text, KEY_MOUSEWHEELDOWN, 'MD')
    text = replace(text, KEY_NUMLOCK, 'NuL')
    text = replace(text, KEY_PAGEUP, 'PU')
    text = replace(text, KEY_PAGEDOWN, 'PD')
    text = replace(text, KEY_SPACE, '_')
    text = replace(text, KEY_INSERT, 'Ins')
    text = replace(text, KEY_HOME, 'Hm')
    text = replace(text, KEY_DELETE, 'Del')

    hotkey:SetText(text)
end)
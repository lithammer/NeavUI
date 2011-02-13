local _, addon = ...

addon.show = {}
addon.comboColor = {}

-- Set to true to show, else false
addon.show.energy = true
addon.show.focus = true
addon.show.rage = true
addon.show.runes = true

-- Combo points color
addon.comboColor[1] = {r = 1.0, g = 1.0, b = 1.0} -- White
addon.comboColor[2] = {r = 1.0, g = 1.0, b = 1.0} -- White
addon.comboColor[3] = {r = 1.0, g = 1.0, b = 1.0} -- White
addon.comboColor[4] = {r = 0.9, g = 0.7, b = 0.0} -- Orange
addon.comboColor[5] = {r = 1.0, g = 0.0, b = 0.0} -- Red

-- Position of the power bar
addon.position = {'CENTER', UIParent, 0, -223}

--INTERFACE_ACTION_BLOCKED = ""

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(_, event, ...)
    if (event == "PLAYER_LOGIN") then
        SetCVar("ScreenshotQuality", 10)
    end
end)

SlashCmdList["FRAMENAME"] = function()
    local name = GetMouseFocus():GetName()

    if (name) then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00   "..name)
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff00FF00This frame has no name!")
    end
end

SLASH_FRAMENAME1 = "/frame"

SlashCmdList["RELOADUI"] = function()
    ReloadUI()
end
SLASH_RELOADUI1 = "/rl"

if AddonList then
    _G["ADDON_DEMAND_LOADED"] = "On Demand";
end

-- HonorFrame Taint Workaround
-- Credit: https://www.townlong-yak.com/bugs/afKy4k-HonorFrameLoadTaint

if ( UIDROPDOWNMENU_VALUE_PATCH_VERSION or 0 ) < 2 then
	UIDROPDOWNMENU_VALUE_PATCH_VERSION = 2
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
		if UIDROPDOWNMENU_VALUE_PATCH_VERSION ~= 2 then
			return
		end
		for i=1, UIDROPDOWNMENU_MAXLEVELS do
			for j=1, UIDROPDOWNMENU_MAXBUTTONS do
				local b = _G["DropDownList" .. i .. "Button" .. j]
				if ( not (issecurevariable(b, "value") or b:IsShown()) ) then
					b.value = nil
					repeat
						j, b["fx" .. j] = j+1
					until issecurevariable(b, "value")
				end
			end
		end
	end)
end

local _, nCore = ...

function nCore:Skins()
    if not nCoreDB.Skins then return end

    local f = CreateFrame("Frame")
    f:RegisterEvent("VARIABLES_LOADED")
    f:RegisterEvent("ADDON_LOADED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")

    f:SetScript("OnEvent", function(self)
        if IsAddOnLoaded("Omen") then
            if not OmenBarList.beautyBorder then
                OmenBarList:CreateBeautyBorder(11)
                OmenBarList:SetBeautyBorderPadding(1)
            end
        end

        if IsAddOnLoaded("DBM-Core") then
            hooksecurefunc(DBT, "CreateBar", function(self)
                for bar in self:GetBarIterator() do
                    local frame = bar.frame
                    local tbar = _G[frame:GetName().."Bar"]
                    local spark = _G[frame:GetName().."BarSpark"]
                    -- local texture = _G[frame:GetName().."BarTexture"]
                    local icon1 = _G[frame:GetName().."BarIcon1"]
                    local icon2 = _G[frame:GetName().."BarIcon2"]
                    local name = _G[frame:GetName().."BarName"]
                    local timer = _G[frame:GetName().."BarTimer"]

                    spark:SetTexture(nil)

                    Mixin(tbar, BackdropTemplateMixin)
                    timer:ClearAllPoints()
                    timer:SetPoint("RIGHT", tbar, "RIGHT", -4, 0)
                    timer:SetFont(STANDARD_TEXT_FONT, 22)
                    timer:SetJustifyH("RIGHT")

                    name:ClearAllPoints()
                    name:SetPoint("LEFT", tbar, 4, 0)
                    name:SetPoint("RIGHT", timer, "LEFT", -4, 0)
                    name:SetFont(STANDARD_TEXT_FONT, 15)

                    tbar:CreateBeautyBorder(10)
                    tbar:SetBeautyBorderPadding(tbar:GetHeight() + 3, 2, 2, 2, tbar:GetHeight() + 3, 2, 2, 2)
                    tbar:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8"})
                    tbar:SetBackdropColor(0, 0, 0, 0.5)

                    icon1:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                    icon1:SetSize(tbar:GetHeight(), tbar:GetHeight() - 1)

                    icon2:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                    icon2:SetSize(tbar:GetHeight(), tbar:GetHeight() - 1)
                end
            end)
        end

        if IsAddOnLoaded("TinyDPS") then
            if not tdpsFrame.beautyBorder then
                tdpsFrame:CreateBeautyBorder(11)
                tdpsFrame:SetBeautyBorderPadding(2)
                tdpsFrame:SetBackdrop({
                    bgFile = "Interface\\Buttons\\WHITE8x8",
                    insets = { left = 0, right = 0, top = 0, bottom = 0 },
                })
                tdpsFrame:SetBackdropColor(0, 0, 0, 0.5)
            end
        end

        if IsAddOnLoaded("Recount") then
            if not Recount.MainWindow.beautyBorder then
                Recount.MainWindow:CreateBeautyBorder(12)
                Recount.MainWindow:SetBeautyBorderPadding(2, -10, 2, -10, 2, 2, 2, 2)
                Recount.MainWindow:SetBackdrop({
                    bgFile = "Interface\\Buttons\\WHITE8x8",
                    insets = { left = 0, right = 0, top = 10, bottom = 0 },
                })
                Recount.MainWindow:SetBackdropColor(0, 0, 0, 0.5)
            end
        end

        if IsAddOnLoaded("Skada") then
            local OriginalSkadaFunc = Skada.PLAYER_ENTERING_WORLD
            function Skada:PLAYER_ENTERING_WORLD()
                OriginalSkadaFunc(self)

                if SkadaBarWindowSkada and not SkadaBarWindowSkada.beautyBorder then
                    SkadaBarWindowSkada:CreateBeautyBorder(11)
                    SkadaBarWindowSkada:SetBeautyBorderPadding(3)
                    SkadaBarWindowSkada:SetBackdrop({
                        bgFile = "Interface\\Buttons\\WHITE8x8",
                        insets = { left = 0, right = 0, top = 10, bottom = 0 },
                    })
                    SkadaBarWindowSkada:SetBackdropColor(0, 0, 0, 0.50)
                    SkadaBarWindowSkada.button:CreateBeautyBorder(11)
                    SkadaBarWindowSkada.button:SetBeautyBorderPadding(2)
                end
            end
        end

        if IsAddOnLoaded("Numeration") then
            if not NumerationFrame.beautyBorder then
                NumerationFrame:CreateBeautyBorder(11)
                NumerationFrame:SetBeautyBorderPadding(3)
            end
        end
    end)
end

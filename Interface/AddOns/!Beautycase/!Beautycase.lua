--[[
    
    How to use:
         
    ----------------------------------------------
    
    CreateBorder(myFrame, borderSize, r, g, b, uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2)
        
        myFrame         -> The name of your frame, It must be a frame not a texture/fontstring
        borderSize      -> The size of the simple square Border. 10-12 looks amazing with the default beautycase texture
        r, g, b         -> The colors of the Border. r = Red, g = Green, b = Blue
        uL1, uL2        -> top left x, top left y
        uR1, uR2        -> top right x, top right y
        bL1, bL2        -> bottom left x, bottom left y
        bR1, bR2        -> bottom right x, bottom right y
    
    
    for example:
            
            local r, g, b = 1, 1, 0 -- for yellow
            CreateBorder(myFrame, 12, r, g, b, 1, 1, 1, 1, 1, 1, 1, 1)
        
        
        shorter method if the spacing between the frame is always the same
        
            CreateBorder(myFrame, 12, r, g, b, 1)
            
        
        or for no spacing
        
            CreateBorder(myFrame, 12, r, g, b)
    
    
    ----------------------------------------------
    
    If you want you recolor the border or shadow (for aggrowarning or similar) you can make this with this little trick
    
        ColorBorder(myFrame, r, g, b, alpha)
        ColorBorderShadow(myFrame, r, g, b, alpha)
        
    ----------------------------------------------
    
    For changing the border or shadow texture
    
        SetBorderTexture(myFrame, texture.tga)
        SetBorderShadowTexture(myFrame, texture.tga)
     
    ----------------------------------------------
    
    For all Border Infos
    
        local borderSize, texture, r, g, b, alpha = GetBorderInfo(myFrame)
     
    ----------------------------------------------
    
    
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    NEW!
    
    myFrame:CreateBorder(borderSize)
    myFrame:SetBorderSize(borderSize)
    
    myFrame:SetBorderPadding(number or uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2)
    
    myFrame:SetBorderTexture(texture)
    myFrame:SetBorderShadowTexture(texture)
    
    myFrame:SetBorderColor(r, g, b)
    myFrame:SetBorderShadowColor(r, g, b)
    
    myFrame:HideBorder()
    myFrame:ShowBorder()
    
    myFrame:GetBorder() - true if has a beautycase border, otherwise false
    
    local borderSize, texture, r, g, b, alpha = myFrame:GetBorderInfo()
    
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
--]]

local addonName = select(1, GetAddOnInfo('!Beautycase'))
local formatName = '|cffFF0000'..addonName

local textureNormal = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'
local textureShadow = 'Interface\\AddOns\\!Beautycase\\media\\textureShadow'

local function GetBorder(self)
    if (self.Border) then
        return true
    else
        return false
    end
end

function GetBorderInfo(self)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Border) then
        local tex = self.Border[1]:GetTexture()
        local size = self.Border[1]:GetSize()
        local r, g, b, a = self.Border[1]:GetVertexColor()
        
        return size, tex, r, g, b, a
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')   
    end
end

local function SetBorderPadding(self, uL1, ...)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
        return
    end
    
    if (not self:IsObjectType('Frame')) then
        local frame  = 'frame'
        print(formatName..' error:|r The entered object is not a '..frame..'!') 
        return
    end
    
    local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
    
    local space
    if (GetBorderInfo(self) >= 10) then
        space = 3
    else
        space = GetBorderInfo(self)/3.5
    end
        
    if (self.Border) then
        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)
        self.Shadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space)
        
        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)
        self.Shadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space)
        
        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))
        self.Shadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space)
        
        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))
        self.Shadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space)
    end
end

function ColorBorder(self, ...)
    local r, g, b, a = ...
    
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Border) then
        for i = 1, 8 do
            self.Border[i]:SetVertexColor(r, g, b, a or 1)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function ColorBorderShadow(self, ...)
    local r, g, b, a = ...
    
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Shadow) then
        for i = 1, 8 do
            self.Shadow[i]:SetVertexColor(r, g, b, a or 1)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function SetBorderTexture(self, texture)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Border) then
        for i = 1, 8 do
            self.Border[i]:SetTexture(texture)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function SetBorderShadowTexture(self, texture)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Shadow) then
        for i = 1, 8 do
            self.Shadow[i]:SetTexture(texture)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

local function SetBorderSize(self, size)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Shadow) then
        for i = 1, 8 do
            self.Border[i]:SetSize(size, size) 
            self.Shadow[i]:SetSize(size, size) 
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

local function HideBorder(self)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Shadow) then
        for i = 1, 8 do
            self.Border[i]:Hide()
            self.Shadow[i]:Hide()
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

local function ShowBorder(self)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.Shadow) then
        for i = 1, 8 do
            self.Border[i]:Show()
            self.Shadow[i]:Show()
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

local function ApplyBorder(self, borderSize, R, G, B, uL1, ...)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
        return
    end
    
    if (not self:IsObjectType('Frame')) then
        local frame  = 'frame'
        print(formatName..' error:|r The entered object is not a '..frame..'!') 
        return
    end
    
    local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
    
    local space
    if (borderSize >= 10) then
        space = 3
    else
        space = borderSize/3.5
    end
        
    if (not self.HasBorder) then
    
        self.Shadow = {}
        for i = 1, 8 do
            self.Shadow[i] = self:CreateTexture(nil, 'BORDER')
            self.Shadow[i]:SetParent(self)
            self.Shadow[i]:SetTexture(textureShadow)
            self.Shadow[i]:SetSize(borderSize, borderSize)  
            self.Shadow[i]:SetVertexColor(0, 0, 0, 1)
        end
        
        self.Border = {}
        for i = 1, 8 do
            self.Border[i] = self:CreateTexture(nil, 'OVERLAY')
            self.Border[i]:SetParent(self)
            self.Border[i]:SetTexture(textureNormal)
            self.Border[i]:SetSize(borderSize, borderSize) 
            self.Border[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end
        
        self.Border[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Border[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.Border[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Border[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.Border[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Border[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.Border[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Border[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))

        self.Border[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Border[5]:SetPoint('TOPLEFT', self.Border[1], 'TOPRIGHT')
        self.Border[5]:SetPoint('TOPRIGHT', self.Border[2], 'TOPLEFT')

        self.Border[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Border[6]:SetPoint('BOTTOMLEFT', self.Border[3], 'BOTTOMRIGHT')
        self.Border[6]:SetPoint('BOTTOMRIGHT', self.Border[4], 'BOTTOMLEFT')

        self.Border[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Border[7]:SetPoint('TOPLEFT', self.Border[1], 'BOTTOMLEFT')
        self.Border[7]:SetPoint('BOTTOMLEFT', self.Border[3], 'TOPLEFT')

        self.Border[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Border[8]:SetPoint('TOPRIGHT', self.Border[2], 'BOTTOMRIGHT')
        self.Border[8]:SetPoint('BOTTOMRIGHT', self.Border[4], 'TOPRIGHT')
        
        self.Shadow[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.Shadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space)

        self.Shadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.Shadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space)

        self.Shadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.Shadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space)

        self.Shadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.Shadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space)

        self.Shadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.Shadow[5]:SetPoint('TOPLEFT', self.Shadow[1], 'TOPRIGHT')
        self.Shadow[5]:SetPoint('TOPRIGHT', self.Shadow[2], 'TOPLEFT')

        self.Shadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.Shadow[6]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'BOTTOMRIGHT')
        self.Shadow[6]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'BOTTOMLEFT')

        self.Shadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.Shadow[7]:SetPoint('TOPLEFT', self.Shadow[1], 'BOTTOMLEFT')
        self.Shadow[7]:SetPoint('BOTTOMLEFT', self.Shadow[3], 'TOPLEFT')

        self.Shadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.Shadow[8]:SetPoint('TOPRIGHT', self.Shadow[2], 'BOTTOMRIGHT')
        self.Shadow[8]:SetPoint('BOTTOMRIGHT', self.Shadow[4], 'TOPRIGHT')
        
        self.HasBorder = true
    end
end

function CreateBorder(self, borderSize, R, G, B, uL1, ...)
    ApplyBorder(self, borderSize, R, G, B, uL1, ...)
end

local function FuncCreateBorder(self, borderSize)
    ApplyBorder(self, borderSize)
end

local function addapi(object)
	local mt = getmetatable(object).__index
    
	mt.CreateBorder = FuncCreateBorder
    mt.SetBorderSize = SetBorderSize
    
    mt.SetBorderPadding = SetBorderPadding
    
    mt.SetBorderTexture = SetBorderTexture
    mt.SetBorderShadowTexture = SetBorderShadowTexture
    
    mt.SetBorderColor = ColorBorder
    mt.SetBorderShadowColor = ColorBorderShadow
    
    mt.HideBorder = HideBorder
    mt.ShowBorder = ShowBorder
    
    mt.GetBorder = GetBorder
    mt.GetBorderInfo = GetBorderInfo
end


local handled = {
    ['Frame'] = true
}

local object = CreateFrame('Frame')
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()

while object do
	if (not handled[object:GetObjectType()]) then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end
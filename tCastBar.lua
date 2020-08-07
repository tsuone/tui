--## predefine ##--
local c = CastingBarFrame

local cb = CastingBarFrameBorder

local cf = CastingBarFrameFlash

local ct = CastingBarFrameText

--## Hide texture and flash ##-
CastingBarFrameBorder:Hide()
CastingBarFrameFlash:SetTexture(nil)

--## style bar ##--
c:SetWidth(250)
c:SetHeight(8)

ct:SetFont("Fonts\\ARIALN.ttf", 15, "THINOUTLINE")

local function setIcon(castingBar, texture)
	if texture and not addon.db.profile.hideIcon then
		castingBar.icon:SetTexture(texture)
		setIconAndTimePositions(castingBar.icon, addon.db.profile.iconPosition)
		castingBar.icon:Show()
end
end

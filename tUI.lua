for _, texture in next, {
	MainMenuBarLeftEndCap,MainMenuBarRightEndCap,
	MainMenuBarPageNumber,
	MainMenuBarTexture0,MainMenuBarTexture1,MainMenuBarTexture2,MainMenuBarTexture3,
	MainMenuXPBarTexture0, MainMenuXPBarTexture1, MainMenuXPBarTexture2, MainMenuXPBarTexture3,
	MainMenuMaxLevelBar0, MainMenuMaxLevelBar1, MainMenuMaxLevelBar2, MainMenuMaxLevelBar3,
	MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3,
	ReputationWatchBarTexture0, ReputationWatchBarTexture1, ReputationWatchBarTexture2, ReputationWatchBarTexture3,
	ReputationXPBarTexture0, ReputationXPBarTexture1, ReputationXPBarTexture2, ReputationXPBarTexture3,
	BonusActionBarTexture0, BonusActionBarTexture1,
	PossessBackground1, PossessBackground2,
	SlidingActionBarTexture0, SlidingActionBarTexture1,
  CharacterBag0Slot, CharacterBag1Slot,	CharacterBag2Slot, CharacterBag3Slot,
} do
	texture:Hide()
end

-- ## Hide PerformanceBar ##--
MainMenuBarPerformanceBar:Hide()

-- ## Get rid of Stance/Shapeshift textures ##--
ShapeshiftBarLeft:SetTexture(nil)
ShapeshiftBarMiddle:SetTexture(nil)
ShapeshiftBarRight:SetTexture(nil)

-- ## Remove some MiniMap buttons and Minimap ##--
MiniMapWorldMapButton:Hide()
MinimapZoomIn:Hide()
GameTimeFrame:Hide()

--## Hide MenuChatButton ##--
ChatFrameMenuButton:Hide()

-- ## Remove PvP Icon (playerframe) ##--
PlayerPVPIconHitArea:Hide()

-- ## Debuff size change ##--
hooksecurefunc("BuffButton_Update", function()
for i=1,32 do
if _G["DebuffButton"..i] ~= nil then
_G["DebuffButton"..i]:SetScale(1.5)
end
end
end)

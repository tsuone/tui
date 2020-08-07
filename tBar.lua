--config
local SCALE = 0.90
local FADE_BOX = true
local FADE_SIDEBAR = true
local SIDEBAR_Y = 0
local FADE_PETBAR = true
--config end



for _, bar in next, {
	MainMenuBar,
	MultiBarBottomLeft,
	MultiBarBottomRight,
	MultiBarLeft,
	MultiBarRight,
	PetActionBarFrame,
	PossessBarFrame,
	} do
	bar:EnableMouse(false);
end




----- start rebuild the layout of bars ----
local HEIGHT = 4
local WIDTH = 512
MainMenuBar:SetScale(SCALE)
MainMenuBar:SetWidth( 512 )
MultiBarBottomLeft:SetScale(SCALE)
MultiBarBottomRight:SetScale(SCALE)
MultiBarLeft:SetScale(SCALE)
MultiBarLeft:SetAlpha(.5)
MultiBarRight:SetScale(SCALE)
MultiBarRight:SetAlpha(.5)
local obar = CreateFrame("frame",nil,UIParent)
local pet_fade = CreateFrame("frame", nil, PetActionBarFrame)

local function layout()

  if InCombatLockdown() then return end

  local y = 5
  local anchor = ActionButton1

  if ( MainMenuExpBar:IsShown() and ReputationWatchBar:IsShown() ) then
    y = 25
  elseif MainMenuExpBar:IsShown() then
    y = 20
  elseif  ReputationWatchBar:IsShown()  then
    y = 20
  end

  if  MultiBarBottomLeft:IsShown() then
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, y)
    y = 5
    anchor = MultiBarBottomLeft
  end

  if MultiBarBottomRight:IsShown() then
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, y)
    y= 5
    anchor = MultiBarBottomRightButton1
  end

  --shift bar  ��̬������
ShapeshiftBarFrame:Hide()

  --totem bar of shaman ͼ����


  --pet ������
  local px = 64  		-- ( 498 - ( 30 * 10 + 8 * 9 ) ) / 2    	when set middle
  if ShapeshiftButton1:IsShown() then
    if GetNumShapeshiftForms() < 4 then
      px = 128  	-- ( 498 - ( 30 * 10 + 8 * 9 ) )  when set right
    else
      px = 240 	-- 498 - ( 30 * 7 + 8 * 6 )   				when set right and fade b8 - b10
      if FADE_PETBAR == true then
        for i = 8, 10 do
          _G["PetActionButton"..i]:SetParent( pet_fade );
          fade( pet_fade, _G["PetActionButton"..i] );
        end
      end
      PetActionButton8:ClearAllPoints()
      PetActionButton8:SetPoint("BOTTOMLEFT", PetActionButton5, "TOPLEFT", 0, y)
    end
  end
  PetActionButton1:ClearAllPoints()
  PetActionButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", px, y)

  if anchor == ActionButton1 then y = 34 else y = 4 end
  --control buttons of play tools ������      (һЩ���ߵĿ��ư�ť)
  PossessButton1:ClearAllPoints();
  PossessButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, y);



end
-- end of rebuild

do
hooksecurefunc("UIParent_ManageFramePosition",layout)
UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
UIPARENT_MANAGED_FRAME_POSITIONS["PetActionBarFrame"] = nil
UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"] = nil
UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil

obar:RegisterEvent("PLAYER_ENTERING_WORLD")
obar:RegisterEvent("UPDATE_INSTANCE_INFO")
obar:RegisterEvent("PLAYER_TALENT_UPDATE")
obar:RegisterEvent("PLAYER_LEVEL_UP")
obar:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
obar:RegisterEvent("SPELL_UPDATE_USEABLE")
obar:RegisterEvent("PET_BAR_UPDATE")
obar:RegisterEvent("UNIT_ENTERED_VEHICLE")
obar:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
obar:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
obar:RegisterEvent("CLOSE_WORLD_MAP")
obar:RegisterEvent("PLAYER_LEVEL_UP")
obar:SetScript("OnEvent",function()

end)

end

--hide the main action bar when bonus actin bar is showing
local function showhideactionbuttons(alpha)
  for i=1, 12 do
    _G["ActionButton"..i]:SetAlpha(alpha)
  end
end
BonusActionBarFrame:HookScript("OnShow", function(self) showhideactionbuttons(0) end)
BonusActionBarFrame:HookScript("OnHide", function(self) showhideactionbuttons(1) end)
if BonusActionBarFrame:IsShown() then
    showhideactionbuttons(0)
end

  MainMenuBarBackpackButton:Hide()
  KeyRingButton:SetHeight(0)




MainMenuExpBar:SetWidth(WIDTH - 12)
MainMenuExpBar:SetHeight(HEIGHT)
MainMenuExpBar:ClearAllPoints()
MainMenuExpBar:SetPoint("CENTER", MainMenuBar, "TOP", 0, 0)


for _, reputationtexture in next, {
	ReputationWatchBarTexture0, ReputationWatchBarTexture1, ReputationWatchBarTexture2, ReputationWatchBarTexture3,
	ReputationXPBarTexture0, ReputationXPBarTexture1, ReputationXPBarTexture2, ReputationXPBarTexture3,
} do
	reputationtexture:SetTexture(nil)
end

local fontFile, fontHeight, fontFlags = MainMenuBarExpText:GetFont()
MainMenuBarExpText:SetFont(fontFile, floor(fontHeight / SCALE + 0.5), fontFlags)

ExhaustionLevelFillBar:SetHeight(HEIGHT)

ReputationWatchBar:SetWidth(WIDTH - 12)
ReputationWatchBar:SetHeight(HEIGHT)

ReputationWatchStatusBar:SetWidth(WIDTH - 12)

local fontFile, fontHeight, fontFlags = ReputationWatchStatusBarText:GetFont()
ReputationWatchStatusBarText:SetFont(fontFile, floor(fontHeight / SCALE + 0.5), fontFlags)


-- re-reconfigure ReputationWatchBar
-- we can't use events because of the delay issue
local function ReputationWatchBar_Update_posthook(...)
  local name, reaction, _, _, value = GetWatchedFactionInfo()
  local hasExpBar = MainMenuExpBar:IsShown()
  local l = MainMenuExpBar:GetWidth()

  if ( not name ) then
    if ( hasExpBar ) then
      MainMenuBarExpText:ClearAllPoints()
      MainMenuBarExpText:SetPoint("CENTER", MainMenuExpBar, 0, 1)
    end
    return ...
  end

  ReputationWatchStatusBar:SetHeight(HEIGHT)
  ReputationWatchStatusBarText:SetText(ReputationWatchStatusBarText:GetText() .. " " .. GetText("FACTION_STANDING_LABEL" .. reaction, UnitSex("player"))) -- adds standing label

  ReputationWatchStatusBar:SetHeight(HEIGHT)
  if ( hasExpBar ) then
    ReputationWatchBar:ClearAllPoints()
    ReputationWatchBar:SetPoint("CENTER", MainMenuBar, "BOTTOM", 0, 55 + 4.5)

    ReputationWatchStatusBarText:ClearAllPoints()
    ReputationWatchStatusBarText:SetPoint("CENTER", ReputationWatchBarOverlayFrame,l / 4, 1)

    MainMenuBarExpText:ClearAllPoints()
    MainMenuBarExpText:SetPoint("CENTER", MainMenuExpBar, l / -4 , 1)

  else
    ReputationWatchBar:ClearAllPoints()
    ReputationWatchBar:SetPoint("CENTER", MainMenuBar, "BOTTOM", 0, 55 -4.5)

    ReputationWatchStatusBarText:ClearAllPoints()
    ReputationWatchStatusBarText:SetPoint("CENTER", ReputationWatchBarOverlayFrame, 0, 1)
  end


  -- removes watched faction if we ware exalted
  if ( value == 28251 ) then
    --SetWatchedFactionIndex(0)
  end

  return ...
end
local ReputationWatchBar_Update_original = ReputationWatchBar_Update
function ReputationWatchBar_Update(...)
  return ReputationWatchBar_Update_posthook(ReputationWatchBar_Update_original(...))
end

--------------------------------------------------------------------------------------------
--patch from Tidy bar
--fix pet bar bug, it doesn't show sometime
PetActionBarFrame:SetAttribute("unit", "pet")
RegisterUnitWatch(PetActionBarFrame)


--hide petbar when vehicle  from myself
local petframe = CreateFrame("frame", "petfrme_event", MainMenuBar)
PetActionBarFrame:SetParent( petframe )
RegisterStateDriver(petframe, "visibility", "[target=vehicle,exists] hide;show")

for _, tmicro in next, {
	CharacterMicroButton,
	SpellbookMicroButton,
	TalentMicroButton,
	QuestLogMicroButton,
	SocialsMicroButton,
	LFGMicroButton,
	MainMenuMicroButton,
	HelpMicroButton,
	} do
	tmicro:SetAlpha(.2);
end

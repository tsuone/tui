CastingBarTimer_DisplayString = " %0.1f";

local eventFrame = CreateFrame("Frame");
eventFrame:Hide();
eventFrame.castingInfo = {};
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
eventFrame:RegisterEvent("UNIT_SPELLCAST_START");
eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP");
eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");

eventFrame:SetScript("OnEvent",
	function( self, event, arg1 )
		if ( event == "UNIT_SPELLCAST_START" ) then
			local _, _, text = UnitCastingInfo(arg1);
			self.castingInfo[arg1] = text..CastingBarTimer_DisplayString;

		elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then
			local _, _, text = UnitChannelInfo(arg1);
			self.castingInfo[arg1] = text..CastingBarTimer_DisplayString;

		elseif ( event == "PLAYER_TARGET_CHANGED" ) then
			local _, _, text = UnitCastingInfo("target");
			if not ( text ) then
				_, _, text = UnitChannelInfo("target");
			end
			if ( text ) then
				self.castingInfo["target"] = text..CastingBarTimer_DisplayString;
			else
				self.castingInfo["target"] = nil;
			end

		else
			self.castingInfo[arg1] = nil;
		end
	end
);


local OLD_CastingBarFrame_OnUpdate = CastingBarFrame_OnUpdate;
function CastingBarFrame_OnUpdate( ... )
	OLD_CastingBarFrame_OnUpdate(...);

	local timeLeft = nil;
	if ( this.casting ) then
		timeLeft = this.maxValue - this:GetValue();

	elseif ( this.channeling ) then
		timeLeft = this.duration + this:GetValue() - this.endTime;

	end
	if ( timeLeft ) then
		local textDisplay = getglobal(this:GetName().."Text")
		timeleft = (timeLeft < 0.1) and 0.01 or timeLeft;
		local displayName = eventFrame.castingInfo[this.unit];
		if not ( displayName ) then
			local _, text;
			if ( this.casting ) then
				_, _, text = UnitCastingInfo(this.unit);
			elseif ( this.channeling ) then
				_, _, text = UnitChannelInfo(this.unit);
			end
			if ( text ) then
				displayName = text..CastingBarTimer_DisplayString;
				eventFrame.castingInfo[this.unit] = displayName;
			else
				displayName = (textDisplay:GetText() or "")..CastingBarTimer_DisplayString;
			end
		end
		textDisplay:SetText( format(displayName, timeLeft) );
	end
end

function DoublesOffset()
	if GAMESTATE:PlayerUsingBothSides() then
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) then	return 157.5 end
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) then	return -157.5 end
	end
	return 0
end

-- i stole it from simply love :cries:
function JudgmentTween(self) self:zoom(0.8) self:decelerate(.1) self:zoom(0.75) self:sleep(.6) self:accelerate(.2) self:zoom(0) end
function HoldTween(self) self:diffuse(1,1,1,1) self:zoom(.5); self:sleep(.5) self:diffusealpha(0) end
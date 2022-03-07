function DoublesOffset()
	if GAMESTATE:PlayerUsingBothSides() then
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) then	return 157.5 end
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) then	return -157.5 end
	end
	return 0
end

-- i stole it from itg simply love :cries:
function JudgmentTween(self) self:zoom(0.8) self:decelerate(.1) self:zoom(0.75) self:sleep(.6) self:accelerate(.2) self:zoom(0) end
function HoldTween(self) self:diffuse(1,1,1,1) self:zoom(.5); self:sleep(.5) self:diffusealpha(0) end

-- thank you sm5 simply love (and also the fallback theme) --
function WideScale(AR4_3, AR16_9)
	return scale( SCREEN_WIDTH, 640, 853.333333, AR4_3, AR16_9 )
end

function Clamped_WideScale(AR4_3, AR16_9)
	local a = clamp(scale( SCREEN_WIDTH, 640, 853.333333, AR4_3, AR16_9 ),AR4_3,AR16_9)
	if a == AR4_3 and SCREEN_WIDTH ~= 640 then return AR16_9 else return a end
	-- why
end

function ThemeRange(start, stop, step)
	if start == nil then return end

	if not stop then
		stop = start
		start = 1
	end

	step = step or (start < stop and 1 or -1)

	-- if step has been explicitly provided as a positive number
	-- but the start and stop values tell us to decrement
	-- multiply step by -1 to allow decrementing to occur
	if step > 0 and start > stop then
		step = -1 * step
	end

	local t = {}
	while start < stop+step do
		t[#t+1] = start
		start = start + step
	end
	return t
end

function round2(num, numDP)
	return tonumber(string.format('%.' .. (numDP or 0) .. 'f', num))
end
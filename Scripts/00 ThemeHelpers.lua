-- put everything in a global so i dont pollute the earth and also retroactively fix everything else
ThemeHelpers = {}

-- this is a real function put in by the default theme i think so i will leave it alone :pensive:
function DoublesOffset()
	if GAMESTATE:PlayerUsingBothSides() then
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) then	return 157.5 end
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) then	return -157.5 end
	end
	return 0
end

-- i stole it from itg simply love :cries:
ThemeHelpers.JudgmentTween = function(self) self:zoom(0.8) self:decelerate(.1) self:zoom(0.75) self:sleep(.6) self:accelerate(.2) self:zoom(0) end
ThemeHelpers.HoldTween = function(self) self:diffuse(1,1,1,1) self:zoom(.5); self:sleep(.5) self:diffusealpha(0) end
ThemeHelpers.DeltaTimeTween = function(self) self:stoptweening() self:stopeffect() self:diffusealpha(1) self:zoom(1.5) self:decelerate(0.25) self:zoom(1) self:sleep(1) self:diffusealpha(0) end

-- thank you sm5 simply love (and also the fallback theme) --
ThemeHelpers.WideScale = function(AR4_3, AR16_9)
	return scale( SCREEN_WIDTH, 640, 853.333333, AR4_3, AR16_9 )
end

ThemeHelpers.Clamped_WideScale = function(AR4_3, AR16_9)
	local a = clamp(scale( SCREEN_WIDTH, 640, 853.333333, AR4_3, AR16_9 ),AR4_3,AR16_9)
	if a == AR4_3 and SCREEN_WIDTH ~= 640 then return AR16_9 else return a end
	-- why
end

ThemeHelpers.range = function(start, stop, step)
	if start == nil then return end

	if not stop then
		stop = start
		start = 1
	end

	step = step or 1

	-- if step has been explicitly provided as a positive number
	-- but the start and stop values tell us to decrement
	-- multiply step by -1 to allow decrementing to occur
	if step > 0 and start > stop then
		step = -1 * step
	end

	local t = {}
	for i = start, stop, step do
		t[#t+1] = i
	end
	return t
end

ThemeHelpers.round2 = function(num, numDP)
	return tonumber(string.format('%.' .. (numDP or 0) .. 'f', num))
end

ThemeHelpers.LocalGrades = {
	--{100.50,'!'},
	{100.00,'SSS+'},
	{99.00,'SSS'},
	{98.00,'SS+'},
	{96.00,'SS'},
	{93.00,'S+'},
	{90.00,'S'},
	{85.00,'A+'},
	{80.00,'A'},
	{75.00,'B+'},
	{70.00,'B'},
	{60.00,'C+'},
	{50.00,'C'},
	{-9e9,'D'},
}
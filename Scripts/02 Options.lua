OperatorMenuOptionRows = {}
-- wow slsm5
function offsetMS(pref, low, high,step)
	local val = PREFSMAN:GetPreference(pref)
	local ms = (val * 1000)	-- convert seconds to milliseconds
	local st = step or 1
	ms = string.format('%i',ThemeHelpers.round2(ms,0))


	-- If the player has a value set outside of the specified range
	-- accommodate by extending the range.
	low = math.min(low, ms)
	high = math.max(high, ms)

	-- _values as a temp table of values * 1000 as an intermediate step, not presented to players
	--  choices as millisecond integers with "ms" appended, presented to players
	local _values  = ThemeHelpers.range(low, high,st)
	local choices  = {}
	for i=1,#_values do
		table.insert(choices,tostring(_values[i])..'ms')
	end
	-- its not stringify?

	return {
		Name=pref,
		Choices=choices,
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		LoadSelections = function(self, list, pn)
			local i = ms - low + 1
			list[i] = true
		end,
		SaveSelections = function(self, list, pn)
			for i=1, #choices do
				if list[i] then
					PREFSMAN:SetPreference(pref, (low + i - 1) / 1000)
					break
				end
			end
		end
	}
end

OperatorMenuOptionRows.GlobalOffsetSeconds = function()
	return offsetMS('GlobalOffsetSeconds', -1000, 1000)
end

OperatorMenuOptionRows.VisualDelaySeconds = function()
	return offsetMS('VisualDelaySeconds', -1000, 1000)
end

OperatorMenuOptionRows.InputDebounceTime = function()
	return offsetMS('InputDebounceTime', 0, 100,10)
end
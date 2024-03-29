function PlayerColor( pn )
	if pn == PLAYER_1 then return "#82B4FF" end	-- blue
	if pn == PLAYER_2 then return "#FF82A0" end	-- pink that is kind of red
	return "1,1,1,1"
end

function DifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER	then return "#5FCDF5" end
	if dc == DIFFICULTY_EASY		then return "#50E650" end
	if dc == DIFFICULTY_MEDIUM		then return "#F0F064" end
	if dc == DIFFICULTY_HARD		then return "#FF5050" end
	if dc == DIFFICULTY_CHALLENGE	then return "#FA78D2" end
	if dc == DIFFICULTY_EDIT		then return "#D2D2D2" end
	return "1,1,1,1"
end

-- Get a color to show text on top of difficulty frames.
function ContrastingDifficultyColor( dc )
	-- idk
	return "0,0,0,1"
end

function JudgmentColorHarsh(jud)
	-- order is fantastic, excellent, great, decent, way off, miss
	-- harsh variant (more saturated)
	if jud == 1 then return "#32C8FA" end
	if jud == 2 then return "#FAC832" end
	if jud == 3 then return "#32FA64" end
	if jud == 4 then return "#DC78FF" end
	if jud == 5 then return "#FA8C64" end
	if jud == 6 then return "#FA4040" end
	return "#FFFFFF"
end

function JudgmentColorLight(jud)
	-- order is fantastic, excellent, great, decent, way off, miss
	-- light variant (less saturated)
	if jud == 1 then return "#96DCFA" end
	if jud == 2 then return "#FADC64" end
	if jud == 3 then return "#64FA96" end
	if jud == 4 then return "#E6A0FF" end
	if jud == 5 then return "#FAB496" end
	if jud == 6 then return "#FA7878" end
	return "#FFFFFF"
end
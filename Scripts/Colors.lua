function PlayerColor( pn )
	if pn == PLAYER_1 then return "#FBBE03" end	-- orange
	if pn == PLAYER_2 then return "#56FF48" end	-- green
	return "1,1,1,1"
end

function DifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER	then return "#D05CF6" end
	if dc == DIFFICULTY_EASY		then return "#09FF10" end
	if dc == DIFFICULTY_MEDIUM		then return "#F3F312" end
	if dc == DIFFICULTY_HARD		then return "#EA3548" end
	if dc == DIFFICULTY_CHALLENGE	then return "#16AFF3" end
	if dc == DIFFICULTY_EDIT		then return "#F7F7F7" end
	return "1,1,1,1"
end

-- Get a color to show text on top of difficulty frames.
function ContrastingDifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER	then return "#E2ABF5" end
	if dc == DIFFICULTY_EASY		then return "#B2FFB5" end
	if dc == DIFFICULTY_MEDIUM		then return "#F2F2AA" end
	if dc == DIFFICULTY_HARD		then return "#EBA4AB" end
	if dc == DIFFICULTY_CHALLENGE	then return "#AADCF2" end
	if dc == DIFFICULTY_EDIT		then return "#F7F7F7" end
	return "1,1,1,1"
end

function JudgmentColor(jud)
	-- order is fantastic, excellent, great, decent, way off, miss
	if jud == 1 then return "#32C8FA" end
	if jud == 2 then return "#FAC832" end
	if jud == 3 then return "#32FA64" end
	if jud == 4 then return "#DC78FF" end
	if jud == 5 then return "#FA8C64" end
	if jud == 6 then return "#FA3232" end
	return "1,1,1,1"
end
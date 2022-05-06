-- Override these in other themes.
function Platform() return "generic" end
function IsHomeMode() return false end

function HideTimer()
	local enabled = PREFSMAN:GetPreference("MenuTimer")
	if enabled then return "0" else return "1" end
end

function SelectButtonAvailable()
	return true
end

function GetWorkoutMenuCommand()
	GAMESTATE:SetTemporaryEventMode(true)
	return "difficulty," .. GetInitialDifficulty() .. ";screen,ScreenWorkoutMenu;PlayMode,regular;SetEnv,Workout,1"
end

function ScreenEndingGetDisplayName( pn )
	if PROFILEMAN:IsPersistentProfile(pn) then return GAMESTATE:GetPlayerDisplayName(pn) end
	return "No Card"
end

function GetCreditsText()
	local song = GAMESTATE:GetCurrentSong()
	if not song then return "" end

	return 
		song:GetDisplayFullTitle() .. "\n" ..
		song:GetDisplayArtist()
end

function StopCourseEarly()
	-- Stop gameplay between songs in Fitess: Random Endless if all players have 
	-- completed their goals.
	if not GAMESTATE:GetEnv("Workout") then return "0" end
	if GAMESTATE:GetPlayMode() ~= PLAY_MODE_ENDLESS then return "0" end
	for pn = PLAYER_1,NUM_PLAYERS-1 do
		if GAMESTATE:IsPlayerEnabled(pn) and not GAMESTATE:IsGoalComplete(pn) then return "0" end
	end
	return "1"
end

--
-- Workout
--
function WorkoutResetStageStats()
	STATSMAN:Reset()
end

function WorkoutGetProfileGoalType( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalType()
end

function WorkoutGetStageCalories( pn )
	return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetCaloriesBurned()
end

function WorkoutGetTotalCalories( pn )
	return STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn):GetCaloriesBurned()
end

function WorkoutGetTotalSeconds( pn )
	return STATSMAN:GetAccumStageStats():GetGameplaySeconds()
end

function WorkoutGetGoalCalories( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalCalories()
end

function WorkoutGetGoalSeconds( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalSeconds()
end

function WorkoutGetPercentCompleteCalories( pn )
	return WorkoutGetTotalCalories(pn) / WorkoutGetGoalCalories(pn)
end

function WorkoutGetPercentCompleteSeconds( pn )
	return WorkoutGetTotalSeconds(pn) / WorkoutGetGoalSeconds(pn)
end

--
-- Options
--
function RestoreDefaults( pn )
	if pn == PLAYER_2 then
		Trace( "skip RestoreDefaults" )
		return
	end

	--Trace( "RestoreDefaults" )
	
	PREFSMAN:SetPreference( "ControllerMode", 0 )
	PREFSMAN:SetPreference( "TwoControllerDoubles", false )
	PREFSMAN:SetPreference( "SongsPerPlay", 3 )
	PREFSMAN:SetPreference( "EventMode", false )
	PREFSMAN:SetPreference( "LifeDifficultyScale", 1 )

	local Table = PROFILEMAN:GetMachineProfile():GetSaved()
	Table["DefaultSort"] = GetDefaultSort()
	Table["DefaultDifficulty"] = GetDefaultDifficulty()

	PREFSMAN:SetPreference( "BGBrightness", .4 )
	PREFSMAN:SetPreference( "GlobalOffsetSeconds", 0 )
	PREFSMAN:SetPreference( "Autosave", true )
end

-- Home unlock (stubs):
function GetUnlockCommand() return "playcommand,NoUnlock" end
function FinalizeUnlock() end

-- Arcade unlocks:
function Unlock( Title )
	local Code = UNLOCKMAN:FindCode( Title )
	if Code then
		UNLOCKMAN:UnlockCode( Code )
	end

	-- Set the song as preferred, even if it's no longer an unlock.
	NewHelpText = {}
	local s = SONGMAN:FindSong( Title )
	if s then
		GAMESTATE:SetPreferredSong( s )
		NewHelpText[1] = "Unlocked " .. s:GetDisplayFullTitle() .. "!"
	end

	-- Get a list of steps (not songs) we just unlocked, and send a message to display
	-- them in HelpText.
	if Code then
		local Songs, Steps = UNLOCKMAN:GetStepsUnlockedByCode( Code )
		for x in Songs do
			NewHelpText[x+1] = "Unlocked " .. Songs[x]:GetDisplayFullTitle() .. " " .. DifficultyToThemedString(Steps[x]) .. "!"
		end
	end

	-- Only set the HelpText if this is actually a locked song for this game.  Don't do
	-- it if it's an old unlock code from a previous game.  (Do show it if it was already
	-- unlocked, though, so people can re-enter a code to see which steps were unlocked.)
	if Code then
		MESSAGEMAN:Broadcast( "ChangeHelpText" )
	end
	NewHelpText = nil

	-- The ITG2 menu music is much stronger than ITG1's, drowning out the unlock
	-- sounds.  Dim the music to 20% for 3 seconds while we play the unlock sound.
	-- This will stay dimmed briefly after the unlock sound plays.  That's OK; it
	-- helps emphasize the sound and prevents the music changes from being too busy.
	SOUND:DimMusic( 0.2, 3 )

	local Path = THEME:GetPath( EC_SOUNDS, '', "Unlocked " .. Title )
	SOUND:PlayOnce( Path )
end

function SetDifficultyFrameFromSteps( Actor, pn )
	--Trace( "SetDifficultyFrameFromSteps" )
	local steps = GAMESTATE:GetCurrentSteps( pn );
	if steps then 
		Actor:setstate(steps:GetDifficulty()) 
	end
end

function SetDifficultyFrameFromGameState( Actor, pn )
	--Trace( "SetDifficultyFrameFromGameState" )
	local trail = GAMESTATE:GetCurrentTrail( pn );
	if trail then 
		Actor:setstate(trail:GetDifficulty()) 
	else
		SetDifficultyFrameFromSteps( Actor, pn )
	end
end

function SetFromSongTitleAndCourseTitle( actor )
	--Trace( "SetFromSongTitleAndCourseTitle" )
	local song = GAMESTATE:GetCurrentSong();
	local course = GAMESTATE:GetCurrentCourse();
	local text = ""
	if song then
		text = song:GetDisplayFullTitle()
	end
	if course then
		text = course:GetDisplayFullTitle() .. " [".. (CourseSongIndex()+1) .."/"..ThemeHelpers.CourseStages.."] - " .. text;
	end

	actor:settext( text )
end


-- This is overridden in the PS2 theme to set the options difficulty.
function GetInitialDifficulty()
	return "beginner"
end

function DifficultyChangingIsAvailable()
	return GAMESTATE:GetPlayMode() ~= PLAY_MODE_ENDLESS and GAMESTATE:GetPlayMode() ~= PLAY_MODE_ONI and GAMESTATE:GetSortOrder() ~= SORT_MODE_MENU
end

function ModeMenuAvailable()
	if GAMESTATE:IsCourseMode() then return false end
	--Trace( "here1" )
	if GAMESTATE:GetSortOrder() == SORT_MODE_MENU then return false end
	--Trace( "here2" )
	return true
end

function GetEditStepsText()
	local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
	if steps == nil then 
		return ""
	else 
		return DifficultyToThemedString(steps:GetDifficulty())
	end
end

function GetScreenSelectStyleDefaultChoice()
	if GAMESTATE:GetNumPlayersEnabled() == 1 then return "1" else return "2" end
end

-- Wag for ScreenSelectPlayMode scroll choice3.  This should use
-- EffectMagnitude, and not a hardcoded "5".
function TweenedWag(self)
	local time = self:GetSecsIntoEffect()
	local percent = time / 4
	local rx, ry, rz
	rx,ry,rz = self:getrotation()
	rz = rz + 5 * math.sin( percent * 2 * 3.141 ) * self:getaux()
	self:rotationz( rz )
end

-- For DifficultyMeterSurvival:
function SetColorFromMeterString( self )
	local meter = self:GetText()
	if meter == "?"  then return end

	local i = (meter+0);
	local cmd;
	if i <= 1 then cmd = "Beginner"
	elseif i <= 3 then cmd = "Easy"
	elseif i <= 6 then cmd = "Regular"
	elseif i <= 9 then cmd = "Difficult"
	else cmd = "Challenge"
	end
	
	self:playcommand( "Set" .. cmd .. "Course" )
end

function GetPaneX( player )
	if GAMESTATE:PlayerUsingBothSides() then
		return SCREEN_CENTER_X
	end
	
	if player == PLAYER_1 then
		return SCREEN_CENTER_X-152
	else
		return SCREEN_CENTER_X+152
	end
end

function EvalX()
	if not GAMESTATE:PlayerUsingBothSides() then return 0 end

	local Offset = 147
	if GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then Offset = Offset * -1 end
	return Offset;
end

function EvalTweenDistance()
	local Distance = SCREEN_WIDTH/2
	if GAMESTATE:PlayerUsingBothSides() then Distance = Distance * 2 end
	return Distance
end

-- used by BGA/ScreenEvaluation overlay
-- XXX: don't lowercase commands on parse
function ActorFrame:difficultyoffset()
	if not GAMESTATE:PlayerUsingBothSides() then return end

	local XOffset = 75
	if GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then XOffset = XOffset * -1 end
	self:addx( XOffset )
	self:addy( -55 )
end

function GameState:PlayerDifficulty( pn )
	if GAMESTATE:IsCourseMode() then
		local trail = GAMESTATE:GetCurrentTrail(pn)
		return trail:GetDifficulty()
	else
		local steps = GAMESTATE:GetCurrentSteps(pn)
		return steps:GetDifficulty()
	end
end

function Get2PlayerJoinMessage()
	if not GAMESTATE:PlayersCanJoin() then return "" end
	if GAMESTATE:GetCoinMode()==COIN_MODE_FREE then return "2 Player mode available" end
	
	local numSidesNotJoined = NUM_PLAYERS - GAMESTATE:GetNumSidesJoined()
	if GAMESTATE:GetPremium() == PREMIUM_JOINT then numSidesNotJoined = numSidesNotJoined - 1 end	
	local coinsRequiredToJoinRest = numSidesNotJoined * PREFSMAN:GetPreference("CoinsPerCredit")
	local remaining = coinsRequiredToJoinRest - GAMESTATE:GetCoins();
		
	if remaining <= 0 then return "2 Player mode available" end
	
	local s = "For 2 Players, insert " .. remaining .. " more coin"
	if remaining > 1 then s = s.."s" end
	return s
end


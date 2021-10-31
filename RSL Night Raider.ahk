; NOTE FOR SETUP
; Program will set window size 

;----------------------------------------------------------------------------------------------------
; MAIN PROGRAM
;----------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------
; SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES
;----------------------------------------------------------------------------------------------------

;UpdateProgressReport:
;CampaignRun_Brutal12x3:
;DungeonRun:
;ProcessEnergyRun:
;ClanBossBattle:
;FactionRuns:
;ClassicArenaBattle:
;TagTeamArenaBattle:
;SparringLevelUp:
;CheckMarket:
;GetClassicArenaTokens:
;GetTagTeamArenaTokens:

;IncrementTimer:
;MyExitRoutine:

;----------------------------------------------------------------------------------------------------
; INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT
;----------------------------------------------------------------------------------------------------

;DungeonMapInit:
;FactionMapInit:
;NightRaidCalibrate:

;----------------------------------------------------------------------------------------------------
; FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS
;----------------------------------------------------------------------------------------------------

;RaidCommand_Send_ENTER()
;RaidCommand_Send_ESC()
;RaidCommand_Send_REPLAY()

;GetMainScreenValues(ByRef Energy, ByRef CCoins, ByRef TTCoins, ByRef Silver, ByRef Gems)

;removeMainScreenAds()
;EscapeToMainPage()

;RandomMouseClick(xPos, yPos, rVal, sVal := 3)
;LongSleep(numMinutes)
;PanScreen(x1Pos, y1Pos, x2Pos, y2Pos, numPans)
;ScrollDownScreen(xPos, yPos, numWheelDowns)

;WaitForBattleEnd(checkTime, checkFreq, quitTime, ByRef battleResult)

;OCRGetText(ByRef x_start, ByRef y_start, ByRef x_end, ByRef y_end)
;OCRGetPlusNumber(ByRef x_start, ByRef y_start, ByRef x_end, ByRef y_end)
;FindMarketText(xPos, yPos, xNeedle)
;FindClassicArenaTokens(ByRef FoundX, ByRef FoundY)
;FindTagTeamArenaTokens(ByRef FoundX, ByRef FoundY)

;MyDebugTip(Text)

;----------------------------------------------------------------------------------------------------
; WINDOW SETUP
;----------------------------------------------------------------------------------------------------

#SingleInstance force
#Persistent
SetTitleMatchMode, 2

; Get Focus
WinActivate, ahk_exe Raid.exe					; Program requires ongoing window focus
WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe
WinMove, ahk_exe Raid.exe,,X,Y,1294,700			; Set Qtr Wind size, relative to click locations
OnExit, MyExitRoutine

;----------------------------------------------------------------------------------------------------
; INITIALISATIONS
;----------------------------------------------------------------------------------------------------

; -----------------------------------------------------------
; DUNGEON MAP INITIALISATIONS
; -----------------------------------------------------------

Gosub, DungeonMapInit
Gosub, FactionMapInit

; -----------------------------------------------------------
; REPORTING INITIALISATIONS
; -----------------------------------------------------------

currentTimer = 0

numEnergyRuns = 0
numEnergyWins = 0
numEnergyLoss = 0

numClanBossBattles = 0
numSparringClicks = 0

numClassicArenaBattles = 0
numClassicArenaBattles_Won = 0
numClassicArenaBattles_Lost = 0

numTagTeamArenaBattles = 0
numTagTeamArenaBattles_Won = 0
numTagTeamArenaBattles_Lost = 0

numClassicTokenRefresh = 0
numTagTeamTokenRefresh = 0

numDoomBattles = 0

numShardsPurchased = 0
numMysteryShards = 0
numAncientShards = 0

dailyRefresh = 0
currentEnergy = 0
marketYPos := [150,270,395,515,640,610]

bClassic_NewTeamSet = 1
bTagTeam_NewTeamSet = 1

; -----------------------------------------------------------------------------------------------------
; TESTING AREA 1 - TESTING AREA 1 - TESTING AREA 1 - TESTING AREA 1 - TESTING AREA 1 - TESTING AREA 1 
; -----------------------------------------------------------------------------------------------------

; Gosub, ClassicArenaBattle
; goto, FinishEnergyRun

; LEVEL READY

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
; *** MAIN PROGRAM *** 
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

;-----------------------------------
; Gui Layout
;-----------------------------------

Gui, Add, Tab3,, Setup Run||Dungeons|Faction Wars

;-------------------------------------------------------------------------------------------------------
; TAB 1 - SETUP RUN - TAB 1 - SETUP RUN - TAB 1 - SETUP RUN - TAB 1 - SETUP RUN - TAB 1 - SETUP RUN
;-------------------------------------------------------------------------------------------------------

Gui, Add, GroupBox, x20 y30 w300 h100, Intro Runs

; CLAN BOSS @ START (1)

Gui, Add, Checkbox, vrunClanBossStart x30 y50 gClanBossStartCheck, Run Clan Boss
Gui, Add, DropDownList, x+5 y47 vclanBossStartIndex AltSubmit, Easy|Normal|Hard|Brutal|Nightmare|Ultra Nightmare||
GuiControl, Disable, clanBossStartIndex

; FACTION SELECT (2)

Gui, Add, Checkbox, x30 y75 vRunFactionWars, Run faction wars (ini file)

; DOOM TOWER (3)

Gui, Add, Checkbox, vrunDoomTower x30 y100 gDoomTowerCheck, Run Doom Tower

Gui, Add, Text, vtextSilverKeys x+16 y100, Silver Keys: 
Gui, Add, Edit, veditSilverKeys x+10 y97 w40 Limit2 Number, 10
Gui, Add, UpDown, viSilverKeys Range0-20, 10
GuiControl, Disable, textSilverKeys
GuiControl, Disable, editSilverKeys
GuiControl, Disable, iSilverKeys

; ------------------------------------------------------------------------------

Gui, Add, GroupBox, x20 y130 w300 h195, Looping Checks

; ARENA OPTIONS

Gui, Add, Checkbox, vrunClassicArena Checked x30 y150 gClassicArenaCheck, Check Classic Arena (15mins)
Gui, Add, Text, vmaxClassDiff x+5 y150, Diff:
Gui, Add, Edit, veditClassDiff x+5 y147 w30 Limit3 Number, 130
Gui, Add, Text, vincClassDiff x+10 y150, Inc:
Gui, Add, Edit, veditIncClassDiff x+3 y147 w25 Limit2 Number, 0

Gui, Add, Checkbox, vrunTagTeam Checked x30 y175 gTagTeamArenaCheck, Check Tag Team (15mins)
Gui, Add, Text, vmaxTagTeamDiff x+20 y175, Diff:
Gui, Add, Edit, veditTagTeamDiff x+5 y172 w30 Limit3 Number, 300
Gui, Add, Text, vincTagTeamDiff x+10 y175, Inc:
Gui, Add, Edit, veditIncTagTeamDiff x+3 y172 w25 Limit3 Number, 0

Gui, Add, Checkbox, vrefreshTokens x30 y200, Refresh Arena Tokens (Inbox)

; CLAN BOSS AFTER 6hrs

Gui, Add, Checkbox, vrunClanBoss x30 y225 gClanBossCheck, Check Clan Boss
Gui, Add, DropDownList, x+5 y222 vclanBossIndex AltSubmit, Easy|Normal|Hard|Brutal|Nightmare|Ultra Nightmare||
GuiControl, Disable, clanBossIndex

; DUNGEON / CAMPAIGN SELECT

/*
Dungeon Index

Case "1": dIndex_text := "Arcane Keep"
Case "2": dIndex_text := "Void Keep"
Case "3": dIndex_text := "Force Keep"
Case "4": dIndex_text := "Magic Keep"
Case "5": dIndex_text := "Spirit Keep"
Case "6": dIndex_text := "Minotaur Labyrinth"
Case "7": dIndex_text := "Ice Golems Peak"
Case "8": dIndex_text := "Dragons Lair"
Case "9": dIndex_text := "Fire Knights Castle"
Case "10": dIndex_text := "Spiders Den"
Case "11": dIndex_text := "Campaign"
default: dIndex_text := "UNKNOWN"

*/

Gui, Add, Checkbox, vbEnergyRun x30 y250, Check Dungeon/Campaign
Gui, Add, DropDownList, x185 y247 vdIndex AltSubmit, Arcane Keep||Void Keep|Force Keep|Magic Keep|Spirit Keep|Minotaur Labyrinth|Ice Golems Peak|Dragons Lair|Fire Knights Castle|Spiders Den|Campaign - 12x3 Brutal

; SPARRING PIT / MARKET OPTIONS

Gui, Add, Checkbox, vcheckSparringPit Checked x30 y275, Check Sparring Pit (20mins)
Gui, Add, Checkbox, vcheckMarketShards Checked x30 y300, Check Market Shards (1hr)

; MAIN BUTTONS

tCalText := "Calibrate (" . iCalibrateLevel . "/25)"
Gui, Add, Button, Default gOkButton x20 y335 w80, START
Gui, Add, Button, gCalibrateButton x+15 w110, %tCalText%
Gui, Add, Button, gQuitButton x+15 w80, Quit (F8)

;-------------------------------------------------------------------------------------------------------
; TAB 2 - DUNGEONS - TAB 2 - DUNGEONS - TAB 2 - DUNGEONS - TAB 2 - DUNGEONS - TAB 2 - DUNGEONS
;-------------------------------------------------------------------------------------------------------

Gui, Tab, 2

; LOAD INI VALUES

/*
dungeon_ArcaneKeep=20
dungeon_VoidKeep=20
dungeon_ForceKeep=20
dungeon_MagicKeep=20
dungeon_SpiritKeep=20
dungeon_Minotaur=15
dungeon_IceGolems=24
dungeon_DragonsLair=24
dungeon_FireKnights=25
dungeon_SpidersDen=25
dungeon_Campaign=3
*/

Gui, Add, GroupBox, x20 y30 w300 h150, Potion Keeps

Gui, Add, Text, x30 y50, Arcane Keep:
iInput := dungeonStageToRun[1]
Gui, Add, Edit, vstageArcaneKeep x100 y47 w30 Limit2 Number, %iInput%
Gui, Add, Text, x30 y75, Void Keep:
iInput := dungeonStageToRun[2]
Gui, Add, Edit, vstageVoidKeep x100 y72 w30 Limit2 Number, %iInput%
Gui, Add, Text, x30 y100, Force Keep:
iInput := dungeonStageToRun[3]
Gui, Add, Edit, vstageForceKeep x100 y97 w30 Limit2 Number, %iInput%
Gui, Add, Text, x30 y125, Magic Keep:
iInput := dungeonStageToRun[4]
Gui, Add, Edit, vstageMagicKeep x100 y122 w30 Limit2 Number, %iInput%
Gui, Add, Text, x30 y150, Spirit Keep:
iInput := dungeonStageToRun[5]
Gui, Add, Edit, vstageSpiritKeep x100 y147 w30 Limit2 Number, %iInput%

Gui, Add, GroupBox, x20 y190 w300 h150, Dungeons

Gui, Add, Text, x30 y210, Minotaur:
iInput := dungeonStageToRun[6]
Gui, Add, Edit, vstageMinotaur x100 y207 w30 Limit2 Number, %iInput%
Gui, Add, Text, x30 y235, Ice Golem:
iInput := dungeonStageToRun[7]
Gui, Add, Edit, vstageIceGolem x100 y232 w30 Limit2 Number, %iInput%
Gui, Add, Text, x30 y260, Dragons Lair:
iInput := dungeonStageToRun[8]
Gui, Add, Edit, vstageDragonsLair x100 y257 w30 Limit2 Number, %iInput%
Gui, Add, Text, x30 y285, Fire Knight:
iInput := dungeonStageToRun[9]
Gui, Add, Edit, vstageFireKnight x100 y282 w30 Limit2 Number, %iInput%
Gui, Add, Text, x30 y310, Spiders Den:
iInput := dungeonStageToRun[10]
Gui, Add, Edit, vstageSpidersDen x100 y307 w30 Limit2 Number, %iInput%


Gui, Add, Button, gSaveDungeons x20 y345 w80, SAVE TO INI

;-------------------------------------------------------------------------------------------------------
; TAB 3 - FACTION WARS - TAB 3 - FACTION WARS - TAB 3 - FACTION WARS - TAB 3 - FACTION WARS
;-------------------------------------------------------------------------------------------------------

Gui, Tab, 3

Gui, Add, Text, x30 y40, Demonspawn:
iInput := factionStageToRun[1]
Gui, Add, Edit, vStageDemonspawn x105 y37 w30 Limit2 Number, %iInput%

Gui, Add, Text, x30 y65, High Elves:
iInput := factionStageToRun[2]
Gui, Add, Edit, vStageHighElves x105 y62 w30 Limit2 Number, %iInput%

Gui, Add, Text, x30 y90, Orcs:
iInput := factionStageToRun[3]
Gui, Add, Edit, vStageOrcs x105 y87 w30 Limit2 Number, %iInput%

Gui, Add, Text, x30 y115, Sacred Order:
iInput := factionStageToRun[4]
Gui, Add, Edit, vStageSacredOrder x105 y112 w30 Limit2 Number, %iInput%

Gui, Add, Text, x30 y140, Ogryn Tribes:
iInput := factionStageToRun[5]
Gui, Add, Edit, vStageOgrynTribes x105 y137 w30 Limit2 Number, %iInput%

Gui, Add, Text, x30 y165, Dark Elves:
iInput := factionStageToRun[6]
Gui, Add, Edit, vStageDarkElves x105 y162 w30 Limit2 Number, %iInput%

Gui, Add, Text, x30 y190, Barbarians:
iInput := factionStageToRun[7]
Gui, Add, Edit, vStageBarbarians x105 y187 w30 Limit2 Number, %iInput%

;------------------

Gui, Add, Text, x170 y40, Skinwalkers:
iInput := factionStageToRun[8]
Gui, Add, Edit, vStageSkinwalkers x265 y37 w30 Limit2 Number, %iInput%

Gui, Add, Text, x170 y65, Lizardmen:
iInput := factionStageToRun[9]
Gui, Add, Edit, vStageLizardmen x265 y62 w30 Limit2 Number, %iInput%

Gui, Add, Text, x170 y90, Undead Hordes:
iInput := factionStageToRun[10]
Gui, Add, Edit, vStageUndeadHordes x265 y87 w30 Limit2 Number, %iInput%

Gui, Add, Text, x170 y115, Knights Revenant:
iInput := factionStageToRun[11]
Gui, Add, Edit, vStageKnightsRevenant x265 y112 w30 Limit2 Number, %iInput%

Gui, Add, Text, x170 y140, Banner Lords:
iInput := factionStageToRun[12]
Gui, Add, Edit, vStageBannerLords x265 y137 w30 Limit2 Number, %iInput%

Gui, Add, Text, x170 y165, Shadowkin:
iInput := factionStageToRun[13]
Gui, Add, Edit, vStageShadowkin x265 y162 w30 Limit2 Number, %iInput%

Gui, Add, Text, x170 y190, Dwarves:
iInput := factionStageToRun[14]
Gui, Add, Edit, vStageDwarves x265 y187 w30 Limit2 Number, %iInput%

Gui, Add, Button, gSaveFactions x20 y345 w80, SAVE TO INI

;-------------------------------------------------------------------------------------------------------

Gui, +AlwaysOnTop
Gui, Color, Silver
Gui, Show, AutoSize x%raidWinXPos% y%raidWinYPos%

return

;-----------------------------------
; Buttons
;-----------------------------------

; ------------------
ClanBossStartCheck:
; ------------------

Gui, Submit, NoHide

if (runClanBossStart == 1) {
	GuiControl, Enable, clanBossStartIndex
} else {
	GuiControl, Disable, clanBossStartIndex
}

return

; ------------------
DoomTowerCheck:
; ------------------

Gui, Submit, NoHide

if (runDoomTower == 1) {
	GuiControl, Enable, textSilverKeys
	GuiControl, Enable, editSilverKeys
	GuiControl, Enable, iSilverKeys
} else {
	GuiControl, Disable, textSilverKeys
	GuiControl, Disable, editSilverKeys
	GuiControl, Disable, iSilverKeys
}

return

; -------------------
ClanBossCheck:
; -------------------

Gui, Submit, NoHide

if (runClanBoss == 1) {
	GuiControl, Enable, clanBossIndex
} else {
	GuiControl, Disable, clanBossIndex
}

return

; ------------------
ClassicArenaCheck:
; ------------------

Gui, Submit, NoHide

if (runClassicArena == 1) {
	GuiControl, Enable, maxClassDiff
	GuiControl, Enable, editClassDiff
	GuiControl, Enable, incClassDiff
	GuiControl, Enable, editIncClassDiff
} else {
	GuiControl, Disable, maxClassDiff
	GuiControl, Disable, editClassDiff
	GuiControl, Disable, incClassDiff
	GuiControl, Disable, editIncClassDiff
}

return

; ------------------
TagTeamArenaCheck:
; ------------------

Gui, Submit, NoHide

if (runTagTeam == 1) {
	GuiControl, Enable, maxTagTeamDiff
	GuiControl, Enable, editTagTeamDiff
	GuiControl, Enable, incTagTeamDiff
	GuiControl, Enable, editIncTagTeamDiff
} else {
	GuiControl, Disable, maxTagTeamDiff
	GuiControl, Disable, editTagTeamDiff
	GuiControl, Disable, incTagTeamDiff
	GuiControl, Disable, editIncTagTeamDiff
}

return

; ------------------
OkButton: 
; ------------------

Gui, Submit
Gui, Destroy

; SET TIMER INCREMENT THREADS
SetTimer, IncrementTimer, 180000, 100

goto, MainBody
	
return

; ------------------
CalibrateButton:
; ------------------

Gosub, NightRaidCalibrate

Gosub, DungeonMapInit
Gosub, FactionMapInit

return

; ------------------
TickButton:
F5::
; ------------------

Gosub, IncrementTimer
return

; ------------------
PauseButton:
F6::
; ------------------

Pause
return

; ------------------
DebugListVars:
F7::
; ------------------

ListVars
return

; ------------------
QuitButton:
GuiClose:
F8::
; ------------------

Gosub, MyExitRoutine
; MyDebugTip("QuitButton")

ExitApp
return

; ------------------
SaveDungeons:
; ------------------

Gui, Submit, NoHide

Gosub, SaveDungeonsToIni

Gosub, DungeonMapInit
Gosub, FactionMapInit

return

; ------------------
SaveFactions:
; ------------------

Gui, Submit, NoHide

Gosub, SaveFactionsToIni

Gosub, DungeonMapInit
Gosub, FactionMapInit

return

; -----------------------------------------------------------
MainBody:
; -----------------------------------------------------------

; -----------------------------------------------------------
; SETUP LOG FILE
; -----------------------------------------------------------

currentTime := A_YYYY . " " . A_MM . " " . A_MMM . " " . A_DD . " " . A_Hour
debugFileName := A_ScriptDir . "\log\" . currentTime . " Night Runner Log.txt"
debugFile := FileOpen(debugFileName, "w")

if (GetMainScreenValues(currentEnergy, numClassArenaBattlesRemain, numTTArenaBattlesRemain, iStartSilver, tmp_Gems) == 1) {
	iCoinsMade = 0
}

iClassicBattleDifficultyLevel := editClassDiff
iClassicInc := editIncClassDiff
iTagTeamBattleDifficultyLevel := editTagTeamDiff
iTagTeamInc := editIncTagTeamDiff

; -----------------------------------------------------------------------------------------------------
; TESTING AREA 2 - TESTING AREA 2 - TESTING AREA 2 - TESTING AREA 2 - TESTING AREA 2 - TESTING AREA 2 
; -----------------------------------------------------------------------------------------------------

;Gosub, ClassicArenaBattle
;Gosub, TagTeamArenaBattle
;goto, FinishEnergyRun

; -----------------------------------------------------------
; SETUP ENERGY RUNS
; -----------------------------------------------------------

Switch dIndex {
Case "1": dIndex_text := "Arcane Keep"
Case "2": dIndex_text := "Void Keep"
Case "3": dIndex_text := "Force Keep"
Case "4": dIndex_text := "Magic Keep"
Case "5": dIndex_text := "Spirit Keep"
Case "6": dIndex_text := "Minotaur Labyrinth"
Case "7": dIndex_text := "Ice Golems Peak"
Case "8": dIndex_text := "Dragons Lair"
Case "9": dIndex_text := "Fire Knights Castle"
Case "10": dIndex_text := "Spiders Den"
Case "11": dIndex_text := "Campaign"
default: dIndex_text := "UNKNOWN"
}

iDStageIndex := dungeonStageToRun[dIndex]

; -----------------------------------------------------------
; INTRO REPORT
; -----------------------------------------------------------

FormatTime, TimeString,, HH:mmm

; Initialise to set boundaries for the dialog
msgBoxText = 
(
1 123456789 123456789 123456789 123456789 1234567890
2 123456789 123456789 123456789 123456789 1234567890 
3 123456789 123456789 123456789 123456789 1234567890 
4 123456789 123456789 123456789 123456789 1234567890 
5 123456789 123456789 123456789 123456789 1234567890 
6 123456789 123456789 123456789 123456789 1234567890 
7 123456789 123456789 123456789 123456789 1234567890 
8 123456789 123456789 123456789 123456789 1234567890 
9 123456789 123456789 123456789 123456789 1234567890 
10 123456789 123456789 123456789 123456789 1234567890
11 123456789 123456789 123456789 123456789 1234567890
12 123456789 123456789 123456789 123456789 1234567890
13 123456789 123456789 123456789 123456789 1234567890
14 123456789 123456789 123456789 123456789 1234567890
15 123456789 123456789 123456789 123456789 1234567890
16 123456789 123456789 123456789 123456789 1234567890
17 123456789 123456789 123456789 123456789 1234567890
18 123456789 123456789 123456789 123456789 1234567890
19 123456789 123456789 123456789 123456789 1234567890
)

currentProcessText := "MAIN LOOP       12345678901234567890"

Gui, Add, Text, vBoxText x10 y10, %msgBoxText%
Gui, Add, Button, gTickButton x10 y270, Step (F5)
Gui, Add, Button, gPauseButton x+10, Pause (F6)
Gui, Add, Button, gQuitButton x+10, Stop Run (F8)

Gui, +AlwaysOnTop
Gui, Color, Silver
; Gui, Show, w320 h330 x970 y700
Gui, Show, AutoSize x%raidWinXPos% y%raidWinYPos%

iRefreshCountdown_TT = 5
iRefreshCountdown_CA = 5
iRefreshCountdown_CB = 122
iRefreshCountdown_D := dungeonStageNumEnergy[iDStageIndex] - currentEnergy
iRefreshCountdown_SP = 5
iRefreshCountdown_MA = 20

; Setup progress report texts

tClassicArena := "ON"
if (runClassicArena == 0) {
	tClassicArena := "OFF"
}

tTagTeamArena := "ON"
if (runTagTeam == 0) {
	tTagTeamArena := "OFF"
}

tClanBoss := "OFF"
if (runClanBoss == 1) {
	tClanBoss := "ON"
}

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

;----------------------------------------------------------------------------------------------------
; INTRO RUNS - INTRO RUNS - INTRO RUNS - INTRO RUNS - INTRO RUNS - INTRO RUNS - INTRO RUNS
;----------------------------------------------------------------------------------------------------

; -----------------------------------------------------------
; CLAN BOSS BATTLE FIRST?
; -----------------------------------------------------------

if (runClanBossStart == 1) {
	iTempClanBossIndex := clanBossIndex		; Save CB index
	clanBossIndex := clanBossStartIndex
	
	Gosub, ClanBossBattle
	numClanBossBattles++
	
	clanBossIndex := iTempClanBossIndex		; Return CB Index
	
	currentProcessText:="CLICK AWAY ADS"
	Gosub, UpdateProgressReport
	removeMainScreenAds()
}

; -----------------------------------------------------------
; FACTION RUNS SECOND
; -----------------------------------------------------------

if (RunFactionWars == 1) {
	Gosub, FactionRuns
}
; -----------------------------------------------------------
; DOOM TOWER THIRD
; -----------------------------------------------------------

if (runDoomTower == 1) {
	Gosub, DoomTowerBattles
}

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
; NIGHT RUN LOOP - NIGHT RUN LOOP - NIGHT RUN LOOP - NIGHT RUN LOOP - NIGHT RUN LOOP - NIGHT RUN LOOP
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

/*

; PRIORITY
; --------

Early - Clan Boss
Early - Faction Battles

LOOP
	Arena Battle - Tag Team (6)
	Arena Battle - Classic (6)

	Clan Boss
	Energy Run (Dungeon, Campaign)

	Check Sparring Pit
	Check Market

END LOOP

*/

loop
{

;	-----------------------------------------------------------
;	ARENA BATTLES
;	-----------------------------------------------------------

	; Classic Arena, 15 mins refresh rate, 1 hr recharge token rate
	If (runClassicArena AND iRefreshCountdown_CA < 0 AND numClassArenaBattlesRemain > 0 AND currentTimer > 0) {
		Gosub, ClassicArenaBattle
		iRefreshCountdown_CA := 5
		
		currentProcessText:="CLICK AWAY ADS"
		Gosub, UpdateProgressReport
		removeMainScreenAds()
	}

	; Tag Team Arena (3x3+ mins)
	If (runTagTeam AND iRefreshCountdown_TT < 0 AND numTTArenaBattlesRemain > 0 AND currentTimer > 0) {
		Gosub, TagTeamArenaBattle
		iRefreshCountdown_TT := 5
		
		currentProcessText:="CLICK AWAY ADS"
		Gosub, UpdateProgressReport
		removeMainScreenAds()
	}
	
;	-----------------------------------------------------------
;	ARENA TOKEN REFRESH
;	-----------------------------------------------------------

	; Look for Tag Team ArenaTokens in Inbox
	if (refreshTokens == 1 AND noTagTeamTokensFound == 0 AND numTTArenaBattlesRemain == 0) {
		Gosub, GetTagTeamArenaTokens
		numTagTeamTokenRefresh++
		removeMainScreenAds()
	}

	; Look for Classic Arena Tokens in Inbox
	if (refreshTokens == 1 AND noClassicTokensFound == 0 AND numClassArenaBattlesRemain == 0) {
		Gosub, GetClassicArenaTokens
		numClassicTokenRefresh++
		removeMainScreenAds()
	}

;	-------------------------------------------------------------
;	DAILY REFRESH - DAILY REFRESH - DAILY REFRESH - DAILY REFRESH
;	-------------------------------------------------------------

	; Find UTC Time (A_NowUTC)
	FormatTime, TimeString, %A_NowUTC%, H
	if (dailyRefresh == 0 AND A_Hour == 1) {
		
		dailyRefresh = 1

		; Refresh Tag Team Tokens
		FormatTime, TimeString,, HH:mm
		debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tRefresh 10 Tag Team Tokens")
		numTTArenaBattlesRemain = 10
		
	}
	
;	-----------------------------------------------------------
;	CLAN BOSS (20 min duration)
;	-----------------------------------------------------------

	; Check for Clan Boss (every 6hrs)
	If (runClanBoss == 1 AND iRefreshCountdown_CB < 0) {
		Gosub, ClanBossBattle
		numClanBossBattles++
		runClanBoss = 0
		
		currentProcessText:="CLICK AWAY ADS"
		Gosub, UpdateProgressReport
		removeMainScreenAds()
	}
	
;	-----------------------------------------------------------
;	ENERGY RUNS (CAMPAIGN, DUNGEON)
;	-----------------------------------------------------------

	iRefreshCountdown_D := dungeonStageNumEnergy[iDStageIndex] - currentEnergy
	If (bEnergyRun == 1 AND currentEnergy >= dungeonStageNumEnergy[iDStageIndex]) {
	
;		-----------------------------------------------------------
;		DUNGEON RUN (9+ mins)
;		-----------------------------------------------------------

		; Check for Dungeon run every NumEnergy * 3mins
		If (dIndex < 11) { 
			Gosub, DungeonRun
			
			currentProcessText:="CLICK AWAY ADS"
			Gosub, UpdateProgressReport
			removeMainScreenAds()
		}

;		-----------------------------------------------------------
;		CAMPAIGN RUN - BRUTAL 12x3 (1+ min)
;		-----------------------------------------------------------

		; Check for 12x3 Campaign Run
		If (dIndex == 11) {
			Gosub, CampaignRun_Brutal12x3
			
			currentProcessText:="CLICK AWAY ADS"
			Gosub, UpdateProgressReport
			removeMainScreenAds()
		}
	
	}

;	-----------------------------------------------------------
;	SPARRING PIT (< 1 min)
;	-----------------------------------------------------------

	; Click Sparring Pit Buttons every 15mins
	if (checkSparringPit == 1 AND currentTimer > 0 AND iRefreshCountdown_SP <= 0) {
		Gosub, SparringLevelUp							; Click Sparring every 15mins
		iRefreshCountdown_SP := 5
		
		currentProcessText:="CLICK AWAY ADS"
		Gosub, UpdateProgressReport
		removeMainScreenAds()
	}

;	-----------------------------------------------------------
;	CHECK MARKET (< 1 min)
;	-----------------------------------------------------------

	; Click Market to check for shards
	if (checkMarketShards == 1 AND currentTimer > 0 AND iRefreshCountdown_MA <= 0) {
		Gosub, CheckMarket								; Check market every 1hr refresh
		iRefreshCountdown_MA := 20
		
		currentProcessText:="CLICK AWAY ADS"
		Gosub, UpdateProgressReport
		removeMainScreenAds()
	}

; -----------------------------------------------------------
; UPDATE PROGRESS REPORT
; -----------------------------------------------------------

	Gosub, UpdateMainScreenValues

	currentProcessText:="MAIN LOOP - 3 mins"
	Gosub, UpdateProgressReport
	sleep, 60000
	currentProcessText:="MAIN LOOP - 2 mins"
	Gosub, UpdateProgressReport
	sleep, 60000

	currentProcessText:="MAIN LOOP - 60 secs"
	Gosub, UpdateProgressReport
	sleep, 10000
	currentProcessText:="MAIN LOOP - 50 secs"
	Gosub, UpdateProgressReport
	sleep, 10000
	currentProcessText:="MAIN LOOP - 40 secs"
	Gosub, UpdateProgressReport
	sleep, 10000
	currentProcessText:="MAIN LOOP - 30 secs"
	Gosub, UpdateProgressReport
	sleep, 10000
	currentProcessText:="MAIN LOOP - 20 secs"
	Gosub, UpdateProgressReport
	sleep, 10000
	currentProcessText:="MAIN LOOP - 10 secs"
	Gosub, UpdateProgressReport
	sleep, 10000
	
	WinActivate, ahk_exe Raid.exe				; Keep focus on the window
	Gosub, UpdateMainScreenValues

;	-----------------------------------------------------------
;   REMOVE ADS
;	-----------------------------------------------------------

	EscapeToMainPage()
	
	currentProcessText:="CLICK AWAY ADS"
	Gosub, UpdateProgressReport
	removeMainScreenAds()
	
	currentProcessText:="MAIN LOOP"
	Gosub, UpdateProgressReport

}

FinishEnergyRun:

Gosub, MyExitRoutine

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
; SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES SUBROUTINES
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
UpdateProgressReport:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

numGameHours:=Floor(currentTimer/20)
numGameMins:=Mod(currentTimer,20) * 3

FormatTime, TimeString,, HH:mm

msgBoxText = 
(
Time= %TimeString%
currentTimer= %currentTimer% (%numGameHours%hrs %numGameMins%mins)
currentEnergy= %currentEnergy%

dIndex= %dIndex% %dIndex_text%
numEnergyRuns= %numEnergyRuns% (%numEnergyWins% won, %numEnergyLoss% lost) (c%iRefreshCountdown_D%)

numClassArenaBattlesRemain= %numClassArenaBattlesRemain% (%tClassicArena%)
numClassicBattles= %numClassicArenaBattles% (%numClassicArenaBattles_Won% won, %numClassicArenaBattles_Lost% lost, d-%iClassicBattleDifficultyLevel%/%iClassicInc%) (c%iRefreshCountdown_CA%)

numTTArenaBattlesRemain= %numTTArenaBattlesRemain% (%tTagTeamArena%)
numTagTeamBattles= %numTagTeamArenaBattles% (%numTagTeamArenaBattles_Won% won, %numTagTeamArenaBattles_Lost% lost, d-%iTagTeamBattleDifficultyLevel%/%iTagTeamInc%) (c%iRefreshCountdown_TT%)

numClanBossBattles= %numClanBossBattles% (%tClanBoss%) (c%iRefreshCountdown_CB%)

numSparringClicks= %numSparringClicks% (c%iRefreshCountdown_SP%)
numShardsPurchased= %numMysteryShards%M, %numAncientShards%A (c%iRefreshCountdown_MA%)

Current Process: %currentProcessText%
)

GuiControl, Text, BoxText, %msgBoxText%

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
UpdateMainScreenValues:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

if (GetMainScreenValues(currentEnergy, numClassArenaBattlesRemain, numTTArenaBattlesRemain, iCurrentSilver, tmp_Gems) == 1) {
	iCoinsMade := iCurrentSilver - iStartSilver
}

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
UpdateDungeonIndexText:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

Switch dIndex {
	Case "1": dIndex_text := "Arcane Keep"
	Case "2": dIndex_text := "Void Keep"
	Case "3": dIndex_text := "Force Keep"
	Case "4": dIndex_text := "Magic Keep"
	Case "5": dIndex_text := "Spirit Keep"
	Case "6": dIndex_text := "Minotaur Labyrinth"
	Case "7": dIndex_text := "Ice Golems Peak"
	Case "8": dIndex_text := "Dragons Lair"
	Case "9": dIndex_text := "Fire Knights Castle"
	Case "10": dIndex_text := "Spiders Den"
	Case "11": dIndex_text := "Campaign"
	Case "12": dIndex_text := "Daily Boss"
	Case "13": dIndex_text := "Daily Campaign"
	default: dIndex_text := "UNKNOWN"
}

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
CampaignRun_Brutal12x3:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

FormatTime, TimeString,, HH:mm
debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tCampaign Run`t" . numCampaignRuns)
currentProcessText:="CAMPAIGN RUN - BRUTAL 12x3"
Gosub, UpdateProgressReport

; Enter Campaign Mode
RaidCommand_Send_ENTER()

sleep, 5000

RandomMouseClick(155, 370, 10, 5)	; Campaign Mode select
RandomMouseClick(160, 635, 10)		; Select Difficulty
RandomMouseClick(160, 510, 10)		; Select Brutal Difficulty

; Scroll to right boundary
PanScreen(1200,500,70,500,dungeonPanScreen[dIndex])

; Click on Brimstone Path Campaign Level 12, Stage 3
RandomMouseClick(dungeonXpos[dIndex], dungeonYpos[dIndex], 10)		; Campaign Level select
RandomMouseClick(1150, dungeonStageYPos[iDStageIndex], 10)			; Campaign Level 3 select

;-------------------------------------------------------------------------

goto, ProcessEnergyRun

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
DungeonRun:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

FormatTime, TimeString,, HH:mm
debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tDungeon Run`t" . numDungeonRuns . "`t" . dIndex_text)
currentProcessText:="DUNGEON RUN"
Gosub, UpdateProgressReport

; Enter Dungeon
RaidCommand_Send_ENTER()

sleep, 5000

RandomMouseClick(420, 370, 10, 5)		; Dungeon Main select
PanScreen(1200,560,70,560,dungeonPanScreen[dIndex])		; 0 - Potions, 1 - Dungeons

/*
Dungeon Index

Case "1": dIndex_text := "Arcane Keep"
Case "2": dIndex_text := "Void Keep"
Case "3": dIndex_text := "Force Keep"
Case "4": dIndex_text := "Magic Keep"
Case "5": dIndex_text := "Spirit Keep"
Case "6": dIndex_text := "Minotaur Labyrinth"
Case "7": dIndex_text := "Ice Golems Peak"
Case "8": dIndex_text := "Dragons Lair"
Case "9": dIndex_text := "Fire Knights Castle"
Case "10": dIndex_text := "Spiders Den"
Case "11": dIndex_text := "Campaign"
default: dIndex_text := "UNKNOWN"

*/

; MsgBox The dungeon pos is x %dungeonXpos[dIndex]% y %dungeonYpos[dIndex]%.
RandomMouseClick(dungeonXpos[dIndex], dungeonYpos[dIndex], 10)	; Dungeon Main select

ScrollDownScreen(515, 590, dungeonStageWheelDowns[iDStageIndex])	; Scroll down to desired level

; Click Battle and start buttons
RandomMouseClick(1150, dungeonStageYPos[iDStageIndex], 10)	; Battle Stage Select

;----------------------------------------------------------------

ProcessEnergyRun:

maxBattleTime := dungeonBattleTimeMins[dIndex] * 60
currentBattleTime := 0

RandomMouseClick(1140, 630, 10)					; Start Battle button
numEnergyRuns++ 
currentEnergy -= dungeonStageNumEnergy[iDStageIndex]

loop {
	
	Gosub, UpdateProgressReport

	FormatTime, TimeString,, HH:mm
	debugFile.Write(TimeString . "`t" . currentTimer . "`t`tEnergy " . currentEnergy)
	
	currentBattleTime := WaitForBattleEnd(20, 20, maxBattleTime, battleResult)
		
	if (battleResult > 0) {
			
		numEnergyWins++
		debugFile.WriteLine(" - VICTORY (" . currentBattleTime . " secs)")
		
	} else if (battleResult < 0) {
			
		numEnergyLoss++
		debugFile.WriteLine("- DEFEAT (" . currentBattleTime . " secs)")
	
	} else {
		
		numEnergyLoss++
		debugFile.WriteLine("- TIMEOUT (" . currentBattleTime . " secs)")
		
	}
	
	if (currentEnergy >= dungeonStageNumEnergy[iDStageIndex]) {
		RaidCommand_Send_REPLAY()			; Spam r key to repeat battle
		numEnergyRuns++
		currentEnergy -= dungeonStageNumEnergy[iDStageIndex]
	} else {
		goto, finishDungeonBattle
	}

}

finishDungeonBattle:

debugFile.WriteLine()

; Exit Dungeon (1 ESCAPE)
EscapeToMainPage()

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
FactionRuns:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

; MsgBox, 0, Debug Message, "factionXpos %tempTextX% %tempTextY%", 60
; MsgBox, 0, Debug Message, "numFactBattles %fIndex% %numFactBattles%", 10

FormatTime, TimeString,, HH:mm
debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tFaction Wars")
currentProcessText:="FACTION WARS"
Gosub, UpdateProgressReport

; Enter Faction
RaidCommand_Send_ENTER()

sleep, 5000

RandomMouseClick(680, 370, 10, 3)		; Faction Main select

loop, 14
{
	fIndex := A_Index
	
	if (fIndex == 8) {
		
		PanScreen(1200,500,70,500,-1)
		sleep, 5000

	} else if (fIndex == 12) {
		
		PanScreen(1200,500,70,500,2)
		sleep, 5000

	}
	
	xPos := factionXpos[fIndex]
	yPos := factionYpos[fIndex]
	RandomMouseClick(xPos, yPos, 10, 3)	; Faction select
	
	tGlyphText := OCRGetText(90,110, 220,132)
	if (pos:=InStr(tGlyphText,"GLYPH")) {
	
		iFStageIndex := factionStageToRun[fIndex]
		factKeysNeeded := factionStageNumKeys[iFStageIndex]

		; Check for enough keys
		factNumKeys := OCRGetPlusNumber(750,40,800,70)
		
		if (factNumKeys < factKeysNeeded) {
			RaidCommand_Send_ESC()		; ESC back to map
			sleep, 2000
			continue
		}

		; Setup Text
		Switch fIndex {
			Case "1": dFaction_text := "Demonspawn"
			Case "2": dFaction_text := "High Elves"
			Case "3": dFaction_text := "Banner Lords"
			Case "4": dFaction_text := "Orcs"
			Case "5": dFaction_text := "The Sacred Order"
			Case "6": dFaction_text := "Ogryn Tribes"
			Case "7": dFaction_text := "Dark Elves"
			Case "8": dFaction_text := "Barbarians"
			Case "9": dFaction_text := "Skinwalkers"
			Case "10": dFaction_text := "Lizardmen"
			Case "11": dFaction_text := "Undead Hordes"
			Case "12": dFaction_text := "Knight Revenant"
			Case "14": dFaction_text := "Dwarves"
			default: dFaction_text := "UNKNOWN"
		}

		ScrollDownScreen(515, 590, factionStageWheelDowns[iFStageIndex])		; Scroll down to desired level
		
		; Click Battle and start buttons
		RandomMouseClick(1150, factionStageYPos[iFStageIndex], 10)	; Battle Stage Select

		; CALCULATE NUMBER OF ITERATIONS
		numFactBattles := factNumKeys // factKeysNeeded
		
		RandomMouseClick(1150, 630, 10)							; START BATTLE - defaults to autobattle
		maxBattleTime := factionBattleTimeMins[fIndex] * 60
		
		FormatTime, TimeString,, HH:mm
		debugFile.WriteLine()
		debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tFaction War - START`t" . dFaction_text)

		while (numFactBattles > 0) {
			
			FormatTime, TimeString,, HH:mm
			debugFile.Write(TimeString . "`t" . currentTimer . "`t")
			
			if (battleDuration := WaitForBattleEnd(20, 20, maxBattleTime, battleResult)) {
				if (battleResult == 1) {
					debugFile.WriteLine("Faction War Battle - VICTORY (" . battleDuration . " secs)")
				} else {
					debugFile.WriteLine("Faction War Battle - DEFEAT (" . battleDuration . " secs)")
				}
			} else {
				debugFile.WriteLine("Faction War Battle - TIMEOUT (" . battleDuration . " secs)")
			}

			numFactBattles--
			
			if (numFactBattles > 0) {
				ControlSend, , r, ahk_exe Raid.exe			; repeat until keys fully delpeted
			}
		
		}
		
		; Escape back to Map, at location where it was left
		RaidCommand_Send_ESC()		; ESC button
		sleep, 2000
		RaidCommand_Send_ESC()		; ESC button
		sleep, 2000
		
		; Move from centre
		if (fIndex >= 8 AND fIndex < 12) {
			PanScreen(1200,500,70,500,-1)
			sleep, 5000
		} else if (fIndex >= 12) {
			PanScreen(1200,500,70,500,1)
			sleep, 5000
		}
		
	}

}

; Exit Faction War
EscapeToMainPage()

currentProcessText:="CLICK AWAY ADS"
Gosub, UpdateProgressReport
removeMainScreenAds()

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
DoomTowerBattles:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

FormatTime, TimeString,, HH:mm
debugFile.Write(TimeString . "`tDoom Tower - ")
currentProcessText:="DOOM TOWER"
Gosub, UpdateProgressReport

RaidCommand_Send_ENTER()
sleep, 5000

; SELECT DOOM TOWER

ScrollDownScreen(600,400,-20)		; Use mouse wheel to scroll right

RandomMouseClick(1150, 400, 10)		; Click On Doom Tower Panel
Gosub, UpdateProgressReport

sleep, 5000							; Give it time to pan up (Difficulty remains the same)

;--------------------------------------
; PROCESS SILVER KEYS - BOSS BATTLES
;--------------------------------------

if (iSilverKeys > 0) {
	
	; Find Doom boss Icon
	
	yDoomPos = 450
	
	loop {
		
		RandomMouseClick(1015, yDoomPos, 10)			; Select Location for Boss Battle
		
		tFloorText := OCRGetText(10,35, 460,70)
		pos := InStr(tFloorText,"Floor")
		yDoomPos -= 20
	
	} until (pos > 0 OR yDoomPos < 200)
	
	if (yDoomPos < 200) {
		goto, DoomFinishBattle					; Could not find Doom Boss Battle?
	}
	
	tShortString := SubStr(tFloorText,1,30)
	debugFile.WriteLine(tShortString)			; Write out the Boss Floor and Type
	
	; Click on Boss, Will assume Champions are alread selected. First time will not work
	
	RandomMouseClick(1140, 630, 10)				; Doom Tower START button (Assumes default Auto?)

StartDoomBossBattle:

	iSilverKeys--
	numDoomBattles++
	
	currentProcessText:="DOOM TOWER BOSS (" . numDoomBattles . ")"
	Gosub, UpdateProgressReport
	
;	MyDebugTip("doom iSilverKeys " . iSilverKeys)
	FormatTime, TimeString,, HH:mm
	debugFile.Write(TimeString . "`t")
	
	WaitForBattleEnd(60, 20, 540, battleResult)
	
	if (battleResult > 0) {
	
		debugFile.WriteLine("Doom Boss Battle(" . iSilverKeys . ") - VICTORY (" . battleDuration . ")")
			
	} else if (battleResult < 0) {
			
		debugFile.WriteLine("Doom Boss Battle(" . iSilverKeys . ") - DEFEAT (" . battleDuration . ")")
		goto, DoomFinishBattle
			
	} else {
		
		debugFile.WriteLine("Doom Boss Battle(" . iSilverKeys . ") - TIMEOUT (" . battleDuration . ")")
		goto, DoomFinishBattle

	}
	
	if (iSilverKeys > 0) {
		
		RaidCommand_Send_REPLAY()			; Spam r key to repeat battle
		goto, StartDoomBossBattle
		
	}

}

DoomFinishBattle:

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

; MyDebugTip("doomFinishBattle " . numDoomBattles)
; sleep, 2000

EscapeToMainPage()

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
ClassicArenaBattle:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

FormatTime, TimeString,, HH:mm
debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tClassic Arena(" . numClassArenaBattlesRemain . " coins)")
currentProcessText:="CLASSIC ARENA BATTLE"
Gosub, UpdateProgressReport

; Enter Arena
RaidCommand_Send_ENTER()

sleep, 5000

RandomMouseClick(950, 370, 10, 5)	; Arena select
RandomMouseClick(450, 350, 30, 4)	; Classic Arena Shield

FormatTime, TimeString,, HH:mm

bClassic_InstanceBattle = 0

if (bClassic_NewTeamSet == 1) {
	
	;MyDebugTip("bClassic_NewTeamSet")
	;Pause

	bClassic_NewTeamSet = 0		; Toggles New Team
	bClassic_SetBattle = 0		; Has this set run a battle < max difficulty
	iClassic_Ptr = 1			; Index of next battle 1-4, 5=finish
	iClassicYPos = 275			; YPos of next battle: 390, 505, 620 (115 apart?)
	
	debugFile.WriteLine(TimeString . "`t`tInitNewSeries: Classic Arena")

}

debugFile.Write(TimeString . "`t`tTeam Power: ")

; --------------------------------------------------------
ClassicArena_Select_Team:
; --------------------------------------------------------

;MyDebugTip("Select_Team, iClassic_Ptr: " . iClassic_Ptr . ", YPos= " . iClassicYPos)
;Pause

; ---------------------------------
; Check for available Battle Button
; ---------------------------------

y_start := iClassicYPos - 20
y_end := iClassicYPos + 20
tBattleText := OCRGetText(1070,y_start, 1155,y_end)
if (pos:=InStr(tBattleText,"Battle") == 0) {
	goto, ClassicArena_Increment_Team
}

; Click on next battle
RandomMouseClick(1150, iClassicYPos, 5, 10)			; Click on Team

;------------------------------------------------------------------------------------------------------

		;---------------------------------------
		ClassicArena_Team_CheckBattleDifficulty:
		;---------------------------------------

		iClassicTeamPower := OCRGetPlusNumber(950,420, 1150,445)

		if (iClassicTeamPower > 1000) {
			iClassicTeamPower := Floor(iClassicTeamPower/1000)
		}
		
		;MyDebugTip("Opposing Power = " . iClassicTeamPower . " iDiff = " . iClassicBattleDifficultyLevel)
		;sleep, 2000
		;Pause
		
		debugFile.Write(iClassicTeamPower . "(" . iClassic_Ptr . "), ")

		;------------------------------
		ClassicArena_Team_Select_Battle:
		;------------------------------
		
		if (iClassicTeamPower <= iClassicBattleDifficultyLevel) {
			
			FormatTime, TimeString,, HH:mm
			debugFile.WriteLine()							; Close off Power(Ptr) list
			
			RandomMouseClick(1140, 630, 10, 10)				; Click start battle (existing selection)
			numClassArenaBattlesRemain--
			numClassicArenaBattles++
			
			Gosub, UpdateProgressReport
			
			bClassic_InstanceBattle = 1
			bClassic_SetBattle = 1							; Found battle within difficulty

			WaitForBattleEnd(10, 10, 180, battleResult)

			if (battleResult > 0) {
					
				MyDebugTip("Classic Arena - Victory")
				debugFile.WriteLine(TimeString . "`t`tClassic Arena: " . iClassicTeamPower . " - Victory")
				numClassicArenaBattles_Won++
					
			} else if (battleResult < 0) {
					
				MyDebugTip("Classic Arena - Defeat")
				debugFile.WriteLine(TimeString . "`t`tClassic Arena " . iClassicTeamPower . " - Defeat")
				numClassicArenaBattles_Lost++
					
			} else {	; Battle Timed Out
				
				MyDebugTip("Classic Arena - TimeOut")
				debugFile.WriteLine(TimeString . "`t`tClassic Arena " . iClassicTeamPower . " - Timeout")
				numClassicArenaBattles_Lost++
				
				RaidCommand_Send_ESC()	; ESC button
				sleep, 5000
				
				RandomMouseClick(510, 360, 10)				; Click for Leave Battle in case neverending battle
				RandomMouseClick(780, 395, 10)				; Confirm Leave Battle in case neverending battle, Defeat
			
			}
			
			if (numClassArenaBattlesRemain > 0 AND iClassic_Ptr < 4) {
				debugFile.Write(TimeString . "`t`tTeam Power: ")		; Continue line of Power values
			}

			
		}	; End of Within difficulty match
		
		;------------------------------------------------------------------
		; Exit out of Team view 
		;------------------------------------------------------------------

		RaidCommand_Send_ESC()	; ESC button back to multi team view
		sleep, 5000

;-----------------------------------------------------------
ClassicArena_Increment_Team:
;-----------------------------------------------------------

iClassicYPos += 115
iClassic_Ptr++

FormatTime, TimeString,, HH:mm

;MyDebugTip("iClassic_Ptr++: " . iClassic_Ptr . ", numRemain: " . numClassArenaBattlesRemain)
;Pause

;------------------------------------------------------------------------------------------------------

if (iClassic_Ptr > 4) {
	
	if (bClassic_SetBattle == 0 AND iClassicInc > 0) {
		debugFile.Write(TimeString . "`t`tIncrease Max Difficulty: " . iClassicBattleDifficultyLevel . " + " . iClassicInc . " = ")
		iClassicBattleDifficultyLevel += iClassicInc	; Steadily increase difficulty
		debugFile.WriteLine(iClassicBattleDifficultyLevel)
	}
	
}

if (numClassArenaBattlesRemain > 0) {
	
	if (iClassic_Ptr <= 4) {
		
		goto, ClassicArena_Select_Team
		
	} else {
		
		goto, ClassicArena_RefreshList
		
	}
		
} else if (numClassArenaBattlesRemain == 0) {
	
	if (iClassic_Ptr <= 4) {

		goto, ClassicArena_BattleFinish
		
	} else {
		
		goto, ClassicArena_RefreshList
		
	}
	
}

; --------------------------------------------------------
ClassicArena_RefreshList:
; --------------------------------------------------------

;MyDebugTip("RefreshList")
;Pause

if (bClassic_InstanceBattle == 0) {
	debugFile.WriteLine()
}

debugFile.WriteLine(TimeString . "`t`tClassic Arena Refresh")

; If it gets here there are no more viable teams - reset and jump out

RandomMouseClick(1150, 175, 5, 5)	; Click Refresh List (15min cooldown)

bClassic_NewTeamSet = 1

; --------------------------------------------------------
ClassicArena_BattleFinish:
; --------------------------------------------------------

if (bClassic_SetBattle == 0) {
	debugFile.WriteLine()
}

EscapeToMainPage()

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
TagTeamArenaBattle:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

FormatTime, TimeString,, HH:mm
debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tTag Team Arena(" . numTTArenaBattlesRemain . " coins)")
currentProcessText:="TAG TEAM ARENA BATTLE"
Gosub, UpdateProgressReport

; Enter Arena
RaidCommand_Send_ENTER()
sleep, 5000

RandomMouseClick(950, 370, 10, 5)		; Arena select
RandomMouseClick(850, 300, 30, 4)		; Tag Team Arena Shield

FormatTime, TimeString,, HH:mm

bTagTeam_InstanceBattle = 0				; Flag for if this instance ran a battle

if (bTagTeam_NewTeamSet == 1) {

	;MyDebugTip("bTagTeam_NewTeamSet")
	;Pause

	bTagTeam_NewTeamSet = 0
	bTagTeam_SetBattle = 0
	iTagTeam_Ptr = 1
	iTagTeamYPos = 270	; 395, 520, 645 (125 apart?)
	
	debugFile.WriteLine(TimeString . "`t`tInitNewSeries: Tag Team Arena")

}

debugFile.Write(TimeString . "`t`tTeam Power: ")

;-----------------------------------------------------------
TagTeamArena_Select_Team:
;-----------------------------------------------------------

;MyDebugTip("Select_Team, iTagTeam_Ptr: " . iTagTeam_Ptr . ", YPos= " . iTagTeamYPos)
;Pause

; ---------------------------------
; Check for available Battle Button
; ---------------------------------

y_start := iTagTeamYPos - 20
y_end := iTagTeamYPos + 20
tBattleText := OCRGetText(1070,y_start, 1155,y_end)
if (pos:=InStr(tBattleText,"Battle") == 0) {
	goto, TagTeamArena_Increment_Team
}

RandomMouseClick(1150, iTagTeamYPos, 5, 10)		; Click on Team

		;---------------------------------------
		TagTeamArena_Team_CheckBattleDifficulty:
		;---------------------------------------

		iTagTeamTotalPower := OCRGetPlusNumber(950,420, 1150,445)
		
		if (iTagTeamTotalPower > 1000) {
			iTagTeamTotalPower := Floor(iTagTeamTotalPower/1000)
		}
		
		;MyDebugTip("Opposing Power = " . iTagTeamTotalPower . " iDiff = " . iTagTeamBattleDifficultyLevel)
		;sleep, 2000
		;Pause
		
		debugFile.Write(iTagTeamTotalPower . "(" . iTagTeam_Ptr . "), ")

		;------------------------------
		TagTeamArena_Team_SelectBattle:
		;------------------------------

		if (iTagTeamTotalPower <= iTagTeamBattleDifficultyLevel) {
			
			debugFile.WriteLine()
			debugFile.Write(TimeString . "`t`tTag Team Arena: " . iTagTeamTotalPower)

			; Assume Auto is clicked ON

			RandomMouseClick(1140, 630, 10)			; Click start battle (existing selection)
			numTTArenaBattlesRemain--
			numTagTeamArenaBattles++
			
			Gosub, UpdateProgressReport
			
			bTagTeam_SetBattle = 1
			bTagTeam_InstanceBattle = 1

			WaitForBattleEnd(40, 10, 540, battleResult)		; Check for overtime battle
			
			if (battleResult > 0) {
				
				MyDebugTip("TagTeam Arena - Victory")
				debugFile.WriteLine(" - Victory")
				numTagTeamArenaBattles_Won++
				
			} else if (battleResult < 0) {
				
				MyDebugTip("TagTeam Arena - Defeat")
				debugFile.WriteLine(" - Defeat")
				numTagTeamArenaBattles_Lost++
				
			} else {
			
				MyDebugTip("TagTeam Arena - TimeOut")
				debugFile.WriteLine(" - TimeOut")
				numTagTeamArenaBattles_Lost++
				
				RaidCommand_Send_ESC()	; ESC button, during battle
				sleep, 10000
				
				RandomMouseClick(650, 360, 10, 4)			; Click for Quit Series in case neverending battle
				RandomMouseClick(780, 410, 10, 4)			; Confirm Leave Battle in case neverending battle

			}
			
			RaidCommand_Send_ESC()	; ESC button out of Battle Results
			sleep, 2000
			
			if (numTTArenaBattlesRemain > 0 AND iTagTeam_Ptr < 4) {
				debugFile.Write(TimeString . "`t`tTeam Power: ")
			}
			
		}	; End of Within difficulty match

		;------------------------------------------------------------------
		; Exit out to Team view 
		;------------------------------------------------------------------

		RaidCommand_Send_ESC()	; ESC button
		sleep, 2000

;-----------------------------------------------------------
TagTeamArena_Increment_Team:
;-----------------------------------------------------------
	
iTagTeam_Ptr++
iTagTeamYPos += 125

;MyDebugTip("iTagTeam_Ptr++: " . iTagTeam_Ptr . ", numRemain: " . numTTArenaBattlesRemain)
;Pause

FormatTime, TimeString,, HH:mm

;------------------------------------------------------------------------------------------------------

; Check if weve processed 4 teams
if (iTagTeam_Ptr > 4) {
	
	if (bTagTeam_SetBattle == 0 AND iTagTeamInc > 0) {
		debugFile.Write(TimeString . "`t`tIncrease Max Difficulty: " . iTagTeamBattleDifficultyLevel . " + " . iTagTeamInc . " = ")
		iTagTeamBattleDifficultyLevel += iTagTeamInc	; Steadily increase difficulty
		debugFile.WriteLine(iTagTeamBattleDifficultyLevel)
	}
	
}

if (numTTArenaBattlesRemain > 0) {
	
	if (iTagTeam_Ptr <= 4) {

		goto, TagTeamArena_Select_Team
		
	} else {
		
		goto, TagTeamArena_RefreshList
		
	}
		
} else if (numTTArenaBattlesRemain == 0) {
	
	if (iTagTeam_Ptr <= 4) {

		goto, TagTeamArena_BattleFinish
		
	} else {
		
		goto, TagTeamArena_RefreshList
		
	}
	
}

; --------------------------------------------------------
TagTeamArena_RefreshList:
; --------------------------------------------------------

; If it gets here there are no more viable teams - Refresh and jump out
;MyDebugTip("RefreshList")
;Pause

if (bTagTeam_InstanceBattle == 0) {
	debugFile.WriteLine()			; This will close of the Team Power String
}
	
debugFile.WriteLine(TimeString . "`t`tTag Team Arena Refresh")

RandomMouseClick(1150, 175, 5, 5)		; Click Refresh List (15min cooldown)

bTagTeam_NewTeamSet = 1

; --------------------------------------------------------
TagTeamArena_BattleFinish:
; --------------------------------------------------------

if (bTagTeam_SetBattle == 0) {
	debugFile.WriteLine()
}

EscapeToMainPage()

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
ClanBossBattle:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

FormatTime, TimeString,, HH:mm
debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tClan Boss")
currentProcessText:="CLAN BOSS"
Gosub, UpdateProgressReport

; Enter Clan Boss
RaidCommand_Send_ENTER()
sleep, 5000

RandomMouseClick(1210, 370, 10, 5)			; Clan Boss select
Gosub, UpdateProgressReport

if (clanBossIndex >= 4) {
	; Scroll down to bottom
	loop {
		ScrollDownScreen(1140, 420, 1)		; SCROLL DOWN VARIABLE (XXX)
		tTextCopy := OCRGetText(890,480, 1040,507)
	} until (pos := InStr(tTextCopy,"Ultra"))
}

; Click Difficulty Button
if (clanBossIndex == 1) {
	RandomMouseClick(1140, 180, 10)  		; Select Easy Battle
} else if (clanBossIndex == 2) {
	RandomMouseClick(1140, 300, 10)  		; Select Normal Battle
} else if (clanBossIndex == 3) {
	RandomMouseClick(1140, 420, 10)  		; Select Hard Battle
} else if (clanBossIndex == 4) {
	RandomMouseClick(1140, 270, 10)  		; Select Brutal Battle
} else if (clanBossIndex == 5) {
	RandomMouseClick(1140, 400, 10)  		; Select Nightmare Battle
} else if (clanBossIndex == 6) {
	RandomMouseClick(1140, 520, 10)  		; Select Ultra Nightmare Battle
} else {
	goto, finishClanBossBattle
}

RandomMouseClick(1140, 640, 10)  		; Clan Boss battle button
RandomMouseClick(1140, 640, 10)  		; Accept no aura champion button (If needed)
RandomMouseClick(1140, 630, 10)			; Clan Boss battle start button

; Nightmare Unkillable Setup

WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

StartTime := A_TickCount				; Record start time, pc timer
LongSleep(15)

loop {
	
	LongSleep(1)

	tTextCopy := OCRGetText(560,90, 720,145)
	pos := InStr(tTextCopy,"RESULT")
	
	ElapsedTime := A_TickCount - StartTime			; Current time - start time
	
} until (pos > 0 OR ElapsedTime > 1500000)			; 25 mins elapsed

finishClanBossBattle:

; Exit Dungeon
EscapeToMainPage()

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
SparringLevelUp:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

FormatTime, TimeString,, HH:mm
debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tCheck Sparring Pit")
currentProcessText:="SPARRING LEVEL UP"
Gosub, UpdateProgressReport

WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

FormatTime, TimeString,, HH:mm

; Enter sparring pit

RandomMouseClick(900, 430, 10)

tChampLevel := OCRGetText(55,102, 225,130)
if (pos:=InStr(tChampLevel,"READY")) {
	RandomMouseClick(140, 525, 10, 4)	; Level Up!
	debugFile.WriteLine(TimeString . "`t" . currentTimer . "`t`tLevel Up(1)")
	numSparringClicks++
	RandomMouseClick(25, 620, 4)		; Cancel where no level up
}

tChampLevel := OCRGetText(302,102, 474,130)
if (pos:=InStr(tChampLevel,"READY")) {
	RandomMouseClick(400, 525, 10, 4)	; Level Up!
	debugFile.WriteLine(TimeString . "`t" . currentTimer . "`t`tLevel Up(2)")
	numSparringClicks++
	RandomMouseClick(25, 620, 4)		; Cancel where no level up
}

tChampLevel := OCRGetText(555,102, 727,130)
if (pos:=InStr(tChampLevel,"READY")) {
	RandomMouseClick(650, 525, 10, 4)	; Level Up!
	debugFile.WriteLine(TimeString . "`t" . currentTimer . "`t`tLevel Up(3)")
	numSparringClicks++
	RandomMouseClick(25, 620, 4)		; Cancel where no level up
}

tChampLevel := OCRGetText(806,102, 977,130)
if (pos:=InStr(tChampLevel,"READY")) {
	RandomMouseClick(900, 525, 10, 4)	; Level Up!
	debugFile.WriteLine(TimeString . "`t" . currentTimer . "`t`tLevel Up(4)")
	numSparringClicks++
	RandomMouseClick(25, 620, 4)		; Cancel where no level up
}

tChampLevel := OCRGetText(1058,102, 1227,130)
if (pos:=InStr(tChampLevel,"READY")) {
	RandomMouseClick(1150, 525, 10, 4)	; Level Up!
	debugFile.WriteLine(TimeString . "`t" . currentTimer . "`t`tLevel Up(5)")
	numSparringClicks++
	RandomMouseClick(25, 620, 4)		; Cancel where no level up
}

debugFile.WriteLine()

; Exit sparring pit (1 ESCAPE)
EscapeToMainPage()

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
CheckMarket:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

FormatTime, TimeString,, HH:mm
debugFile.WriteLine(TimeString . "`t" . currentTimer . "`tCheck Market")
currentProcessText:="CHECK MARKET"
Gosub, UpdateProgressReport

WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

; Enter Market
RandomMouseClick(470, 550, 10)

;--------------------------------------------------------------------
SetMarketText_1:
;--------------------------------------------------------------------

loop, 5 {

	iA := A_Index

; Column 1

	MouseMove, 180, marketYPos[iA]
	
	tHayStack := GetMarketText(180, marketYPos[iA])
	
	if (InStr(tHayStack,"Mystery")) {
		RandomMouseClick(435, marketYPos[iA], 5)		; Click on buy icon
		RandomMouseClick(790, 465, 5)					; Click on Mystery Shard confirm buy
		numMysteryShards++
		numShardsPurchased++
		FormatTime, TimeString,, HH:mm
		debugFile.WriteLine(TimeString . "`t`tMystery Shard!")
	
	} else if (InStr(tHayStack,"Ancient")) {
		RandomMouseClick(435, marketYPos[iA], 5)		; Click on buy icon
		RandomMouseClick(790, 465, 5)				; Click on Ancient Shard confirm buy
		numAncientShards++
		numShardsPurchased++
		FormatTime, TimeString,, HH:mm
		debugFile.WriteLine(TimeString . "`t`tAncient Shard!")
	
/*	} else if (	(xPos := InStr(tHayStack,"Preacher")) OR (yPos := InStr(tHayStack,"Lurker")) OR (zPos := InStr(tHayStack,"Magekiller")) ) {
		RandomMouseClick(435, marketYPos[iA], 5)		; Click on buy icon
		RandomMouseClick(150, 635, 5)					; Click on Champion confirm buy
		numChampionsAqd++
		FormatTime, TimeString,, HH:mm
		debugFile.WriteLine(TimeString . "`t`t" . xText . "!")
		RaidCommand_Send_ESC()							; ESC button
		sleep, 2000
*/	}

;	sleep, 1000

; Column 2

	MouseMove, 620, marketYPos[iA]
	
	tHayStack := GetMarketText(620, marketYPos[iA])
	
	if (InStr(tHayStack,"Mystery")) {
		RandomMouseClick(875, marketYPos[iA], 5)		; Click on buy icon
		RandomMouseClick(790, 465, 5)					; Click on Mystery Shard confirm buy
		numMysteryShards++
		numShardsPurchased++
		FormatTime, TimeString,, HH:mm
		debugFile.WriteLine(TimeString . "`t`tMystery Shard!")
	
	} else if (InStr(tHayStack,"Ancient")) {
		RandomMouseClick(875, marketYPos[iA], 5)		; Click on buy icon
		RandomMouseClick(790, 465, 5)					; Click on Ancient Shard confirm buy
		numAncientShards++
		numShardsPurchased++
		FormatTime, TimeString,, HH:mm
		debugFile.WriteLine(TimeString . "`t`tAncient Shard!")		
	
/*	} else if (	(xPos := InStr(tHayStack,"Preacher")) OR (yPos := InStr(tHayStack,"Lurker")) OR (zPos := InStr(tHayStack,"Magekiller")) ) {
		RandomMouseClick(875, marketYPos[iA], 5)		; Click on buy icon
		RandomMouseClick(150, 635, 5)				; Click on Champion confirm buy
		numChampionsAqd++
		FormatTime, TimeString,, HH:mm
		debugFile.WriteLine(TimeString . "`t`t" . xText . "!")
		RaidCommand_Send_ESC()						; ESC button
		sleep, 2000
*/	}

;	sleep, 1000

}

ScrollDownScreen(515, 360, 4)		; Last 2 items at bottom

;--------------------------------------------------------------------
SetMarketText_2:
;--------------------------------------------------------------------

MouseMove, 180, marketYPos[6]

tHayStack := GetMarketText(180, marketYPos[6])

if (InStr(tHayStack,"Mystery")) {
	RandomMouseClick(435, marketYPos[6]+15, 5)		; Click on buy icon
	RandomMouseClick(790, 465, 5)					; Click on Mystery Shard confirm buy
	numMysteryShards++
	numShardsPurchased++
	FormatTime, TimeString,, HH:mm
	debugFile.WriteLine(TimeString . "`t`tMystery Shard!")

} else if (InStr(tHayStack,"Ancient")) {
	RandomMouseClick(435, marketYPos[6]+15, 5)		; Click on buy icon
	RandomMouseClick(790, 465, 5)				; Click on Ancient Shard confirm buy
	numAncientShards++
	numShardsPurchased++
	FormatTime, TimeString,, HH:mm
	debugFile.WriteLine(TimeString . "`t`tAncient Shard!")		
/*
} else if (	(xPos := InStr(tHayStack,"Preacher")) OR (yPos := InStr(tHayStack,"Lurker")) OR (zPos := InStr(tHayStack,"Magekiller")) ) {
	RandomMouseClick(435, marketYPos[6]+15, 5)		; Click on buy icon
	RandomMouseClick(150, 635, 5)					; Click on Champion confirm buy
	numChampionsAqd++
	FormatTime, TimeString,, HH:mm
	debugFile.WriteLine(TimeString . "`t`t" . xText . "!")
	RaidCommand_Send_ESC()							; ESC button
	sleep, 2000
*/
}

; sleep, 1000

MouseMove, 620, marketYPos[6]

tHayStack := GetMarketText(620, marketYPos[6])

if (InStr(tHayStack,"Mystery")) {
	RandomMouseClick(875, marketYPos[6]+15, 5)		; Click on buy icon
	RandomMouseClick(790, 465, 5)					; Click on Mystery Shard confirm buy
	numMysteryShards++
	numShardsPurchased++
	FormatTime, TimeString,, HH:mm
	debugFile.WriteLine(TimeString . "`t`tMystery Shard!")

} else if (InStr(tHayStack,"Ancient")) {
	RandomMouseClick(875, marketYPos[6]+15, 5)		; Click on buy icon
	RandomMouseClick(790, 465, 5)				; Click on Ancient Shard confirm buy
	numAncientShards++
	numShardsPurchased++
	FormatTime, TimeString,, HH:mm
	debugFile.WriteLine(TimeString . "`t`tAncient Shard!")		
/*
} else if (	(xPos := InStr(tHayStack,"Preacher")) OR (yPos := InStr(tHayStack,"Lurker")) OR (zPos := InStr(tHayStack,"Magekiller")) ) {
	RandomMouseClick(875, marketYPos[6]+15, 5)		; Click on buy icon
	RandomMouseClick(150, 635, 5)					; Click on Champion confirm buy
	numChampionsAqd++
	FormatTime, TimeString,, HH:mm
	debugFile.WriteLine(TimeString . "`t`t" . xText . "!")
	RaidCommand_Send_ESC()							; ESC button
	sleep, 2000
*/
}

;----------------------------------------------------------------------------------

MarketEnd:

; Exit Market (1 ESCAPE)
EscapeToMainPage()

currentProcessText:="MAIN LOOP"
Gosub, UpdateProgressReport

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
GetClassicArenaTokens:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

debugFile.WriteLine()

RandomMouseClick(1165, 65, 10, 4)				; Enter Inbox

if (numTokens := FindClassicArenaTokens(FoundX,FoundY)) {

	RandomMouseClick(1050,FoundY, 5)		; Click on collect icon
	
	if (numTokens == 10) {
		RandomMouseClick(780, 490, 10)			; Click on confirm buy
	}
	
	numClassArenaBattlesRemain += numTokens
	
	FormatTime, TimeString,, HH:mm
	debugFile.WriteLine(TimeString . "`tCollected " . numClassArenaBattlesRemain . " Classic Arena Tokens")

} else {
	debugFile.WriteLine(TimeString . "`tDid not find - ClassicTokenBag")
	noClassicTokensFound = 1
}

EscapeToMainPage()		; Exit Inbox (1 ESCAPE)
return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
GetTagTeamArenaTokens:
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

debugFile.WriteLine()

; Enter Inbox
RandomMouseClick(1165, 65, 10, 4)				; Enter Inbox

if (numTokens := FindTagTeamArenaTokens(FoundX,FoundY)) {
	
	RandomMouseClick(1050, FoundY, 5)		; Click on buy icon
	RandomMouseClick(780, 490, 10)			; Click on confirm buy
	
	numTTArenaBattlesRemain += numTokens	; success!

	FormatTime, TimeString,, HH:mm
	debugFile.WriteLine(TimeString . "`tCollected 10 Tag Team Arena Tokens")
	
} else {
	debugFile.WriteLine(TimeString . "`tDid not find - TagTeamTokenBag")
	noTagTeamTokensFound = 1
}

EscapeToMainPage()		; Exit Inbox (1 ESCAPE)
return

;----------------------------------------------------------------------------------------------------
; TIMER COUNTERS
;----------------------------------------------------------------------------------------------------

;-----------------------------------------------------------
IncrementTimer:
;-----------------------------------------------------------

currentTimer++								; 1 timer tick = 3mins / 1 energy
if (currentEnergy < 130) {
	currentEnergy++
}

iRefreshCountdown_TT--
iRefreshCountdown_CA--
iRefreshCountdown_CB--
iRefreshCountdown_D--
iRefreshCountdown_SP--
iRefreshCountdown_MA--

Gosub, UpdateProgressReport
return

;----------------------------------------------------------------------------------------------------
; SCRIPT APP CALLS
;----------------------------------------------------------------------------------------------------



;----------------------------------------------------------------------------------------------------
MyExitRoutine:
;----------------------------------------------------------------------------------------------------

debugFile.WriteLine()
debugFile.WriteLine("`n" . msgBoxText . "`n")
debugFile.Close()

Gui,1:+LastFound
WinGetPos,xPos,yPos,width,height

tIniFile := A_ScriptDir . "\RSL Night Raider.ini"

IniWrite, %iCalibrateLevel%, %tIniFile%, CalibrateLevel, calibrationUpToLevel
IniWrite, %xPos%, %tIniFile%, CalibrateLevel, dialogXPos
IniWrite, %yPos%, %tIniFile%, CalibrateLevel, dialogYPos

ExitApp
return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
; INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT INIT
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------
DungeonMapInit:
;----------------------------------------------------------------------------------------------------

; Some init values will need to be altered with progress

; Create Arrays
;                           AK   VK   FK   MK   SK      ML   IG   DL   FKC  SD      CAM
dungeonPanScreen 		:= [0,   0,   0,   0,   0,      2,   2,   2,   2,   2,      3,          0,0,0,0]
dungeonXpos				:= [715, 880, 1030,910, 615,    175, 415, 735, 955, 500,    900,        0,0,0,0]
dungeonYpos				:= [240, 190, 310, 440, 420,    380, 200, 220, 410, 400,    190,        0,0,0,0]
dungeonBattleTimeMins	:= [9,   9,   9,   9,   9,		9,   9,   9,   9,   9,		9,          0,0,0,0]

dungeonStageToRun		:= [0,0,0,0,0,			 0,0,0,0,0,			  0,0,0,0,0,		   0,0,0,0,0,			0,0,0,0,0]
dungeonStageWheelDowns	:= [0,0,0,0,0,			 15,15,15,15,15,	  29,29,29,29,29,	   44,44,44,44,44,		59,59,59,59,59]
dungeonStageYPos		:= [999,999,999,999,999, 999,999,999,999,999, 999,999,999,999,999, 999,999,999,999,999,	999,999,999,999,999]
dungeonStageNumEnergy	:= [8,8,8,10,10,		 10,10,12,12,12,	  12,14,14,14,14,	   14,16,16,16,16,		18,18,18,18,20]

; ------------------------------------------------------------------------------
; WINDOW AND SCROLLING VALUES
; ------------------------------------------------------------------------------

tIniFile := A_ScriptDir . "\RSL Night Raider.ini"

IniRead, iCalibrateLevel, %tIniFile%, CalibrateLevel, calibrationUpToLevel
IniRead, raidWinXPos, %tIniFile%, CalibrateLevel, dialogXPos
IniRead, raidWinYPos, %tIniFile%, CalibrateLevel, dialogYPos

; ------------------------------------------------------------------------------
; DUNGEON RANKINGS
; ------------------------------------------------------------------------------

tIniFile := A_ScriptDir . "\RSL Night Raider.ini"

IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_ArcaneKeep
dungeonStageToRun[1] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_VoidKeep
dungeonStageToRun[2] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_ForceKeep
dungeonStageToRun[3] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_MagicKeep
dungeonStageToRun[4] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_SpiritKeep
dungeonStageToRun[5] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_Minotaur
dungeonStageToRun[6] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_IceGolems
dungeonStageToRun[7] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_DragonsLair
dungeonStageToRun[8] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_FireKnights
dungeonStageToRun[9] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_SpidersDen
dungeonStageToRun[10] := iOutput
IniRead, iOutput, %tIniFile%, DungeonMap, dungeon_Campaign
dungeonStageToRun[11] := iOutput

; ------------------------------------------------------------------------------
; DUNGEON SCROLLING CALIBRATION
; ------------------------------------------------------------------------------

loop, 10 {
	iA := A_Index
	if (dungeonStageToRun[iA] > iCalibrateLevel) {
		MyDebugTip("Warning: Setup not calibrated")
		break
	}
}

iA = 0
if (iCalibrateLevel >= 5) {
	IniRead, iNumScrolls, %tIniFile%, StageLocations, num_wheelscrolls_stages_0_5
	loop, 5 {
		iA += 1
		dungeonStageWheelDowns[iA] := iNumScrolls
	}
	IniRead, iYPos, %tIniFile%, StageLocations, stage01_BattleButton_YLoc
	dungeonStageYPos[1] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage02_BattleButton_YLoc
	dungeonStageYPos[2] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage03_BattleButton_YLoc
	dungeonStageYPos[3] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage04_BattleButton_YLoc
	dungeonStageYPos[4] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage05_BattleButton_YLoc
	dungeonStageYPos[5] := iYPos
}

if (iCalibrateLevel >= 10) {
	IniRead, iNumScrolls, %tIniFile%, StageLocations, num_wheelscrolls_stages_6_10
	loop, 5 {
		iA += 1
		dungeonStageWheelDowns[iA] := iNumScrolls
	}
	IniRead, iYPos, %tIniFile%, StageLocations, stage06_BattleButton_YLoc
	dungeonStageYPos[6] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage07_BattleButton_YLoc
	dungeonStageYPos[7] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage08_BattleButton_YLoc
	dungeonStageYPos[8] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage09_BattleButton_YLoc
	dungeonStageYPos[9] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage10_BattleButton_YLoc
	dungeonStageYPos[10] := iYPos
}

if (iCalibrateLevel >= 15) {
	IniRead, iNumScrolls, %tIniFile%, StageLocations, num_wheelscrolls_stages_11_15
	loop, 5 {
		iA += 1
		dungeonStageWheelDowns[iA] := iNumScrolls
	}
	IniRead, iYPos, %tIniFile%, StageLocations, stage11_BattleButton_YLoc
	dungeonStageYPos[11] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage12_BattleButton_YLoc
	dungeonStageYPos[12] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage13_BattleButton_YLoc
	dungeonStageYPos[13] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage14_BattleButton_YLoc
	dungeonStageYPos[14] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage15_BattleButton_YLoc
	dungeonStageYPos[15] := iYPos
}

if (iCalibrateLevel >= 20) {
	IniRead, iNumScrolls, %tIniFile%, StageLocations, num_wheelscrolls_stages_16_20
	loop, 5 {
		iA += 1
		dungeonStageWheelDowns[iA] := iNumScrolls
	}
	IniRead, iYPos, %tIniFile%, StageLocations, stage16_BattleButton_YLoc
	dungeonStageYPos[16] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage17_BattleButton_YLoc
	dungeonStageYPos[17] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage18_BattleButton_YLoc
	dungeonStageYPos[18] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage19_BattleButton_YLoc
	dungeonStageYPos[19] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage20_BattleButton_YLoc
	dungeonStageYPos[20] := iYPos
}

if (iCalibrateLevel >= 25) {
	IniRead, iNumScrolls, %tIniFile%, StageLocations, num_wheelscrolls_stages_21_25
	loop, 5 {
		iA += 1
		dungeonStageWheelDowns[iA] := iNumScrolls
	}
	IniRead, iYPos, %tIniFile%, StageLocations, stage21_BattleButton_YLoc
	dungeonStageYPos[21] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage22_BattleButton_YLoc
	dungeonStageYPos[22] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage23_BattleButton_YLoc
	dungeonStageYPos[23] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage24_BattleButton_YLoc
	dungeonStageYPos[24] := iYPos
	IniRead, iYPos, %tIniFile%, StageLocations, stage25_BattleButton_YLoc
	dungeonStageYPos[25] := iYPos
}

return

;----------------------------------------------------------------------------------------------------
FactionMapInit:
;----------------------------------------------------------------------------------------------------

; Create Arrays
;							DS	HE  OR  SO  OT  DE  BA		SW  LZ  UH  KR		BL  XX  DW  XX  XX
; INDEX						1   2   3   4   5   6   7    	8   9   10  11      12  13  14  15  16
factionPanScreen 		:= [  0,  0,  0,  0,  0,  0,  0,     -1, -1, -1, -1,      1,  1,  1,  1,  1]
factionXpos				:= [325,640,480,805,285,640,1005,   470,310,630,460,    530,825,650,  0,  0]
factionYpos				:= [200,200,320,320,470,470,470,    200,320,320,470,    200,200,320,  0,  0]
factionBattleTimeMins	:= [  9,  9,  9,  9,  9,  9,  9,  	  9,  9,  9,  9,      9,  9,  9,  9,  9]
factionStageToRun		:= [  0,  0,  0,  0,  0,  0,  0,	  0,  0,  0,  0,	  0,  0,  0,  0,  0] ; Init

factionStageWheelDowns	:= [0,0,0,0,0,			15,15,15,15,15,		29,29,29,29,29,		44,44,44,44,44,			47]
factionStageYPos		:= [999,999,999,999,999, 999,999,999,999,999, 999,999,999,999,999, 999,999,999,999,999,615]

factionStageNumKeys		:= [1,1,1,2,2,			2,2,2,2,3,			3,3,3,4,4,			4,4,4,4,4,			4]

; ------------------------------------------------------------------------------
; FACTION WAR RANKINGS
; ------------------------------------------------------------------------------

tIniFile := A_ScriptDir . "\RSL Night Raider.ini"

IniRead, iOutput, %tIniFile%, FactionMap, fact_DS_level
factionStageToRun[1] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_HE_level
factionStageToRun[2] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_OR_level
factionStageToRun[3] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_SO_level
factionStageToRun[4] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_OT_level
factionStageToRun[5] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_DE_level
factionStageToRun[6] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_BA_level
factionStageToRun[7] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_SW_level
factionStageToRun[8] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_LZ_level
factionStageToRun[9] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_UH_level
factionStageToRun[10] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_KR_level
factionStageToRun[11] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_BL_level
factionStageToRun[12] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_SK_level
factionStageToRun[13] := iOutput
IniRead, iOutput, %tIniFile%, FactionMap, fact_DW_level
factionStageToRun[14] := iOutput

; ------------------------------------------------------------------------------
; FACTION SCROLLING CALIBRATION
; ------------------------------------------------------------------------------

loop, 20 {
	iA := A_Index
	factionStageWheelDowns[iA] := dungeonStageWheelDowns[iA]
	factionStageYPos[iA] := dungeonStageYPos[iA]
}

; ------------------------------------------------------------------------------

return

;----------------------------------------------------------------------------------------------------
NightRaidCalibrate:
;----------------------------------------------------------------------------------------------------

/*
[ScrollDownValues]
num_wheelscrolls_stages_0_5=0
num_wheelscrolls_stages_6_10=15
num_wheelscrolls_stages_11_15=29
num_wheelscrolls_stages_16_20=44
num_wheelscrolls_stages_21_25=59
*/

; Enter BATTLE Mode
RaidCommand_Send_ENTER()

; --------------------------------------
; Dungeon / Faction War Scroll Calibrate
; --------------------------------------

RandomMouseClick(420, 370, 80, 5)	; Dungeon Main select
PanScreen(1200,560,70,560,2)

; MsgBox The dungeon pos is x %dungeonXpos[dIndex]% y %dungeonYpos[dIndex]%.
RandomMouseClick(dungeonXpos[8], dungeonYpos[8], 5)	; Select Dragon (25 Levels)

; Confirm Level 5
tStageText :=	OCRGetText(405,580, 510,650)	; Large Search Box 70 high, Macro increments
pos:=InStr(tStageText,"Stage 5")
if (pos > 0) {
	MyDebugTip("Stage 5 found")
} else {
	; Error, Stage 5 should be here
	MyDebugTip("Error, Stage 5 was not found")
	return
}

tIniFile := A_ScriptDir . "\RSL Night Raider.ini"

iCalibrateLevel = 5

; Level 1-5 should be good at the standard window size

iValue = 0
IniWrite, %iValue%, %tIniFile%, StageLocations, num_wheelscrolls_stages_0_5
iYVal = 150
IniWrite, %iYVal%, %tIniFile%, StageLocations, stage01_BattleButton_YLoc
iYVal = 260
IniWrite, %iYVal%, %tIniFile%, StageLocations, stage02_BattleButton_YLoc
iYVal = 380
IniWrite, %iYVal%, %tIniFile%, StageLocations, stage03_BattleButton_YLoc
iYVal = 490
IniWrite, %iYVal%, %tIniFile%, StageLocations, stage04_BattleButton_YLoc
iYVal = 610
IniWrite, %iYVal%, %tIniFile%, StageLocations, stage05_BattleButton_YLoc

iNumScrollDowns = 0
bStage10 = 0
bStage15 = 0
bStage20 = 0
bStage25 = 0
bFinished = 0

loop {

	ScrollDownScreen(515, 590, 1)				; Scroll down one mouse wheel
	iNumScrollDowns++
	
	tStageText := OCRGetText(405,580, 510,650)	; Large Search Box 70 high
	
	if (pos1:=InStr(tStageText,"Stage 10") AND bStage10 == 0) {
		MyDebugTip("Stage 10 = " . iNumScrollDowns . " wheel downs")
		bStage10 = 1
		
		iValue := iNumScrollDowns
		IniWrite, %iValue%, %tIniFile%, StageLocations, num_wheelscrolls_stages_6_10
		
		; 175, 290, 405, 520, 635 (115 centres) Battle 26 high
		MyDebugTip("Searching for Battle Button Stage 6")
		iYVal := 140
		loop {
			tBattleText := OCRGetText(1070,iYVal, 1140,iYVal+26)	; Small Search Box 26 high
			iYVal += 2
		} until (posY:=InStr(tBattleText,"Battle") OR iYVal > 190)
		if (iYVal > 190) {
			MyDebugTip("Battle Button Stage 6 not found")
			break
		}
		MyDebugTip("Battle Button Stage 6 found")
		
		iYVal := iYVal + 11 	; 11+2=13=26/2 Centre of Box where Battle was found
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage06_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage07_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage08_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage09_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage10_BattleButton_YLoc
		
		iCalibrateLevel = 10
		
	} else if (pos2:=InStr(tStageText,"Stage 15") AND bStage15 == 0) {
		MyDebugTip("Stage 15 = " . iNumScrollDowns . " wheel downs")
		bStage15 = 1

		iValue := iNumScrollDowns
		IniWrite, %iValue%, %tIniFile%, StageLocations, num_wheelscrolls_stages_11_15
		
		MyDebugTip("Searching for Battle Button Stage 11")
		iYVal := 140
		loop {
			tBattleText := OCRGetText(1070,iYVal, 1140,iYVal+26)	; Small Search Box 26 high
			iYVal += 2
		} until (posY:=InStr(tBattleText,"Battle") OR iYVal > 190)
		if (iYVal > 190) {
			MyDebugTip("Battle Button Stage 11 not found")
			break
		}
		MyDebugTip("Battle Button Stage 11 found")
		
		iYVal := iYVal + 11 	; 11+2=13=26/2 Centre of Box where Battle was found
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage11_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage12_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage13_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage14_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage15_BattleButton_YLoc
		
		iCalibrateLevel = 15

	} else if (pos3:=InStr(tStageText,"Stage 20") AND bStage20 == 0) {
		MyDebugTip("Stage 20 = " . iNumScrollDowns . " wheel downs")
		bStage20 = 1
		
		iValue := iNumScrollDowns
		IniWrite, %iValue%, %tIniFile%, StageLocations, num_wheelscrolls_stages_16_20

		MyDebugTip("Searching for Battle Button Stage 16")
		iYVal := 140
		loop {
			tBattleText := OCRGetText(1070,iYVal, 1140,iYVal+26)	; Small Search Box 26 high
			iYVal += 2
		} until (posY:=InStr(tBattleText,"Battle") OR iYVal > 190)
		if (iYVal > 190) {
			MyDebugTip("Battle Button Stage 16 not found")
			break
		}
		MyDebugTip("Battle Button Stage 16 found")
		
		iYVal := iYVal + 11 	; 11+2=13=26/2 Centre of Box where Battle was found
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage16_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage17_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage18_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage19_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage20_BattleButton_YLoc
		
		iCalibrateLevel = 20

	} else if (pos4:=InStr(tStageText,"Stage 25") AND bStage25 == 0) {
		ScrollDownScreen(515, 590, 1)
		iNumScrollDowns++	; Make sure its at the bottom
		MyDebugTip("Stage 25 = " . iNumScrollDowns . " wheel downs")
		bStage25 = 1

		iValue := iNumScrollDowns
		IniWrite, %iValue%, %tIniFile%, StageLocations, num_wheelscrolls_stages_21_25
		
		MyDebugTip("Searching for Battle Button Stage 21")
		iYVal := 140
		loop {
			tBattleText := OCRGetText(1070,iYVal, 1140,iYVal+26)	; Small Search Box 26 high
			iYVal += 2
		} until (posY:=InStr(tBattleText,"Battle") OR iYVal > 190)
		if (iYVal > 190) {
			MyDebugTip("Battle Button Stage 21 not found")
			break
		}
		MyDebugTip("Battle Button Stage 21 found")

		iYVal := iYVal + 11 	; 11+2=13=26/2 Centre of Box where Battle was found
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage21_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage22_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage23_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage24_BattleButton_YLoc
		iYVal += 115
		IniWrite, %iYVal%, %tIniFile%, StageLocations, stage25_BattleButton_YLoc
		
		iCalibrateLevel = 25

		bFinished = 1
	}

} until (bFinished == 1)

IniWrite, %iCalibrateLevel%, %tIniFile%, CalibrateLevel, calibrationUpToLevel

EscapeToMainPage()

CalibrateFinished:

MyDebugTip("Calibration Finished")
EscapeToMainPage()

return

;----------------------------------------------------------------------------------------------------
SaveDungeonsToIni:
;----------------------------------------------------------------------------------------------------

tIniFile := A_ScriptDir . "\RSL Night Raider.ini"

IniWrite, %stageArcaneKeep%, %tIniFile%, DungeonMap, dungeon_ArcaneKeep
IniWrite, %stageVoidKeep%, %tIniFile%, DungeonMap, dungeon_VoidKeep
IniWrite, %stageForceKeep%, %tIniFile%, DungeonMap, dungeon_ForceKeep
IniWrite, %stageMagicKeep%, %tIniFile%, DungeonMap, dungeon_MagicKeep
IniWrite, %stageSpiritKeep%, %tIniFile%, DungeonMap, dungeon_SpiritKeep
IniWrite, %stageMinotaur%, %tIniFile%, DungeonMap, dungeon_Minotaur
IniWrite, %stageIceGolem%, %tIniFile%, DungeonMap, dungeon_IceGolems
IniWrite, %stageDragonsLair%, %tIniFile%, DungeonMap, dungeon_DragonsLair
IniWrite, %stageFireKnight%, %tIniFile%, DungeonMap, dungeon_FireKnights
IniWrite, %stageSpidersDen%, %tIniFile%, DungeonMap, dungeon_SpidersDen

MsgBox, 4096, Save Dungeon Stages, Saved Values to Ini File

return

;----------------------------------------------------------------------------------------------------
SaveFactionsToIni:
;----------------------------------------------------------------------------------------------------

tIniFile := A_ScriptDir . "\RSL Night Raider.ini"

IniWrite, %StageDemonspawn%, %tIniFile%, FactionMap, fact_DS_level
IniWrite, %StageHighElves%, %tIniFile%, FactionMap, fact_HE_level
IniWrite, %StageOrcs%, %tIniFile%, FactionMap, fact_OR_level
IniWrite, %StageSacredOrder%, %tIniFile%, FactionMap, fact_SO_level
IniWrite, %StageOgrynTribes%, %tIniFile%, FactionMap, fact_OT_level
IniWrite, %StageDarkElves%, %tIniFile%, FactionMap, fact_DE_level
IniWrite, %StageBarbarians%, %tIniFile%, FactionMap, fact_BA_level
IniWrite, %StageSkinwalkers%, %tIniFile%, FactionMap, fact_SW_level
IniWrite, %StageLizardmen%, %tIniFile%, FactionMap, fact_LZ_level
IniWrite, %StageUndeadHordes%, %tIniFile%, FactionMap, fact_UH_level
IniWrite, %StageKnightsRevenant%, %tIniFile%, FactionMap, fact_KR_level
IniWrite, %StageBannerLords%, %tIniFile%, FactionMap, fact_BL_level
IniWrite, %StageShadowkin%, %tIniFile%, FactionMap, fact_SK_level
IniWrite, %StageDwarves%, %tIniFile%, FactionMap, fact_DW_level

MsgBox, 4096, Save Faction War Stages, Saved Values to Ini File

return

;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
; FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS FUNCTIONS
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------
RaidCommand_Send_ENTER()
;----------------------------------------------------------------------------------------------------
{
	; ControlSend, , {Enter}, ahk_exe Raid.exe ; Enter button
	RandomMouseClick(1180, 640, 5)
}

;----------------------------------------------------------------------------------------------------
RaidCommand_Send_ESC()
;----------------------------------------------------------------------------------------------------
{
	ControlSend, , {Esc}, ahk_exe Raid.exe		; ESC back to map
}

;----------------------------------------------------------------------------------------------------
RaidCommand_Send_REPLAY()
;----------------------------------------------------------------------------------------------------
{
	ControlSend, , r, ahk_exe Raid.exe
}

;----------------------------------------------------------------------------------------------------
OCRGetText(ByRef x_start, ByRef y_start, ByRef x_end, ByRef y_end)
;----------------------------------------------------------------------------------------------------
{
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe	; -6,0 / 1294,700 - Datum Location
	
	xRaidPos_start := x_start + X
	yRaidPos_start := y_start + Y
	xRaidPos_end := x_end + X
	yRaidPos_end := y_end + Y
	
	tprogramLoc := A_ScriptDir . "\lib\Capture2Text\Capture2Text_CLI.exe"
	
	clipboard := ""   ; Empty the clipboard
	RunWait, %tprogramLoc% -s "%xRaidPos_start% %yRaidPos_start% %xRaidPos_end% %yRaidPos_end%" --clipboard, , hide
	tTextCopy := clipboard
	
;	sleep, 1000
	
	return tTextCopy
}

;----------------------------------------------------------------------------------------------------
OCRGetPlusNumber(ByRef x_start, ByRef y_start, ByRef x_end, ByRef y_end)
;----------------------------------------------------------------------------------------------------
{
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe	; -6,0 / 1294,700 - Datum Location
	
	xRaidPos_start := x_start + X
	yRaidPos_start := y_start + Y
	xRaidPos_end := x_end + X
	yRaidPos_end := y_end + Y

	tprogramLoc := A_ScriptDir . "\lib\Capture2Text\Capture2Text_CLI.exe"
	
	clipboard := ""   ; Empty the clipboard
	RunWait, %tprogramLoc% -s "%xRaidPos_start% %yRaidPos_start% %xRaidPos_end% %yRaidPos_end%" --clipboard, , hide

	iNum = -999
	bNumberFound = 0
	tTextCopy := clipboard
	
;	ListVars
;	Pause

	Loop, parse, clipboard,
	{

		tTempChar := A_LoopField
		iNumTemp = -999
		
		switch A_LoopField 
		{
		Case "0":
			iNumTemp = 0
		Case "1": 
			iNumTemp = 1
		Case "2": 
			iNumTemp = 2
		Case "3": 
			iNumTemp = 3
		Case "4": 
			iNumTemp = 4
		Case "5": 
			iNumTemp = 5
		Case "6": 
			iNumTemp = 6
		Case "7": 
			iNumTemp = 7
		Case "8": 
			iNumTemp = 8
		Case "9": 
			iNumTemp = 9
		}

		if (bNumberFound == 0 AND iNumTemp >= 0) {		; Start condition
			bNumberFound = 1
			iNum := 0
		}

		if (bNumberFound == 1) {
			if (A_LoopField == "/") {														; End Condition
				break
			} else if (A_LoopField == "K") {												; End Condition
				break
			} else if (A_LoopField == "," OR A_LoopField == "." OR A_LoopField == " ") {	; Skip
				continue
			} else if (iNumTemp < 0) {														; End Condition
				break
			}
		}

		if (bNumberFound == 1 AND iNumTemp >= 0) {		; Continue condition
			iNum := (iNum * 10) + iNumTemp
			iNumTemp = 0
		}

	}
	
	return iNum
	
}

;----------------------------------------------------------------------------------------------------
GetMainScreenValues(ByRef Energy, ByRef CCoins, ByRef TTCoins, ByRef Silver, ByRef Gems)
;----------------------------------------------------------------------------------------------------
{
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

	x1Pos := [0,0,0,0,0]
	x2Pos := [0,0,0,0,0]
	iIndex = 0
	
	x1Pos[1] := 405
	x2Pos[1] := 485
	
	x1Pos[2] := 550
	x2Pos[2] := 605
	
	x1Pos[3] := 670
	x2Pos[3] := 725
	
	x1Pos[4] := 790
	x2Pos[4] := 865
	
	x1Pos[5] := 935
	x2Pos[5] := 1010

	loop, 5 {

		iA := A_Index

		x_start := x1Pos[iA]
		y_start := 40
		x_end := x2Pos[iA]
		y_end := 62

		iNum := OCRGetPlusNumber(x_start, y_start, x_end, y_end)

		; MsgBox, In area :: x_start: %x_start% --> x_end: %x_end% , y_start: %y_start% --> y_end: %y_end%`n`nFound Text:`n`n%clipboard%

;		MsgBox, Number --> %iNum%
		if (iA == 1) {
			Energy := iNum
		} else if (iA ==2) {
			CCoins := iNum
		} else if (iA ==3) {
			TTCoins := iNum
		} else if (iA ==4) {
			Silver := iNum
		} else if (iA ==5) {
			Gems := iNum
		}

	}

	return 1

}

;----------------------------------------------------------------------------------------------------
GetMarketText(xPos, yPos)
;----------------------------------------------------------------------------------------------------
{
	
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

	x_start := xPos
	y_start := yPos - 35
	x_end := xPos + 180
	y_end := yPos + 35

	tHayStack := OCRGetText(x_start, y_start, x_end, y_end)

;	MyDebugTip("xHayStack = " . xHayStack . " xNeedle = " . xNeedle)
	
	return tHayStack

}

;----------------------------------------------------------------------------------------------------
removeMainScreenAds()
;----------------------------------------------------------------------------------------------------
{

	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

	; Series of ESC buttons and clicks in remote area

	RaidCommand_Send_ESC()	; ESC button
	sleep, 1000
	RandomMouseClick(15, 265, 5)		; Click on section of display where there are no ads

	RaidCommand_Send_ESC()	; ESC button
	sleep, 1000
	RandomMouseClick(15, 265, 5)

	RaidCommand_Send_ESC()	; ESC button
	sleep, 1000
	RandomMouseClick(15, 265, 5)

	RaidCommand_Send_ESC()	; ESC button
	sleep, 1000
	RandomMouseClick(15, 265, 5)
	
	RandomMouseClick(15, 265, 5)
	RandomMouseClick(15, 265, 5)

	return
}

;----------------------------------------------------------------------------------------------------
EscapeToMainPage()
;----------------------------------------------------------------------------------------------------
{
    WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

	loop {

			RaidCommand_Send_ESC()			; This will jump back out to main screen
			sleep, 3000
			
			tRSL := OCRGetText(52,630, 120,660)
		
	} until (InStr(tRSL,"SHOP"))
	
	return 0
}

;----------------------------------------------------------------------------------------------------
RandomMouseClick(xPos, yPos, rVal, sVal := 3)
;----------------------------------------------------------------------------------------------------
{
    WinActivate, ahk_exe Raid.exe

	xPosMin := xPos - rVal
	xPosMax := xPos + rVal
	yPosMin := yPos - rVal
	yPosMax := yPos + rVal
	
	Random, rXPos, xPosMin, xPosMax
	Random, rYPos, yPosMin, yPosMax
	MouseClick, left, rXPos, rYPos
	
	sleep, sVal * 1000		; Min sleep time after click
	
	return
}

;----------------------------------------------------------------------------------------------------
LongSleep(numMinutes)
;----------------------------------------------------------------------------------------------------
{
	numMilliSeconds := numMinutes * 60 * 1000
	sleep, numMilliSeconds
	WinActivate, ahk_exe Raid.exe				; Keep focus on the window
	return 
}

;----------------------------------------------------------------------------------------------------
PanScreen(x1Pos, y1Pos, x2Pos, y2Pos, numPans)
;----------------------------------------------------------------------------------------------------
{

	WinActivate, ahk_exe Raid.exe

	if (numPans > 0) {
		loop, %numPans% {
			; Scroll to right boundary
			MouseClickDrag, left, x1Pos, y1Pos, x2Pos, y2Pos, 25
			sleep, 1000
		}
		return
	} 
	
	if (numPans < 0) {
		negPans := Abs(numPans)
		loop, %negPans% {
			; Scroll to right boundary
			MouseClickDrag, left, x2Pos, y2Pos, x1Pos, y1Pos, 25
			sleep, 1000
		}
		return
	}
	
	return 
}

;----------------------------------------------------------------------------------------------------
ScrollDownScreen(xPos, yPos, numWheelDowns, iDelay := 0)
;----------------------------------------------------------------------------------------------------
{
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

    iWheelRolls := Abs(numWheelDowns)
	nSecs := iDelay * 1000

	MouseMove, xPos, yPos, 0
	if (numWheelDowns > 0) {
		SendInput {WheelDown %iWheelRolls%}
	} else {
		SendInput {WheelUp %iWheelRolls%}
	}
	sleep, %nSecs%

/*
	; Scroll to bottom set location 
	loop, %iWheelRolls% {
	;   MouseClick , WhichButton, X, Y, ClickCount, Speed, DownOrUp, Relative
        if (numWheelDowns > 0) {
            MouseClick, WheelDown, xPos, yPos, 1
        } else {
            MouseClick, WheelUp, xPos, yPos, 1
        }
		sleep, %nSecs%
	}
*/

	return
}

;----------------------------------------------------------------------------------------------------
WaitForBattleEnd(checkTime, checkFreq, quitTime, ByRef battleResult)
;----------------------------------------------------------------------------------------------------
{
	milliCheckTime := checkTime * 1000
	milliCheckFreq := checkFreq * 1000
	milliQuitTime := quitTime * 1000
	
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

	checkCount := 0
	sleep, milliCheckTime
	checkCount += milliCheckTime
	
	battleResult = 0

;	MyDebugTip("WaitForReplayButton checkCount " . Floor(checkCount/1000) . " battleTime " . battleTime)

	loop {

		tBattleResult := OCRGetText(525,80, 755,150)
		
		if (pos:=InStr(tBattleResult,"VICTORY")) {
			battleResult = 1
			goto, FoundBattleComplete
		} else if (pos:=InStr(tBattleResult,"VIC")) {
			battleResult = 1
			goto, FoundBattleComplete
		}
		
		if (InStr(tBattleResult,"DEFEAT")) {
			battleResult = -1
			goto, FoundBattleComplete
		}
		
		sleep, milliCheckFreq
		checkCount += milliCheckFreq
		
;		MyDebugTip("WaitForReplayButton checkCount " . Floor(checkCount/1000) . " battleTime " . battleTime)
		
	} until (checkCount >= milliQuitTime)

;	return 0	; Zero return val indicates went overtime

FoundBattleComplete:

return Floor(checkCount/1000)		; Return battle duration in seconds

}

;----------------------------------------------------------------------------------------------------
FindMarketText(xPos, yPos, xNeedle)
;----------------------------------------------------------------------------------------------------
{
	
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

	x_start := xPos
	y_start := yPos - 35
	x_end := xPos + 180
	y_end := yPos + 35

	xHayStack := OCRGetText(x_start, y_start, x_end, y_end)

;	MyDebugTip("xHayStack = " . xHayStack . " xNeedle = " . xNeedle)
	
	if (InStr(xHayStack,xNeedle)) {
		return 1
	}
	
	return 0

}

;----------------------------------------------------------------------------------------------------
FindClassicArenaTokens(ByRef FoundX, ByRef FoundY)
;----------------------------------------------------------------------------------------------------
{
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

	; --------------------------
	; BAGS (10)
	; --------------------------

	iYPos = 190
	
	loop, 6 {
		
		RandomMouseClick(630, iYPos, 5)				; Click on inbox item
		
		tInboxText := OCRGetText(490,370, 800,405)
		RandomMouseClick(630, 120, 5)				; Close dialog? if any
		
		if (iPos:=InStr(tInboxText,"Classic")) {
			FoundX = 630
			FoundY:=iYPos
			return 10
		}
		
		iYPos += 85
		
	}
	
	return 0

}

;----------------------------------------------------------------------------------------------------
FindTagTeamArenaTokens(ByRef FoundX, ByRef FoundY)
;----------------------------------------------------------------------------------------------------
{
	WinActivate, ahk_exe Raid.exe
	WinGetPos, X, Y, Width, Height, ahk_exe Raid.exe

	; --------------------------
	; BAGS (10)
	; --------------------------
	
	iYPos = 190
	
	loop, 6 {
		
		RandomMouseClick(630, iYPos, 5)				; Click on inbox item
		
		tInboxText := OCRGetText(490,370, 800,405)
		RandomMouseClick(630, 120, 5)				; Close dialog? if any
		
		if (iPos:=InStr(tInboxText,"Tag")) {
			FoundX = 630
			FoundY:=iYPos
			return 10
		}
		
		iYPos += 85
		
	}
	
	return 0

}

;----------------------------------------------------------------------------------------------------
MyDebugTip(Text)
;----------------------------------------------------------------------------------------------------
{
	TrayTip, Debug, %Text% ,,16 		; Easy to comment out
	sleep, 3000							; Takes time to pop up, wait till it does
	return
}
CHRONICLE_DB = {}
SKILL_LINES = {
  [794] = "Archaeology",
  [171] = "Alchemy",
  [164] = "Blacksmith",
  [185] = "Cooking",
  [333] = "Enchanting",
  [202] = "Engineer",
  [129] = "First Aid",
  [356] = "Fishing",
  [182] = "Herbalism",
  [773] = "Inscription",
  [755] = "Jewelcrafting",
  [165] = "Leatherworking",
  [186] = "Mining",
  [393] = "Skinning",
  [197] = "Tailoring"
}
MAX_QUESTS_NUMBER = 70000
-- All HKs count at start of the session
-- It will re-init at 00:00 
LOGGED_HKS_ALL = nil
-- 'today_hks' at start of the session
-- It will re-init at 00:00
LOGGED_HKS_TODAY = nil
LOGGED_TS = nil
LOGGED_PLAYED_TODAY = nil
-- DAY at start of the session
-- It will re-init at 00:00 
LOGGED_DAY = nil 
YEAR = nil
MONTH = nil
DAY = nil
REALM = nil
PLAYER = nil

MAX_GRAPH_HEIGHT = 500

SLASH_CHRONICLE1 = "/chronicle"
SlashCmdList["CHRONICLE"] = function(msg)
  frame:Show()
end

local my_frame = nil
local scale = 1
local frameWidth = 700
local frameHeight = 530
frame = CreateFrame("Frame","ChronicleFrame",UIParent)
local texture = frame:CreateTexture()
frame:SetSize(frameWidth, frameHeight)
frame:SetPoint("CENTER")
texture:SetAllPoints()
texture:SetColorTexture(0.1, 0.1, 0.1, 1)
frame.background = texture;

frame:ClearAllPoints()
frame:SetBackdrop(StaticPopup1:GetBackdrop())
frame:SetPoint("CENTER",UIParent)
frame:SetScale(scale)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("WHO_LIST_UPDATE")
frame:RegisterEvent("TIME_PLAYED_MSG")
frame:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
--frame:Hide()

local frameTitle = CreateFrame("Frame", "ChronicleFrameTitle", frame)
local titleTexture = frameTitle:CreateTexture()
frameTitle:SetSize(frameWidth, 20)
titleTexture:SetAllPoints()
titleTexture:SetColorTexture(0.2, 0.2, 0.2, 1)
frameTitle.background = titleTexture;
frameTitle:ClearAllPoints()
frameTitle:SetPoint("TOPLEFT",frame, "TOPLEFT", 0, 20)
frameTitle:SetScale(scale)
frameTitle:Show()

frameTitle.text = frameTitle:CreateFontString(nil, "ARTWORK")
frameTitle.text:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
frameTitle.text:SetPoint("CENTER",0,0)
frameTitle.text:SetText("Chronicle")

function create_frame()
  local frameTextInfo = CreateFrame("Frame", "FrameTextInfo", frame)
  frameTextInfo:SetSize(frameWidth-75, frameHeight-10)
  frameTextInfo:SetBackdrop({
    bgFile="Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
    tile=true,
    tileSize=5,
    edgeSize=1,
  })
  frameTextInfo:SetBackdropColor(0.1,0.1,0.1,1)
  frameTextInfo:SetBackdropBorderColor(0.2,0.2,0.2,1)
  frameTextInfo:SetPoint("TOPLEFT", frame, "TOPLEFT", 70, -5)
  frameTextInfo:Show()
  frameTextInfo.text = frameTextInfo:CreateFontString(nil, "ARTWORK")
  frameTextInfo.text:SetFont("Fonts\\ARIALN.ttf", 13)
  frameTextInfo.text:SetPoint("CENTER",0,0)
  frame.used = true
  return frameTextInfo
end

function setupButton(btn)
	btn:SetWidth(60)
	btn:SetHeight(22)
	btn:SetNormalFontObject("GameFontNormal")
	local ntex = btn:CreateTexture()
	ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()	
	btn:SetNormalTexture(ntex)

	local htex = btn:CreateTexture()
	htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	btn:SetHighlightTexture(htex)

	local ptex = btn:CreateTexture()
	ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()
	btn:SetPushedTexture(ptex)
end

-- start buttons
local buttonQ = CreateFrame("Button", nil, frame)
buttonQ:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
buttonQ:SetText("Quests")
buttonQ:SetScript("OnClick", function()
  cnt = count_quests_completed()
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
	my_frame.text:SetText("Total quests completed: "..cnt)
  draw_quests_done()
end)

local buttonTP = CreateFrame("Button", nil, frame)
buttonTP:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -30)
buttonTP:SetText("Time played")
buttonTP:SetScript("OnClick", function()
  draw_time_played()
end)

local buttonBS = CreateFrame("Button", nil, frame)
buttonBS:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -55)
buttonBS:SetText("Blacksmith")
buttonBS:SetScript("OnClick", function()
  draw_prof(5)
end)
local buttonFishing = CreateFrame("Button", nil, frame)
buttonFishing:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -80)
buttonFishing:SetText("Fishing")
buttonFishing:SetScript("OnClick", function()
  draw_prof(8)
end)
local buttonMining = CreateFrame("Button", nil, frame)
buttonMining:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -105)
buttonMining:SetText("Mining")
buttonMining:SetScript("OnClick", function()
  draw_prof(7)
end)
local buttonGold = CreateFrame("Button", nil, frame)
buttonGold:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -130)
buttonGold:SetText("Gold")
buttonGold:SetScript("OnClick", function()
  draw_gold()
end)
local buttonClear = CreateFrame("Button", nil, frame)
buttonClear:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -155)
buttonClear:SetText("Clear")
buttonClear:SetScript("OnClick", function()
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
end)
local closeButton = CreateFrame("Button", nul, frameTitle)
closeButton:SetPoint("TOPRIGHT", frameTitle)
closeButton:SetText("x")
closeButton:SetWidth(22)
closeButton:SetScript("OnClick", function() 
	frame:Hide()
end)
setupButton(closeButton)
setupButton(buttonQ)
setupButton(buttonTP)
setupButton(buttonBS)
setupButton(buttonFishing)
setupButton(buttonMining)
setupButton(buttonGold)
setupButton(buttonClear)
-- end buttons

-- prevent show 'time played' msg in chat when it requested by addon
local requesting
local o = ChatFrame_DisplayTimePlayed
ChatFrame_DisplayTimePlayed = function(...)
  if requesting then
    requesting = false
    return
  end
  return o(...)
end

function saveLevelInfo()
  local player_level = UnitLevel("player")
  local timestamp = time()
  local dt = date('%Y-%m-%d %H:%M:%S', timestamp)
  if not CHRONICLE_DB[REALM][PLAYER]['levels'] then
    CHRONICLE_DB[REALM][PLAYER]['levels'] = {}
  end  
  if not CHRONICLE_DB[REALM][PLAYER]['levels'][player_level] then
    CHRONICLE_DB[REALM][PLAYER]['levels'][player_level] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['levels'][player_level]['ding_at'] then
    CHRONICLE_DB[REALM][PLAYER]['levels'][player_level]['ding_at'] = timestamp
  end
  if not CHRONICLE_DB[REALM][PLAYER]['levels']
    [player_level]['ding_at_str'] then
    CHRONICLE_DB[REALM][PLAYER]['levels']
      [player_level]['ding_at_str'] = dt 
  end
end

function save_prof_info(prof_id)
  local ts = time()
  local dt = date('%Y-%m-%d %H:%M:%S', ts)
  Y = date('%Y', ts)
  m = date('%m', ts)
  d = date('%d', ts)
  name, icon, skillLvl, maxSkillLevel, numAbilities, spelloffset,
    skillLine, skillModifier, specializationIndex,
    specializationOffset = GetProfessionInfo(prof_id)
  prof_name_en = SKILL_LINES[skillLine]

  if not CHRONICLE_DB[REALM][PLAYER]['profs'] then
    CHRONICLE_DB[REALM][PLAYER]['profs'] = {}
  end  
  if not CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id] = {}
  end  
  if not CHRONICLE_DB[REALM][PLAYER]['profs']
    [prof_id]['name'] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]['name'] = prof_name_en
  end
  if not CHRONICLE_DB[REALM][PLAYER]['profs']
    [prof_id][Y] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id][Y] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['profs']
    [prof_id][Y][m] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id][Y][m] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['profs']
    [prof_id][Y][m][d] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id][Y][m][d] = {}
  end
  local cur_skill = 0
  if CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]['cur_skill'] then
    cur_skill = CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]['cur_skill']
  end
  if skillLvl > cur_skill then
    if not CHRONICLE_DB[REALM][PLAYER]['profs']
      [prof_id][Y][m][d][skillLvl] then
      CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id][Y][m][d][skillLvl] = {}
    end
    if not CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id][Y][m][d][skillLvl]['ts'] then
      CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]
        [Y][m][d][skillLvl]['ts'] = ts
    end
  end
  CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]['cur_skill'] = skillLvl
end

function handle_prof_info()
  prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
  prof_list = {prof1, prof2, archaeology, fishing, cooking, firstAid}
  for _, prof_id in pairs(prof_list) do
    if prof_id then
      save_prof_info(prof_id)
    end
  end
end

function handle_quests()
  local qdone = count_quests_completed()
  CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]["q_done"] = qdone
end

function count_quests_completed()
  local i = 0
  local count = 0
  while i < MAX_QUESTS_NUMBER do
    r = IsQuestFlaggedCompleted(i)
    if r then
      count = count + 1
    end
    i = i + 1
  end
  return count
end

C_Timer.NewTicker(10, function() 
  local ts = time()
  YEAR = date('%Y', ts)
  MONTH = date('%m', ts)
  DAY = date('%d', ts)
  
  handle_date_change()
  requesting = true
  RequestTimePlayed()
  handle_today_played()
  handle_today_hks()
  saveLevelInfo()
  handle_prof_info()
  handle_quests()
  count_hk_total()
  handle_money()
  handle_achievements()
end)

function frame:TIME_PLAYED_MSG(timePlayed, timePlayedAtLevel)
  local player_level = UnitLevel("player")
  LATEST_TIME_PLAYED = timePlayed
  CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]["time_played"] = timePlayed
  CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]["time_played_at_level"] = timePlayedAtLevel 
  CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]["level"] = player_level
end

function frame:ADDON_LOADED()
  REALM = GetRealmName();
  PLAYER = UnitName("player");
  init_db()
  init_today_hks()
end

function handle_money()
  copper = GetMoney()
  CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]['money'] = copper
end

function handle_achievements()
  points = GetTotalAchievementPoints()
  CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]
    ['achievs'] = points 
end

function init_db()
  ts = time()
  YEAR = date('%Y', ts)
  MONTH = date('%m', ts)
  DAY = date('%d', ts)
  if not CHRONICLE_DB[REALM] then
    CHRONICLE_DB[REALM] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER] then
    CHRONICLE_DB[REALM][PLAYER] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['data'] then
    CHRONICLE_DB[REALM][PLAYER]['data'] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['data'][YEAR] then
    CHRONICLE_DB[REALM][PLAYER]['data'][YEAR] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH] then
    CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY] then
    CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY] = {}
  end
end

function handle_date_change()
  ts = time()
  local day = date('%d', ts)
  if day ~= LOGGED_DAY then
    init_db()
    init_today_hks()
    init_today_played()
    LOGGED_DAY = day
  end
end

function init_today_played()
  LOGGED_TS = time()
  if not CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]['today_played'] then
    CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]['today_played'] = 0
  end
  LOGGED_PLAYED_TODAY = CHRONICLE_DB[REALM][PLAYER]['data']
    [YEAR][MONTH][DAY]['today_played']
end

function init_today_hks()
  local honorableKills, dishonorableKills, highestRank = GetPVPLifetimeStats()
  LOGGED_HKS_ALL = honorableKills
  if not CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]['today_hks'] then
    CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]['today_hks'] = 0
  end
  LOGGED_HKS_TODAY = CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]['today_hks']
end

function handle_today_played()
  local cur_ts = time() 
  today_played = cur_ts - LOGGED_TS + LOGGED_PLAYED_TODAY
  CHRONICLE_DB[REALM][PLAYER]['data']
    [YEAR][MONTH][DAY]['today_played'] = today_played
end

function handle_today_hks()
  local honorableKills, dishonorableKills, highestRank = GetPVPLifetimeStats()
  local today_hks = honorableKills - LOGGED_HKS_ALL + LOGGED_HKS_TODAY
  CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]['today_hks'] = today_hks
end

function count_hk_total()
  honorableKills, dishonorableKills, highestRank = GetPVPLifetimeStats()
  CHRONICLE_DB[REALM][PLAYER]['data'][YEAR][MONTH][DAY]['hk_total'] = honorableKills
end

function draw_time_played()
  MAX_VAL = get_max_val('time_played')
  height_mod = MAX_GRAPH_HEIGHT / MAX_VAL
  if LATEST_TIME_PLAYED then
    if my_frame then
      my_frame:Hide()
      my_frame.used = nil
    end
    my_frame = create_frame()
    x_pos = 0
    -- 2019-01-01
    start_ts = 1546344732
    stop_ts = time() + 86400
    x_pos = 0
    draw_grid_lines(my_frame)
    local perc_use = nil
    -- dirty way to go through dates
    while start_ts <= stop_ts do
      local line = my_frame:CreateTexture()
      line:SetColorTexture(0.8, 0.8, 0.8, 0.3)
      l_year = date('%Y', start_ts)
      l_month = date('%m', start_ts)
      l_day = date('%d', start_ts)
      if CHRONICLE_DB[REALM][PLAYER]['data'][l_year] then
        if CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month] then
          if CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month][l_day] then
          local tp = CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month][l_day]
            ['time_played']
            if tp then
              perc = tp * height_mod
              line:SetColorTexture(0.8, 0.8, 0.8, 0.9)
              perc_use = perc
            end
          end
        end
      end
      if perc_use then
        line:SetSize(5, perc_use)
        line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
        x_pos = x_pos + 5
      end
      start_ts = start_ts + 86400
    end
  else
    frameTextInfo.text:SetText("Data is not ready yet. Please wait couple of seconds and try again")
  end
end

function draw_quests_done()
  MAX_VAL = get_max_val('q_done')
  height_mod = MAX_GRAPH_HEIGHT / MAX_VAL
  --MAX_QUESTS = 1000
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
  x_pos = 0
  -- 2019-01-01
  start_ts = 1546344732
  stop_ts = time() + 86400
  x_pos = 0
  local perc_use = nil
  draw_grid_lines(my_frame)
  -- dirty way to go through dates
  while start_ts <= stop_ts do
    local line = my_frame:CreateTexture()
    line:SetColorTexture(0.8, 0.8, 0.8, 0.3)
    l_year = date('%Y', start_ts)
    l_month = date('%m', start_ts)
    l_day = date('%d', start_ts)
    if CHRONICLE_DB[REALM][PLAYER]['data'][l_year] then
      if CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month] then
        if CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month][l_day] then
        local tp = CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month][l_day]
          ['q_done']
          if tp then
            perc = tp * height_mod
            line:SetColorTexture(0.8, 0.8, 0.8, 0.9)
            perc_use = perc
          end
        end
      end
    end
    if perc_use then
      line:SetSize(5, perc_use)
      line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
      x_pos = x_pos + 5
    end
    start_ts = start_ts + 86400
  end
end

function draw_prof(prof_id)
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
  local max_skill = 600
  local cur_skill = 0
  x_pos = 0
  -- 2019-01-01
  start_ts = 1546344732
  stop_ts = time() + 86400
  x_pos = 0
  local perc_use = nil
  draw_grid_lines(my_frame)
  -- dirty way to go through dates
  while start_ts <= stop_ts do
    local line = my_frame:CreateTexture()
    line:SetColorTexture(0.8, 0.8, 0.8, 0.3)
    l_year = date('%Y', start_ts)
    l_month = date('%m', start_ts)
    l_day = date('%d', start_ts)
    if CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]
      [l_year] then
      if CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]
        [l_year][l_month] then
        if CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]
          [l_year][l_month][l_day] then
          for a, b in pairs(CHRONICLE_DB[REALM][PLAYER]['profs'][prof_id]
            [l_year][l_month][l_day]) do
            if a > cur_skill then
              cur_skill = a
            end
          end
        end
      end
    end
    if cur_skill > 0 then
      perc = cur_skill / max_skill * 100
      line:SetColorTexture(0.8, 0.8, 0.8, 0.9)
      line:SetSize(5, perc*3)
      line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
      x_pos = x_pos + 5
    end
    start_ts = start_ts + 86400
  end
end

function draw_gold()
  MAX_VAL = get_max_val('money')
  height_mod = MAX_GRAPH_HEIGHT / MAX_VAL
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
  x_pos = 0
  -- 2019-01-01
  start_ts = 1546344732
  stop_ts = time() + 86400
  x_pos = 0
  local perc_use = nil
  draw_grid_lines(my_frame)
  -- dirty way to go through dates
  while start_ts <= stop_ts do
    local line = my_frame:CreateTexture()
    line:SetColorTexture(0.8, 0.8, 0.8, 0.3)
    l_year = date('%Y', start_ts)
    l_month = date('%m', start_ts)
    l_day = date('%d', start_ts)
    if CHRONICLE_DB[REALM][PLAYER]['data'][l_year] then
      if CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month] then
        if CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month][l_day] then
        local tp = CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month][l_day]
          ['money']
          if tp then
            perc = tp * height_mod
            line:SetColorTexture(0.8, 0.8, 0.8, 0.9)
            perc_use = perc
          end
        end
      end
    end
    if perc_use then
      line:SetSize(5, perc_use)
      line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
      x_pos = x_pos + 5
    end
    start_ts = start_ts + 86400
  end
end

function get_max_val(name)
  max_val = 0
  start_ts = 1546344732
  stop_ts = time() + 86400
  while start_ts <= stop_ts do
    l_year = date('%Y', start_ts)
    l_month = date('%m', start_ts)
    l_day = date('%d', start_ts)
    if CHRONICLE_DB[REALM][PLAYER]['data'][l_year] then
      if CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month] then
        if CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month][l_day] then
        local tp = CHRONICLE_DB[REALM][PLAYER]['data'][l_year][l_month][l_day]
          [name]
          if tp then
            if tp > max_val then
              max_val = tp
            end
          end
        end
      end
    end
    start_ts = start_ts + 86400
  end
  return max_val
end

function draw_grid_lines(frame)
  local v = 0
  while v <= 10 do
    local v_line = frame:CreateTexture()
    v_line:SetColorTexture(0.8, 0.8, 0.8, 0.6)
    v_line:SetSize(600, 1)
    v_line:SetPoint("BOTTOMLEFT", frame, 0, v*50+10)
    v = v + 1
  end
  local h = 0
  while h <= 12 do
    local h_line = frame:CreateTexture()
    h_line:SetColorTexture(0.8, 0.8, 0.8, 0.6)
    h_line:SetSize(1, MAX_GRAPH_HEIGHT)
    h_line:SetPoint("BOTTOMLEFT", frame, h*50, 10)
    h = h + 1
  end
end

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
GRAPH_WIDTH = 610

SLASH_CHRONICLE1 = "/chronicle"
SlashCmdList["CHRONICLE"] = function(msg)
  frame:Show()
  draw_time_played()
end

local my_frame = nil
local scale = 1
local frameWidth = 720
local frameHeight = 550
frame = CreateFrame("Frame","ChronicleFrame",UIParent)
local texture = frame:CreateTexture()
frame:SetSize(frameWidth, frameHeight)
frame:SetPoint("CENTER")
texture:SetAllPoints()
texture:SetColorTexture(0.1, 0.1, 0.1, 1)
frame.background = texture;

-- start buttons
local buttonQ = CreateFrame("Button", nil, frame)
local buttonTP = CreateFrame("Button", nil, frame)
local buttonBS = CreateFrame("Button", nil, frame)
local buttonFishing = CreateFrame("Button", nil, frame)
local buttonMining = CreateFrame("Button", nil, frame)
local buttonGold = CreateFrame("Button", nil, frame)
local buttonAchievs = CreateFrame("Button", nil, frame)
local buttonCooking = CreateFrame("Button", nil, frame)
local buttonArchaeology = CreateFrame("Button", nil, frame)
local buttonAlchemy = CreateFrame("Button", nil, frame)
local buttonEnchanting = CreateFrame("Button", nil, frame)
local buttonEngineer = CreateFrame("Button", nil, frame)
local buttonHerbalism = CreateFrame("Button", nil, frame)
local buttonInscription = CreateFrame("Button", nil, frame)
local buttonJewelcrafting = CreateFrame("Button", nil, frame)
local buttonLeatherworking = CreateFrame("Button", nil, frame)
local buttonSkinning = CreateFrame("Button", nil, frame)
local buttonTailoring = CreateFrame("Button", nil, frame)
local buttonHKs = CreateFrame("Button", nil, frame)
--local buttonClear = CreateFrame("Button", nil, frame)
-- end buttons

frame:ClearAllPoints()
frame:SetBackdrop(nil)
frame:SetPoint("CENTER",UIParent)
frame:SetScale(scale)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("WHO_LIST_UPDATE")
frame:RegisterEvent("TIME_PLAYED_MSG")
frame:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
frame:Hide()

local frameTitle = CreateFrame("Frame", "ChronicleFrameTitle", frame)
local titleTexture = frameTitle:CreateTexture()
frameTitle:SetSize(frameWidth, 24)
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

local chartTitle = CreateFrame("Frame", "ChronicleChartTitle", frame)
local titleTexture = chartTitle:CreateTexture()
chartTitle:SetSize(GRAPH_WIDTH, 24)
titleTexture:SetAllPoints()
titleTexture:SetColorTexture(0.1, 0.1, 0.1, 1)
chartTitle.background = titleTexture;
chartTitle:ClearAllPoints()
chartTitle:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -5)
chartTitle:SetScale(scale)
chartTitle:Show()

chartTitle.text = chartTitle:CreateFontString(nil, "ARTWORK")
chartTitle.text:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
chartTitle.text:SetPoint("CENTER",0,0)

local curDate = CreateFrame("Frame", "CurDate", frame)
local titleTexture = curDate:CreateTexture()
curDate:SetSize(70, 30)
titleTexture:SetAllPoints()
titleTexture:SetColorTexture(0.1, 0.1, 0.1, 1)
curDate.background = titleTexture;
curDate:ClearAllPoints()
curDate:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 5, 10)
curDate:SetScale(scale)
curDate:Show()
curDate.text = curDate:CreateFontString(nil, "ARTWORK")
curDate.text:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
curDate.text:SetPoint("CENTER",0,0)

function create_frame()
  local frameTextInfo = CreateFrame("Frame", "FrameTextInfo", frame)
  frameTextInfo:SetSize(GRAPH_WIDTH, frameHeight-10)
  frameTextInfo:SetBackdrop({
    bgFile="Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile="Interface\\ChatFrame\\ChatFrameBackground",
    tile=true,
    tileSize=5,
    edgeSize=1,
  })
  frameTextInfo:SetBackdropColor(0.1,0.1,0.1,1)
  frameTextInfo:SetBackdropBorderColor(0.2,0.2,0.2,1)
  frameTextInfo:SetPoint("TOPLEFT", frame, "TOPLEFT", 110, -5)
  frameTextInfo:Show()
  frameTextInfo.text = frameTextInfo:CreateFontString(nil, "ARTWORK")
  frameTextInfo.text:SetFont("Fonts\\ARIALN.ttf", 13)
  frameTextInfo.text:SetPoint("CENTER",0,0)
  frame.used = true
  return frameTextInfo
end

function setupButton(btn)
	btn:SetWidth(100)
	btn:SetHeight(24)
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
  if not CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en] = {}
  end  
  if not CHRONICLE_DB[REALM][PLAYER]['profs']
    [prof_name_en]['name'] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en]['name'] = prof_name_en
  end
  if not CHRONICLE_DB[REALM][PLAYER]['profs']
    [prof_name_en][Y] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en][Y] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['profs']
    [prof_name_en][Y][m] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en][Y][m] = {}
  end
  if not CHRONICLE_DB[REALM][PLAYER]['profs']
    [prof_name_en][Y][m][d] then
    CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en][Y][m][d] = {}
  end
  local cur_skill = 0
  if CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en]['cur_skill'] then
    cur_skill = CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en]['cur_skill']
  end
  if skillLvl > cur_skill then
    if not CHRONICLE_DB[REALM][PLAYER]['profs']
      [prof_name_en][Y][m][d][skillLvl] then
      CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en][Y][m][d][skillLvl] = {}
    end
    if not CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en][Y][m][d][skillLvl]['ts'] then
      CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en]
        [Y][m][d][skillLvl]['ts'] = ts
    end
  end
  CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en]['cur_skill'] = skillLvl
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
  curDate.text:SetText(get_date().."\n"..get_time())
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
  if not CHRONICLE_DB[REALM][PLAYER]['start_ts'] then
    CHRONICLE_DB[REALM][PLAYER]['start_ts'] = time()
  end
  -- start buttons
  local btn_vpos = -5
  local btn_vpos_offset = 25
  buttonTP:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
  buttonTP:SetText("Time played")
  buttonTP:SetScript("OnClick", function()
    draw_time_played()
  end)
  setupButton(buttonTP)
  btn_vpos = btn_vpos - btn_vpos_offset
  buttonQ:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
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
  setupButton(buttonQ)
  btn_vpos = btn_vpos - btn_vpos_offset
  buttonGold:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
  buttonGold:SetText("Gold")
  buttonGold:SetScript("OnClick", function()
    draw_gold()
  end)
  setupButton(buttonGold)

  btn_vpos = btn_vpos - btn_vpos_offset
  buttonHKs:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
  buttonHKs:SetText("HKs")
  buttonHKs:SetScript("OnClick", function()
    draw_hks()
  end)
  setupButton(buttonHKs)

  btn_vpos = btn_vpos - btn_vpos_offset
  buttonAchievs:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
  buttonAchievs:SetText("Achievements")
  buttonAchievs:SetScript("OnClick", function()
    draw_achievs()
  end)
  setupButton(buttonAchievs)

  local closeButton = CreateFrame("Button", nul, frameTitle)
  closeButton:SetPoint("TOPRIGHT", frameTitle, -2, 0)
  closeButton:SetText("x")
  closeButton:SetScript("OnClick", function() 
    frame:Hide()
  end)
  setupButton(closeButton)
  closeButton:SetWidth(25)

  if CHRONICLE_DB[REALM][PLAYER]['profs'] then
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Blacksmith'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonBS:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonBS:SetText("Blacksmith")
      buttonBS:SetScript("OnClick", function()
        draw_prof("Blacksmith")
      end)
      setupButton(buttonBS)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Mining'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonMining:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonMining:SetText("Mining")
      buttonMining:SetScript("OnClick", function()
        draw_prof("Mining")
      end)
      setupButton(buttonMining)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Alchemy'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonAlchemy:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonAlchemy:SetText("Alchemy")
      buttonAlchemy:SetScript("OnClick", function()
        draw_prof("Alchemy")
      end)
      setupButton(buttonAlchemy)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Enchanting'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonEnchanting:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonEnchanting:SetText("Enchanting")
      buttonEnchanting:SetScript("OnClick", function()
        draw_prof("Enchanting")
      end)
      setupButton(buttonEnchanting)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Engineer'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonEngineer:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonEngineer:SetText("Engineer")
      buttonEngineer:SetScript("OnClick", function()
        draw_prof("Engineer")
      end)
      setupButton(buttonEngineer)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Herbalism'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonHerbalism:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonHerbalism:SetText("Herbalism")
      buttonHerbalism:SetScript("OnClick", function()
        draw_prof("Herbalism")
      end)
      setupButton(buttonHerbalism)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Inscription'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonInscription:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonInscription:SetText("Inscription")
      buttonInscription:SetScript("OnClick", function()
        draw_prof("Inscription")
      end)
      setupButton(buttonInscription)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Jewelcrafting'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonJewelcrafting:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonJewelcrafting:SetText("Jewelcrafting")
      buttonJewelcrafting:SetScript("OnClick", function()
        draw_prof("Jewelcrafting")
      end)
      setupButton(buttonJewelcrafting)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Leatherworking'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonLeatherworking:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonLeatherworking:SetText("Leatherworking")
      buttonLeatherworking:SetScript("OnClick", function()
        draw_prof("Leatherworking")
      end)
      setupButton(buttonLeatherworking)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Skinning'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonSkinning:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonSkinning:SetText("Skinning")
      buttonSkinning:SetScript("OnClick", function()
        draw_prof("Skinning")
      end)
      setupButton(buttonSkinning)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Tailoring'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonTailoring:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonTailoring:SetText("Tailoring")
      buttonTailoring:SetScript("OnClick", function()
        draw_prof("Tailoring")
      end)
      setupButton(buttonTailoring)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Cooking'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonCooking:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonCooking:SetText("Cooking")
      buttonCooking:SetScript("OnClick", function()
        draw_prof("Cooking")
      end)
      setupButton(buttonCooking)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Fishing'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonFishing:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonFishing:SetText("Fishing")
      buttonFishing:SetScript("OnClick", function()
        draw_prof("Fishing")
      end)
      setupButton(buttonFishing)
    end
    if CHRONICLE_DB[REALM][PLAYER]['profs']['Archaeology'] then
      btn_vpos = btn_vpos - btn_vpos_offset
      buttonArchaeology:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
      buttonArchaeology:SetText("Archaeology")
      buttonArchaeology:SetScript("OnClick", function()
        draw_prof("Archaeology")
      end)
      setupButton(buttonArchaeology)
    end
  end
  --btn_vpos = btn_vpos - btn_vpos_offset
  --buttonClear:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, btn_vpos)
  --buttonClear:SetText("Clear")
  --buttonClear:SetScript("OnClick", function()
  --  if my_frame then
  --    my_frame:Hide()
  --    my_frame.used = nil
  --    frameTitle.text:SetText("Chronicle")
  --  end
  --end)
  --setupButton(buttonClear)
  -- end buttons

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
function get_line_width(start_ts, stop_ts)
  local w = math.floor((stop_ts - start_ts) / 86400) + 1
  if w > 1 then
    w = (GRAPH_WIDTH - 11) / w
  else
    w = GRAPH_WIDTH - 11
  end
  return w
end
function draw_time_played()
  frameTitle.text:SetText("Chronicle - Time played")
  MAX_VAL = get_max_val('time_played')
  hours = math.floor(MAX_VAL / 3600 + 0.5)
  chartTitle.text:SetText(hours.. " hours played")
  height_mod = MAX_GRAPH_HEIGHT / MAX_VAL
  if LATEST_TIME_PLAYED then
    if my_frame then
      my_frame:Hide()
      my_frame.used = nil
    end
    my_frame = create_frame()
    start_ts = CHRONICLE_DB[REALM][PLAYER]['start_ts']
    stop_ts = time()
    line_width = get_line_width(start_ts, stop_ts)
    x_pos = 0
    draw_grid_lines(my_frame, MAX_VAL, "time", start_ts, stop_ts)
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
        line:SetSize(line_width, perc_use)
        line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
        x_pos = x_pos + line_width
      end
      start_ts = start_ts + 86400
    end
  else
    frameTextInfo.text:SetText("Data is not ready yet. Please wait couple of seconds and try again")
  end
end

function draw_quests_done()
  MAX_VAL = get_max_val('q_done')
  frameTitle.text:SetText("Chronicle - Quests")
  chartTitle.text:SetText(MAX_VAL.. " quests done")
  height_mod = MAX_GRAPH_HEIGHT / MAX_VAL
  --MAX_QUESTS = 1000
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
  x_pos = 0
  start_ts = CHRONICLE_DB[REALM][PLAYER]['start_ts']
  stop_ts = time()
  line_width = get_line_width(start_ts, stop_ts)
  x_pos = 0
  local perc_use = nil
  draw_grid_lines(my_frame, MAX_VAL, "quests", start_ts, stop_ts)
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
      line:SetSize(line_width, perc_use)
      line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
      x_pos = x_pos + line_width
    end
    start_ts = start_ts + 86400
  end
end

function draw_prof(prof_name_en)
  frameTitle.text:SetText("Chronicle - Professions")
  chartTitle.text:SetText("")
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
  local max_skill = 600
  local cur_skill = 0
  x_pos = 0
  start_ts = CHRONICLE_DB[REALM][PLAYER]['start_ts']
  stop_ts = time()
  line_width = get_line_width(start_ts, stop_ts)
  x_pos = 0
  local perc_use = nil
  draw_grid_lines(my_frame, max_skill, "prof", start_ts, stop_ts)
  -- dirty way to go through dates
  while start_ts <= stop_ts do
    local line = my_frame:CreateTexture()
    line:SetColorTexture(0.8, 0.8, 0.8, 0.3)
    l_year = date('%Y', start_ts)
    l_month = date('%m', start_ts)
    l_day = date('%d', start_ts)
    if CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en]
      [l_year] then
      if CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en]
        [l_year][l_month] then
        if CHRONICLE_DB[REALM][PLAYER]['profs'][prof_name_en]
          [l_year][l_month][l_day] then
          for a, b in pairs(CHRONICLE_DB[REALM][PLAYER]['profs']
            [prof_name_en][l_year][l_month][l_day]) do
            if a > cur_skill then
              cur_skill = a
            end
          end
        end
      end
    end
    if cur_skill > 0 then
      perc = cur_skill / max_skill * 100
      line_h = MAX_GRAPH_HEIGHT / 100 * perc
      line:SetColorTexture(0.8, 0.8, 0.8, 0.9)
      line:SetSize(line_width, line_h)
      line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
      x_pos = x_pos + line_width
    end
    start_ts = start_ts + 86400
  end
end

function draw_gold()
  frameTitle.text:SetText("Chronicle - Gold")
  MAX_VAL = get_max_val('money')
  max_gold = math.floor(MAX_VAL / 10000 + 0.5)
  chartTitle.text:SetText("Maximum gold amount - "..max_gold)
  height_mod = MAX_GRAPH_HEIGHT / MAX_VAL
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
  x_pos = 0
  start_ts = CHRONICLE_DB[REALM][PLAYER]['start_ts']
  stop_ts = time()
  line_width = get_line_width(start_ts, stop_ts)
  x_pos = 0
  local perc_use = nil
  draw_grid_lines(my_frame, MAX_VAL, "gold", start_ts, stop_ts)
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
      line:SetSize(line_width, perc_use)
      line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
      x_pos = x_pos + line_width
    end
    start_ts = start_ts + 86400
  end
end

function draw_achievs()
  frameTitle.text:SetText("Chronicle - Achievements")
  MAX_VAL = get_max_val('achievs')
  chartTitle.text:SetText(MAX_VAL.." achievents")
  height_mod = MAX_GRAPH_HEIGHT / MAX_VAL
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
  x_pos = 0
  start_ts = CHRONICLE_DB[REALM][PLAYER]['start_ts']
  stop_ts = time()
  line_width = get_line_width(start_ts, stop_ts)
  x_pos = 0
  local perc_use = nil
  draw_grid_lines(my_frame, MAX_VAL, "achievs", start_ts, stop_ts)
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
          ['achievs']
          if tp then
            perc = tp * height_mod
            line:SetColorTexture(0.8, 0.8, 0.8, 0.9)
            perc_use = perc
          end
        end
      end
    end
    if perc_use then
      line:SetSize(line_width, perc_use)
      line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
      x_pos = x_pos + line_width
    end
    start_ts = start_ts + 86400
  end
end

function draw_hks()
  frameTitle.text:SetText("Chronicle - Honorable kills")
  MAX_VAL = get_max_val('hk_total')
  chartTitle.text:SetText("Total honorable kills - "..MAX_VAL)
  height_mod = MAX_GRAPH_HEIGHT / MAX_VAL
  if my_frame then
    my_frame:Hide()
    my_frame.used = nil
  end
  my_frame = create_frame()
  x_pos = 0
  start_ts = CHRONICLE_DB[REALM][PLAYER]['start_ts']
  stop_ts = time()
  line_width = get_line_width(start_ts, stop_ts)
  x_pos = 0
  local perc_use = nil
  draw_grid_lines(my_frame, MAX_VAL, "hk_total", start_ts, stop_ts)
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
          ['hk_total']
          if tp then
            perc = tp * height_mod
            line:SetColorTexture(0.8, 0.8, 0.8, 0.9)
            perc_use = perc
          end
        end
      end
    end
    if perc_use then
      line:SetSize(line_width, perc_use)
      line:SetPoint("BOTTOMLEFT", my_frame, x_pos, 10)
      x_pos = x_pos + line_width
    end
    start_ts = start_ts + 86400
  end
end

function get_max_val(name)
  max_val = 0
  start_ts = CHRONICLE_DB[REALM][PLAYER]['start_ts']
  stop_ts = time()
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

function draw_grid_lines(frame, max_val, val_type, start_ts, stop_ts)
  local cur_ts = start_ts
  local v = 0
  while v <= 10 do
    cur_val = max_val / 10 * v
    if val_type == "time" then
      cur_val = math.floor(cur_val / 3600 + 0.5)
      cur_val = cur_val.." hours"
    elseif val_type == "gold" then
      cur_val = math.floor(cur_val / 10000 + 0.5)
      cur_val = cur_val.." gold"
    else
      cur_val = math.floor(cur_val + 0.5)
    end
    local v_line = frame:CreateTexture()
    v_line:SetColorTexture(0.8, 0.8, 0.8, 0.6)
    v_line:SetSize(600, 1)
    v_line:SetPoint("BOTTOMLEFT", frame, 0, v*50+10)
    if v > 0 then
      v_line.text = frame:CreateFontString(nil, "ARTWORK")
      v_line.text:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
      v_line.text:SetPoint("BOTTOMLEFT", 3, v*50+5)
      v_line.text:SetText(cur_val)
    end
    v = v + 1
  end
  local h = 0
  while h <= 12 do
    local h_line = frame:CreateTexture()
    h_line:SetColorTexture(0.8, 0.8, 0.8, 0.6)
    h_line:SetSize(1, MAX_GRAPH_HEIGHT)
    h_line:SetPoint("BOTTOMLEFT", frame, h*50, 10)
    cur_ts = cur_ts + ((stop_ts - start_ts) / 12)
    cur_dt = date('%Y.%m.%d', cur_ts)
    if h > 0 then
      if (h % 2 == 1) then
        h_line.text = frame:CreateFontString(nil, "ARTWORK")
        h_line.text:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
        h_line.text:SetPoint("BOTTOMLEFT", h*50-22, 10)
        h_line.text:SetText(cur_dt)
      end
    end
    h = h + 1
  end
end

function get_date()
  local timestamp = time()
  local dt = date('%Y.%m.%d', timestamp)
  return dt
end

function get_time()
  local timestamp = time()
  local dt = date('%H:%M', timestamp)
  return dt
end

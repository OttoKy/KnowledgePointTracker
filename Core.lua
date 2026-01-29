-- ProfessionKnowledgeTracker - Core.lua
-- Simple on-screen tracker + optional settings UI + TomTom clickable treasures

local addonName, PKT = ...

local mainFrame
local settingsFrame

-- ============================================================================
-- CONFIG (UI defaults)
-- ============================================================================
local Config = {
    fontFace = "Fonts\\ARIALN.TTF",
    fontSize = 11,
    headerFontSize = 12,
    bookFontSize = 10,
    lineSpacing = 2,

    frameWidth = 390,
    padding = 8,

    anchorPoint = "TOPLEFT",
    anchorX = 16,
    anchorY = -120,

    backgroundColor = { 0, 0, 0, 0.70 },
    headerColor = { 1, 0.82, 0, 1 },        -- Gold
    completeColor = { 0.45, 0.45, 0.45, 1 },-- Dim gray
    incompleteColor = { 1, 1, 1, 1 },       -- White
    progressColor = { 0.4, 1, 0.4, 1 },     -- Green
    warningColor = { 1, 0.55, 0, 1 },       -- Orange

    professionColors = {
        Alchemy = { 0.5, 0.8, 1 },
        Blacksmithing = { 0.8, 0.6, 0.4 },
        Enchanting = { 0.8, 0.5, 1 },
        Engineering = { 1, 0.8, 0.2 },
        Inscription = { 0.9, 0.8, 0.6 },
        Jewelcrafting = { 1, 0.4, 0.6 },
        Leatherworking = { 0.7, 0.5, 0.3 },
        Tailoring = { 1, 0.7, 0.9 },
        Mining = { 0.7, 0.7, 0.7 },
        Herbalism = { 0.4, 1, 0.4 },
        Skinning = { 1, 0.8, 0.5 },
    },
}

-- ============================================================================
-- SAVED VARIABLES + SETTINGS
-- ============================================================================
PKT_DB = PKT_DB or {}

local DEFAULT_SETTINGS = {
    selected_expansion = "TWW",              -- Current expansion to track

    track_weekly_quest = true,
    track_repeatable_treasures = true,
    track_weekly_gathering = true,
    track_treatise = true,
    track_one_time_treasures = true,
    track_books = true,

    show_have_treatise = true,           -- show "you have it, use it"
    hide_completed_professions = true,   -- hide professions with nothing to do
    show_done_lines = false,             -- show explicit Done lines

    font_size = 11,
    frame_width = 390,
}

local function InitSettings()
    PKT_DB.settings = PKT_DB.settings or {}
    for k, v in pairs(DEFAULT_SETTINGS) do
        if PKT_DB.settings[k] == nil then
            PKT_DB.settings[k] = v
        end
    end
end

local function S(key)
    local settings = PKT_DB.settings
    if settings and settings[key] ~= nil then return settings[key] end
    return DEFAULT_SETTINGS[key]
end

-- ============================================================================
-- UI SETTINGS (font size / width)
-- ============================================================================
local floor, max, min = math.floor, math.max, math.min
local unpack = unpack or table.unpack
local format = string.format
local gsub = string.gsub
local wipe = wipe
local time = time

local function Clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

local function ApplyUISettings()
    local fs = tonumber(S("font_size")) or Config.fontSize
    fs = Clamp(floor(fs + 0.5), 8, 20)

    Config.fontSize = fs
    Config.headerFontSize = Clamp(fs + 1, 9, 22)
    Config.bookFontSize = Clamp(fs - 1, 8, 20)

    local w = tonumber(S("frame_width")) or Config.frameWidth
    w = Clamp(floor((w + 5) / 10) * 10, 260, 700)
    Config.frameWidth = w

    if mainFrame then
        mainFrame:SetWidth(Config.frameWidth)
        if mainFrame.title then
            mainFrame.title:SetFont(Config.fontFace, max(12, Config.headerFontSize), "OUTLINE")
        end
    end
end

-- ============================================================================
-- UTILITY
-- ============================================================================
local function Trim(s)
    if type(s) ~= "string" then return "" end
    s = gsub(s, "^%s+", "")
    s = gsub(s, "%s+$", "")
    return s
end

local function GetItemCountSafe(itemID)
    local fn = _G.GetItemCount
    if type(fn) ~= "function" then return 0 end
    local count = fn(itemID, true)
    if type(count) ~= "number" then return 0 end
    return count
end

local function IsQuestComplete(questID)
    if not questID then return false end
    if not C_QuestLog or not C_QuestLog.IsQuestFlaggedCompleted then return false end
    return C_QuestLog.IsQuestFlaggedCompleted(questID) == true
end

local function HeaderHexColor(rgb, name)
    local r = max(0, min(255, floor((rgb[1] or 1) * 255 + 0.5)))
    local g = max(0, min(255, floor((rgb[2] or 1) * 255 + 0.5)))
    local b = max(0, min(255, floor((rgb[3] or 1) * 255 + 0.5)))
    return format("|cff%02x%02x%02x%s|r", r, g, b, name)
end

-- ============================================================================
-- GATHERING WEEKLY POOL FIX
-- Only for gathering professions with questIDs pool:
--   Herbalism, Mining, Skinning
--
-- Fixes:
--  1) "any of the 5 completed => done"
--  2) quest completion flag sometimes updates late -> record QUEST_TURNED_IN
--  3) optional: display active quest title if it is in quest log
-- ============================================================================

local gatheringWeeklySet = nil

local function BuildGatheringWeeklySet()
    local set = {}
    local weeklyQuests = PKT.GetWeeklyQuests()
    if weeklyQuests then
        local targets = { Herbalism = true, Mining = true, Skinning = true }
        for profName, data in pairs(weeklyQuests) do
            if targets[profName] and type(data) == "table" and type(data.questIDs) == "table" then
                for i = 1, #data.questIDs do
                    local qid = data.questIDs[i]
                    if type(qid) == "number" then
                        set[qid] = true
                    end
                end
            end
        end
    end
    gatheringWeeklySet = set
end

local function IsGatheringWeeklyQuestID(qid)
    if not gatheringWeeklySet then
        BuildGatheringWeeklySet()
    end
    return gatheringWeeklySet and gatheringWeeklySet[qid] == true
end

local function GetSecondsUntilWeeklyResetSafe()
    if C_DateAndTime and type(C_DateAndTime.GetSecondsUntilWeeklyReset) == "function" then
        local s = C_DateAndTime.GetSecondsUntilWeeklyReset()
        if type(s) == "number" and s > 0 then
            return s
        end
    end
    return 7 * 24 * 60 * 60
end

local function GetGatheringWeeklyState()
    PKT_DB.gatherWeeklyState = PKT_DB.gatherWeeklyState or { resetAt = 0, completed = {} }
    if type(PKT_DB.gatherWeeklyState.completed) ~= "table" then
        PKT_DB.gatherWeeklyState.completed = {}
    end
    if type(PKT_DB.gatherWeeklyState.resetAt) ~= "number" then
        PKT_DB.gatherWeeklyState.resetAt = 0
    end
    return PKT_DB.gatherWeeklyState
end

local function GatheringWeeklyMaybeReset()
    local st = GetGatheringWeeklyState()
    local now = time()
    if now >= (st.resetAt or 0) then
        st.completed = {}
        st.resetAt = now + GetSecondsUntilWeeklyResetSafe()
    end
    return st
end

local function RecordGatheringWeeklyTurnIn(questID)
    if type(questID) ~= "number" then return end
    if not IsGatheringWeeklyQuestID(questID) then return end
    local st = GatheringWeeklyMaybeReset()
    st.completed[questID] = true
end

local function IsQuestInLog(questID)
    if not questID then return false end
    if C_QuestLog and type(C_QuestLog.GetLogIndexForQuestID) == "function" then
        return C_QuestLog.GetLogIndexForQuestID(questID) ~= nil
    end
    return false
end

local function GetQuestTitleSafe(questID)
    if not questID then return nil end
    if C_QuestLog and type(C_QuestLog.GetTitleForQuestID) == "function" then
        local title = C_QuestLog.GetTitleForQuestID(questID)
        if type(title) == "string" and title ~= "" then
            return title
        end
    end
    return nil
end

local function FindActiveQuestFromPool(questIDs)
    if type(questIDs) ~= "table" then return nil end
    for i = 1, #questIDs do
        local qid = questIDs[i]
        if IsQuestInLog(qid) then
            return qid
        end
    end
    return nil
end

-- ============================================================================
-- PROFESSION DETECTION (reliable at login)
-- Uses base skillLineID from GetProfessionInfo -> PKT.SkillLineNames
-- ============================================================================
local playerProfessions = {}
local scratchProfNames = {}

local function DetectProfessions()
    wipe(playerProfessions)

    if type(GetProfessions) ~= "function" or type(GetProfessionInfo) ~= "function" then
        return
    end

    local p1, p2 = GetProfessions()

    local function AddProfession(profIndex)
        if not profIndex then return end
        -- Returns: name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLineID, skillModifier
        local _, _, _, _, _, _, skillLineID = GetProfessionInfo(profIndex)
        if type(skillLineID) ~= "number" then return end

        if PKT and PKT.SkillLineNames and PKT.SkillLineNames[skillLineID] then
            local base = PKT.SkillLineNames[skillLineID]
            playerProfessions[base] = true
        end
    end

    AddProfession(p1)
    AddProfession(p2)
end

-- ============================================================================
-- TOMTOM INTEGRATION (click treasure line -> waypoint + arrow)
-- ============================================================================
local lastTomTomWaypoint = nil

local function TomTom_ClearLast()
    if lastTomTomWaypoint and TomTom and type(TomTom.RemoveWaypoint) == "function" then
        TomTom:RemoveWaypoint(lastTomTomWaypoint)
    end
    lastTomTomWaypoint = nil
end

local function TomTom_SetTreasureWaypoint(t)
    if not TomTom then
        print("|cffffd200PKT:|r TomTom not loaded.")
        return
    end

    local x, y = t.x, t.y
    if type(x) ~= "number" or type(y) ~= "number" then
        print("|cffffd200PKT:|r No coords stored for: " .. (t.name or "Treasure"))
        return
    end

    if x > 1 then x = x / 100 end
    if y > 1 then y = y / 100 end

    local opts = {
        title = t.name or "Treasure",
        persistent = false,
        minimap = true,
        world = true,
        crazy = true,
    }

    TomTom_ClearLast()

    local uid
    if t.mapID and type(TomTom.AddWaypoint) == "function" then
        uid = TomTom:AddWaypoint(t.mapID, x, y, opts)
    elseif t.zone and type(TomTom.AddZWaypoint) == "function" then
        uid = TomTom:AddZWaypoint(t.zone, x, y, opts)
    else
        print("|cffffd200PKT:|r Can't set TomTom waypoint (missing mapID and/or AddZWaypoint).")
        return
    end

    lastTomTomWaypoint = uid

    if uid and type(TomTom.SetCrazyArrow) == "function" then
        TomTom:SetCrazyArrow(uid, 20, t.name or "Treasure")
    end

    print("|cff00ff00PKT:|r Waypoint set: " .. (t.name or "Treasure"))
end

-- ============================================================================
-- DATA HELPERS
-- ============================================================================
local function IsWeeklyQuestComplete(profName)
    local weeklyQuests = PKT.GetWeeklyQuests()
    local data = weeklyQuests and weeklyQuests[profName]
    if not data then return true end

    -- Gathering pools: Herbalism/Mining/Skinning
    if data.questIDs then
        local st = GatheringWeeklyMaybeReset()
        for _, qid in ipairs(data.questIDs) do
            if st.completed[qid] or IsQuestComplete(qid) then
                return true
            end
        end
        return false
    end

    -- Single questID (crafting professions)
    if not data.questID then return true end
    return IsQuestComplete(data.questID)
end



local function GetBookStatus(bookData)
    return IsQuestComplete(bookData.questID)
end

local function GetIncompleteBooks(profName)
    local incomplete = {}

    if PKT.GetRenownBooksForProfession then
        local renownBooks = PKT.GetRenownBooksForProfession(profName)
        for i = 1, #renownBooks do
            local book = renownBooks[i]
            if book and book.questID and not GetBookStatus(book) then
                incomplete[#incomplete + 1] = {
                    type = "renown",
                    name = book.name,
                    kp = book.kp,
                    faction = book.faction,
                    renown = book.renown,
                    vendor = book.vendor,
                }
            end
        end
    end

    local artisanBooks = PKT.GetArtisanBooks()
    local profArtisanBooks = artisanBooks and artisanBooks[profName]
    if profArtisanBooks then
        for i = 1, #profArtisanBooks do
            local book = profArtisanBooks[i]
            if book and book.questID and not GetBookStatus(book) then
                incomplete[#incomplete + 1] = {
                    type = "artisan",
                    name = book.name,
                    kp = book.kp,
                    cost = book.cost,
                }
            end
        end
    end

    local kejBooks = PKT.GetKejBooks()
    local kejBook = kejBooks and kejBooks[profName]
    if kejBook and kejBook.questID and not GetBookStatus(kejBook) then
        incomplete[#incomplete + 1] = {
            type = "kej",
            name = kejBook.name,
            kp = kejBook.kp,
            cost = kejBook.cost,
        }
    end

    return incomplete
end

-- ============================================================================
-- UI (line widgets)
-- ============================================================================
local contentLines = {}

local function CreateLineWidget(parent)
    local btn = CreateFrame("Button", nil, parent)
    btn:Hide()

    btn.text = btn:CreateFontString(nil, "OVERLAY")
    btn.text:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
    btn.text:SetPoint("TOPRIGHT", btn, "TOPRIGHT", 0, 0)
    btn.text:SetJustifyH("LEFT")
    btn.text:SetJustifyV("TOP")
    btn.text:SetWordWrap(true)
    btn.text:SetNonSpaceWrap(true)

    btn._onClick = nil
    btn._tooltip = nil
    btn._hoverColor = nil
    btn._baseColor = { 1, 1, 1, 1 }

    btn:SetScript("OnClick", function(self)
        if self._onClick then
            self._onClick()
        end
    end)

    btn:SetScript("OnEnter", function(self)
        if self._hoverColor then
            self.text:SetTextColor(unpack(self._hoverColor))
        end
        if self._tooltip then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(self._tooltip, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)

    btn:SetScript("OnLeave", function(self)
        if self._baseColor then
            self.text:SetTextColor(unpack(self._baseColor))
        end
        if GameTooltip:IsOwned(self) then
            GameTooltip:Hide()
        end
    end)

    return btn
end

local function CreateMainFrame()
    local frame = CreateFrame("Frame", "PKT_MainFrame", UIParent, "BackdropTemplate")
    frame:SetSize(Config.frameWidth, 120)
    frame:SetPoint(Config.anchorPoint, UIParent, Config.anchorPoint, Config.anchorX, Config.anchorY)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")

    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    frame:SetBackdropColor(unpack(Config.backgroundColor))

    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, x, y = self:GetPoint()
        PKT_DB.position = { point = point, relPoint = relPoint, x = x, y = y }
    end)

    local title = frame:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT", frame, "TOPLEFT", Config.padding, -Config.padding)
    title:SetFont(Config.fontFace, 12, "OUTLINE")
    title:SetText("|cffffd700Knowledge Tracker|r")
    frame.title = title

    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
    closeBtn:SetSize(20, 20)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)

    local gearBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    gearBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -22, -4)
    gearBtn:SetSize(22, 18)
    gearBtn:SetText("S")
    frame.gearBtn = gearBtn

    local content = CreateFrame("Frame", nil, frame)
    content:SetPoint("TOPLEFT", frame, "TOPLEFT", Config.padding, -28)
    content:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -Config.padding, Config.padding)
    frame.content = content

    return frame
end

local function CreateSettingsFrame()
    local f = CreateFrame("Frame", "PKT_SettingsFrame", UIParent, "BackdropTemplate")
    f:SetSize(380, 510)  -- Increased height for expansion dropdown
    f:SetPoint("CENTER")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")

    f:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0, 0, 0, 0.85)

    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    local title = f:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
    title:SetFont(Config.fontFace, 13, "OUTLINE")
    title:SetText("|cffffd700PKT Settings|r")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
    closeBtn:SetSize(20, 20)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local function CreateCheckbox(label, key, x, y)
        local cb = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        cb:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
        cb.Text:SetFont(Config.fontFace, 11, "OUTLINE")
        cb.Text:SetText(label)

        cb:SetScript("OnShow", function(self)
            self:SetChecked(S(key))
        end)

        cb:SetScript("OnClick", function(self)
            PKT_DB.settings[key] = self:GetChecked() and true or false
            if mainFrame and mainFrame:IsShown() then
                PKT.UpdateDisplay()
            end
        end)

        return cb
    end

    local y = -40
    local x = 16

    -- =====================
    -- EXPANSION SELECTOR
    -- =====================
    local expHeader = f:CreateFontString(nil, "OVERLAY")
    expHeader:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
    expHeader:SetFont(Config.fontFace, 12, "OUTLINE")
    expHeader:SetText("|cffffd700Expansion|r")

    y = y - 22
    local expLabel = f:CreateFontString(nil, "OVERLAY")
    expLabel:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
    expLabel:SetFont(Config.fontFace, 11, "OUTLINE")
    expLabel:SetText("Track knowledge for:")

    -- Create dropdown for expansion selection
    local expDropdown = CreateFrame("Frame", "PKT_ExpansionDropdown", f, "UIDropDownMenuTemplate")
    expDropdown:SetPoint("TOPLEFT", f, "TOPLEFT", x + 120, y + 5)
    UIDropDownMenu_SetWidth(expDropdown, 150)

    local function ExpDropdown_OnClick(self, arg1)
        PKT_DB.settings.selected_expansion = arg1
        UIDropDownMenu_SetText(expDropdown, PKT.Expansions[arg1].name)
        -- Rebuild gathering weekly set for new expansion
        gatheringWeeklySet = nil
        BuildGatheringWeeklySet()
        if mainFrame and mainFrame:IsShown() then
            PKT.UpdateDisplay()
        end
    end

    local function ExpDropdown_Initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for _, expKey in ipairs(PKT.ExpansionOrder) do
            local expData = PKT.Expansions[expKey]
            info.text = expData.name
            info.arg1 = expKey
            info.func = ExpDropdown_OnClick
            info.checked = (S("selected_expansion") == expKey)
            UIDropDownMenu_AddButton(info, level)
        end
    end

    UIDropDownMenu_Initialize(expDropdown, ExpDropdown_Initialize)

    f:SetScript("OnShow", function(self)
        local currentExp = S("selected_expansion") or "TWW"
        local expData = PKT.Expansions[currentExp]
        UIDropDownMenu_SetText(expDropdown, expData and expData.name or "The War Within")
    end)

    y = y - 35
    local hdr1 = f:CreateFontString(nil, "OVERLAY")
    hdr1:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
    hdr1:SetFont(Config.fontFace, 12, "OUTLINE")
    hdr1:SetText("|cffffd700Track sources|r")

    y = y - 22
    CreateCheckbox("Weekly quest / crafting order quest", "track_weekly_quest", x, y)
    y = y - 22
    CreateCheckbox("Repeatable treasures (weekly)", "track_repeatable_treasures", x, y)
    y = y - 22
    CreateCheckbox("Weekly gathering / disenchanting drops", "track_weekly_gathering", x, y)
    y = y - 22
    CreateCheckbox("Algari Treatise (weekly)", "track_treatise", x, y)
    y = y - 22
    CreateCheckbox("One-time treasures (clickable with TomTom)", "track_one_time_treasures", x, y)
    y = y - 22
    CreateCheckbox("Books (Renown / Artisan / Kej)", "track_books", x, y)

    y = y - 30
    local hdr2 = f:CreateFontString(nil, "OVERLAY")
    hdr2:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
    hdr2:SetFont(Config.fontFace, 12, "OUTLINE")
    hdr2:SetText("|cffffd700Display|r")

    y = y - 22
    CreateCheckbox("Show Treatise if you already have it", "show_have_treatise", x, y)
    y = y - 22
    CreateCheckbox("Hide professions with nothing to do", "hide_completed_professions", x, y)
    y = y - 22
    CreateCheckbox("Show explicit 'Done' lines", "show_done_lines", x, y)

    y = y - 34
    local fontSlider = CreateFrame("Slider", "PKT_FontSizeSlider", f, "OptionsSliderTemplate")
    fontSlider:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
    fontSlider:SetWidth(300)
    fontSlider:SetMinMaxValues(9, 18)
    fontSlider:SetValueStep(1)
    fontSlider:SetObeyStepOnDrag(true)
    _G[fontSlider:GetName() .. "Low"]:SetText("9")
    _G[fontSlider:GetName() .. "High"]:SetText("18")

    local function UpdateFontSliderText(val)
        _G[fontSlider:GetName() .. "Text"]:SetText("Font size: " .. tostring(val))
    end

    fontSlider:SetScript("OnShow", function(self)
        self._init = true
        local val = tonumber(S("font_size")) or Config.fontSize
        val = floor(val + 0.5)
        self:SetValue(val)
        UpdateFontSliderText(val)
        self._init = false
    end)

    fontSlider:SetScript("OnValueChanged", function(self, value)
        if self._init then return end
        local v = floor(value + 0.5)
        PKT_DB.settings.font_size = v
        ApplyUISettings()
        UpdateFontSliderText(v)
        if mainFrame and mainFrame:IsShown() then
            PKT.UpdateDisplay()
        end
    end)

    y = y - 54
    local widthSlider = CreateFrame("Slider", "PKT_FrameWidthSlider", f, "OptionsSliderTemplate")
    widthSlider:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
    widthSlider:SetWidth(300)
    widthSlider:SetMinMaxValues(280, 650)
    widthSlider:SetValueStep(10)
    widthSlider:SetObeyStepOnDrag(true)
    _G[widthSlider:GetName() .. "Low"]:SetText("280")
    _G[widthSlider:GetName() .. "High"]:SetText("650")

    local function UpdateWidthSliderText(val)
        _G[widthSlider:GetName() .. "Text"]:SetText("Frame width: " .. tostring(val))
    end

    widthSlider:SetScript("OnShow", function(self)
        self._init = true
        local val = tonumber(S("frame_width")) or Config.frameWidth
        val = floor((val + 5) / 10) * 10
        self:SetValue(val)
        UpdateWidthSliderText(val)
        self._init = false
    end)

    widthSlider:SetScript("OnValueChanged", function(self, value)
        if self._init then return end
        local v = floor((value + 5) / 10) * 10
        PKT_DB.settings.frame_width = v
        ApplyUISettings()
        UpdateWidthSliderText(v)
        if mainFrame and mainFrame:IsShown() then
            PKT.UpdateDisplay()
        end
    end)

    local resetPos = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    resetPos:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 12)
    resetPos:SetSize(110, 22)
    resetPos:SetText("Reset position")
    resetPos:SetScript("OnClick", function()
        PKT_DB.position = nil
        if mainFrame then
            mainFrame:ClearAllPoints()
            mainFrame:SetPoint(Config.anchorPoint, UIParent, Config.anchorPoint, Config.anchorX, Config.anchorY)
        end
    end)

    local okBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    okBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 12)
    okBtn:SetSize(70, 22)
    okBtn:SetText("Close")
    okBtn:SetScript("OnClick", function() f:Hide() end)

    f:Hide()
    return f
end

local function ToggleSettings()
    if not settingsFrame then
        settingsFrame = CreateSettingsFrame()
    end
    if settingsFrame:IsShown() then settingsFrame:Hide() else settingsFrame:Show() end
end

-- ============================================================================
-- DISPLAY UPDATE
-- ============================================================================
function PKT.UpdateDisplay()
    if not mainFrame or not mainFrame:IsShown() then return end

    DetectProfessions()

    for _, line in ipairs(contentLines) do
        line:Hide()
        line._onClick = nil
        line._tooltip = nil
        line._hoverColor = nil
    end

    local content = mainFrame.content
    local yOffset = 0
    local lineIndex = 0
    local totalHeight = 28

    local function AddLine(text, color, indent, style, onClick, tooltip)
        lineIndex = lineIndex + 1
        local row = contentLines[lineIndex]
        if not row then
            row = CreateLineWidget(content)
            contentLines[lineIndex] = row
        end

        local fs
        local wrap
        if style == "header" then
            fs = Config.headerFontSize
            wrap = false
        elseif style == "book" then
            fs = Config.bookFontSize
            wrap = true
        else
            fs = Config.fontSize
            wrap = true
        end

        row.text:SetFont(Config.fontFace, fs, "OUTLINE")
        row.text:SetWordWrap(wrap)

        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", content, "TOPLEFT", indent or 0, yOffset)
        row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, yOffset)

        local c = color or { 1, 1, 1, 1 }
        row._baseColor = c
        row.text:SetTextColor(unpack(c))
        row.text:SetText(text or "")
        row:Show()

        row._onClick = onClick
        row._tooltip = tooltip

        if onClick then
            row._hoverColor = { 1, 0.82, 0, 1 } -- gold hover
        else
            row._hoverColor = nil
        end

        local h = row.text:GetStringHeight() or 12
        local step = max(12, h) + (Config.lineSpacing or 0)
        row:SetHeight(max(12, h))
        yOffset = yOffset - step
        totalHeight = totalHeight + step
    end

    if not next(playerProfessions) then
        AddLine("No tracked professions detected", { 0.7, 0.7, 0.7, 1 }, 0, "normal")
        mainFrame:SetHeight(max(totalHeight + Config.padding * 2, 60))
        return
    end

    wipe(scratchProfNames)
    for profName in pairs(playerProfessions) do
        scratchProfNames[#scratchProfNames + 1] = profName
    end
    table.sort(scratchProfNames)

    local hasAny = false

    -- Get expansion-specific data
    local weeklyQuests = PKT.GetWeeklyQuests()
    local weeklyTreasureItems = PKT.GetWeeklyTreasureItems()
    local weeklyGatheringItems = PKT.GetWeeklyGatheringItems()
    local treatiseItems = PKT.GetTreatiseItems()
    local treasures = PKT.GetTreasures()

    for i = 1, #scratchProfNames do
        local profName = scratchProfNames[i]
        local profColor = Config.professionColors[profName] or { 1, 1, 1, 1 }

        local function PushLine(text, color, indent, style, onClick, tooltip)
            AddLine(text, color, indent, style, onClick, tooltip)
        end

        local function AddMissingCount(label, count)
            if count and count > 0 then
                PushLine(format("• %s: %d", label, count), Config.incompleteColor, 10, "normal")
            end
        end

        local before = lineIndex

        AddLine(HeaderHexColor(profColor, profName), profColor, 0, "header")

        -- =====================
        -- WEEKLY QUESTS
        -- =====================
        if S("track_weekly_quest") then
            local weeklyQuestData = weeklyQuests and weeklyQuests[profName]
            if weeklyQuestData and (weeklyQuestData.questID or weeklyQuestData.questIDs) then
                if not IsWeeklyQuestComplete(profName) then
                    local label

                    if weeklyQuestData.type == "crafting_orders" then
                        label = "Crafting Services Requested"
                    elseif type(weeklyQuestData.questIDs) == "table" then
                        -- Gathering pool: show active quest title if it's in quest log, else generic
                        local activeID = FindActiveQuestFromPool(weeklyQuestData.questIDs)
                        label = (activeID and GetQuestTitleSafe(activeID)) or (weeklyQuestData.name or "Weekly Quest")
                    else
                        label = weeklyQuestData.name or "Weekly Quest"
                    end

                    AddMissingCount(label, 1)
                end
            end
        end

        if S("track_repeatable_treasures") then
            local list = weeklyTreasureItems and weeklyTreasureItems[profName]
            if list then
                local missing = 0
                for j = 1, #list do
                    local item = list[j]
                    if item then
                        local done = item.questID and IsQuestComplete(item.questID)
                        if not done then
                            missing = missing + 1
                            if item.itemID and GetItemCountSafe(item.itemID) > 0 then
                                PushLine(format("• In bags — use it: %s", item.name or ("Item " .. tostring(item.itemID))),
                                    Config.progressColor, 18, "book")
                            end
                        end
                    end
                end
                AddMissingCount("Repeatable Treasures", missing)
            end
        end

        if S("track_weekly_gathering") then
            local data = weeklyGatheringItems and weeklyGatheringItems[profName]
            if data and data.blue and data.purple then
                local method = (profName == "Enchanting") and "Disenchanting" or "Gathering"

                local blueDone = 0
                if type(data.blue.questIDs) == "table" then
                    for k = 1, #data.blue.questIDs do
                        if IsQuestComplete(data.blue.questIDs[k]) then
                            blueDone = blueDone + 1
                        end
                    end
                elseif data.blue.questID then
                    blueDone = IsQuestComplete(data.blue.questID) and 1 or 0
                end
                blueDone = min(blueDone, data.blue.max or blueDone)

                local purpleDone = 0
                if data.purple.questID then
                    purpleDone = IsQuestComplete(data.purple.questID) and 1 or 0
                elseif type(data.purple.questIDs) == "table" then
                    for k = 1, #data.purple.questIDs do
                        if IsQuestComplete(data.purple.questIDs[k]) then
                            purpleDone = purpleDone + 1
                        end
                    end
                end
                purpleDone = min(purpleDone, data.purple.max or purpleDone)

                local blueRemaining = max(0, (data.blue.max or 0) - blueDone)
                local purpleRemaining = max(0, (data.purple.max or 0) - purpleDone)

                AddMissingCount(format("%s (%s)", data.blue.name, method), blueRemaining)
                AddMissingCount(format("%s (%s)", data.purple.name, method), purpleRemaining)
            end
        end

        if S("track_treatise") then
            local treatise = treatiseItems and treatiseItems[profName]
            if treatise and treatise.questID then
                local usedThisWeek = IsQuestComplete(treatise.questID)
                local count = treatise.itemID and GetItemCountSafe(treatise.itemID) or 0

                if usedThisWeek then
                    if S("show_done_lines") then
                        PushLine("• Treatise: Done", Config.completeColor, 10, "normal")
                    end
                else
                    if count > 0 then
                        if S("show_have_treatise") then
                            PushLine("• Treatise — in inventory (use it)", Config.progressColor, 10, "normal")
                        end
                    else
                        AddMissingCount("Treatise", 1)
                    end
                end
            end
        end

        -- =====================
        -- ONE-TIME TREASURES (LIST + TOMTOM CLICK)
        -- =====================
        if S("track_one_time_treasures") then
            local list = treasures and treasures[profName]
            if list then
                local remaining = 0
                for j = 1, #list do
                    local t = list[j]
                    if t and t.questID and not IsQuestComplete(t.questID) then
                        remaining = remaining + 1

                        local hasCoords = (type(t.x) == "number" and type(t.y) == "number")
                        local clickable = (TomTom ~= nil) and hasCoords and (t.mapID ~= nil or t.zone ~= nil)

                        local suffix = ""
                        if not hasCoords then
                            suffix = " |cffaaaaaa(no coords yet)|r"
                        elseif not TomTom then
                            suffix = " |cffaaaaaa(TomTom not loaded)|r"
                        end

                        local lineText = format("• Treasure: %s%s", t.name or ("Quest " .. tostring(t.questID)), suffix)

                        if clickable then
                            PushLine(
                                lineText,
                                Config.incompleteColor,
                                10,
                                "normal",
                                function() TomTom_SetTreasureWaypoint(t) end,
                                "Click to set TomTom waypoint + arrow"
                            )
                        else
                            PushLine(lineText, Config.incompleteColor, 10, "normal")
                        end
                    end
                end

                if remaining == 0 and S("show_done_lines") then
                    PushLine("• Treasures (one-time): Done", Config.completeColor, 10, "normal")
                end
            end
        end

        -- =====================
        -- BOOKS
        -- =====================
        if S("track_books") then
            local incompleteBooks = GetIncompleteBooks(profName)
            for j = 1, #incompleteBooks do
                local book = incompleteBooks[j]
                local textLine

                if book.type == "renown" then
                    if book.vendor and book.vendor ~= "" then
                        textLine = format("• Renown %d — %s (Vendor: %s): %s", book.renown or 0, book.faction or "Renown", book.vendor, book.name)
                    else
                        textLine = format("• Renown %d — %s: %s", book.renown or 0, book.faction or "Renown", book.name)
                    end
                elseif book.type == "artisan" then
                    textLine = format("• Artisan — %s (Cost: %d Acuity)", book.name, book.cost or 0)
                elseif book.type == "kej" then
                    textLine = format("• Kej — %s (Cost: %d Kej)", book.name, book.cost or 565)
                end

                if textLine then
                    PushLine(textLine, Config.incompleteColor, 18, "book")
                end
            end
        end

        local addedAfterHeader = (lineIndex - before - 1)
        local shouldShow = (addedAfterHeader > 0) or (not S("hide_completed_professions"))

        if not shouldShow then
            contentLines[before + 1]:Hide()
            lineIndex = before
        else
            hasAny = true

            if addedAfterHeader == 0 and S("show_done_lines") then
                PushLine("• Done", Config.completeColor, 10, "normal")
            end

            yOffset = yOffset - 4
            totalHeight = totalHeight + 4
        end
    end

    if not hasAny then
        AddLine("|cff00ff00Nothing to do this week.|r", Config.progressColor, 0, "normal")
    end

    mainFrame:SetHeight(max(totalHeight + Config.padding * 2, 60))
end

-- ============================================================================
-- EVENTS
-- ============================================================================
local isInitialized = false
local updateTimer = nil

local function ScheduleUpdate()
    if updateTimer then return end
    updateTimer = C_Timer.NewTimer(0.5, function()
        updateTimer = nil
        PKT.UpdateDisplay()
    end)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("SKILL_LINES_CHANGED")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("QUEST_TURNED_IN")
eventFrame:RegisterEvent("QUEST_ACCEPTED")

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        InitSettings()
        ApplyUISettings()

        -- init weekly reset state early
        GatheringWeeklyMaybeReset()
        BuildGatheringWeeklySet()

        if PKT_DB.position then
            local pos = PKT_DB.position
            mainFrame = CreateMainFrame()
            mainFrame:ClearAllPoints()
            mainFrame:SetPoint(pos.point, UIParent, pos.relPoint, pos.x, pos.y)
        end

    elseif event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
        if not isInitialized then
            isInitialized = true
            if not mainFrame then
                mainFrame = CreateMainFrame()
            end
            mainFrame:Show()

            if mainFrame.gearBtn then
                mainFrame.gearBtn:SetScript("OnClick", ToggleSettings)
            end

            C_Timer.After(1.0, PKT.UpdateDisplay)
        end

    elseif event == "QUEST_TURNED_IN" then
        -- arg1 = questID
        RecordGatheringWeeklyTurnIn(arg1)

        -- Update soon, and again a bit later (covers delayed completion flag updates)
        ScheduleUpdate()
        C_Timer.After(1.5, function()
            if PKT and PKT.UpdateDisplay then
                PKT.UpdateDisplay()
            end
        end)

    elseif event == "SKILL_LINES_CHANGED" or event == "BAG_UPDATE" or event == "QUEST_ACCEPTED" then
        ScheduleUpdate()
    end
end)

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================
SLASH_PKT1 = "/pkt"
SLASH_PKT2 = "/profknowledge"

SlashCmdList["PKT"] = function(msg)
    msg = Trim((msg or ""):lower())

    if msg == "show" then
        if not mainFrame then mainFrame = CreateMainFrame() end
        mainFrame:Show()
        PKT.UpdateDisplay()

    elseif msg == "hide" then
        if mainFrame then mainFrame:Hide() end

    elseif msg == "settings" or msg == "config" or msg == "options" then
        ToggleSettings()

    elseif msg == "reset" then
        PKT_DB.position = nil
        if mainFrame then
            mainFrame:ClearAllPoints()
            mainFrame:SetPoint(Config.anchorPoint, UIParent, Config.anchorPoint, Config.anchorX, Config.anchorY)
        end

    else
        if mainFrame and mainFrame:IsShown() then
            mainFrame:Hide()
        else
            if not mainFrame then mainFrame = CreateMainFrame() end
            mainFrame:Show()
            PKT.UpdateDisplay()
        end
    end
end
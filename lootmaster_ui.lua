--[[
  EPGP Lootmaster module - UI Stuff
]]--

local mod = EPGP:NewModule("lootmaster_ui")
local lootmaster = EPGP:GetModule("lootmaster")
local L = LibStub("AceLocale-3.0"):GetLocale("EPGP")
local GS = LibStub("LibGuildStorage-1.0")
local gptooltip = EPGP:GetModule("gptooltip")
local lootmaster = EPGP:GetModule("lootmaster")
local callbacks = EPGP.callbacks
local Debug = LibStub("LibDebug-1.0", true)

local rows = {}
local rowdata = {}
local maxrows = 25

local columns = {
  { text="C",          width=20,   name="class", align="CENTER",
    popup="Click this column to sort by class."},

  { text="Candidate",  width=80,   name="candidate",
    popup="Click this column to sort by name of the candidate."},

  { text="Rank",       width=70,   name="guildrank",
    popup="Click this column to sort by guildrank."},

  { text="Status",     width=90,   name="status",
    popup="Click this column to sort by response/status."},

  { text="EP",         width=55,   name="ep", align="RIGHT",
    popup="Click this column to sort by Effort Points (EP)."},

  { text="GP",         width=55,   name="gp", align="RIGHT",
    popup="Click this column to sort by Gear Points (GP)."},

  { text="PR",         width=55,   name="pr", align="RIGHT",
    popup="Click this column to sort by EPGP Priority (PR)."},

  { text="Roll",       width=25,   name="roll", align="RIGHT",
    popup="Click this column to sort by random roll."},

  { text="N",          width=20,   name="note", align="CENTER",
    popup="Click this column to sort by candidate note."},

  { text="Equipment",  width=120,  name="equipment", align="CENTER",
    popup="Click this column to sort by difference in itemlevel compared to current item."}
}

function mod:OnEnable()
  self:BuildUI()
end

--- TODO(mackatack) make a proper builder
--  Really just a testing function, once everything looks as
--  it should i will make separate functions for all the visual components.
function mod:BuildUI()
  local f = self:CreateEPGPFrame()
  local sp = f.table

  -- Candidate selection panel:
  local lmf = CreateFrame("Frame", nil, f)
  lmf:SetPoint("TOPLEFT", f, "TOPLEFT", 80, -60)
  lmf:SetPoint("RIGHT", f, "RIGHT", 0, 0)

  -- Create icon
  local icon = CreateFrame("Button", "EPGPLM_CURRENTITEMICON", lmf, "AutoCastShineTemplate")
  icon:EnableMouse()
  icon:SetNormalTexture("Interface/ICONS/INV_Misc_QuestionMark")
  icon:SetPoint("TOPLEFT", lmf, "TOPLEFT", 0, 0)
  icon:SetHeight(48)
  icon:SetWidth(48)

  local btn = CreateFrame("Button", nil, lmf, "UIPanelButtonTemplate")
  btn:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 10, 2)
  btn:SetHeight(25)
  btn:SetWidth(85)
  btn:SetText("Mainspec")
  btn:SetScript("OnEnter", function()
    self:ShowInfoPopup("Mainspec", "Use this selection if this item is a major upgrade "..
                                   "for your main talent build and you wish to spend GP "..
                                   "on it. For small upgrades, use the Minor Upgrade button instead.")
  end)
  btn:SetScript("OnLeave", self.HideInfoPopup)
  local btnMainspec = btn

  btn = CreateFrame("Button", nil, lmf, "UIPanelButtonTemplate")
  btn:SetPoint("BOTTOMLEFT", btnMainspec, "BOTTOMRIGHT", 1, 0)
  btn:SetHeight(25)
  btn:SetWidth(115)
  btn:SetText("Minor upgrade")
  btn:SetScript("OnEnter", function()
  self:ShowInfoPopup("Minor Upgrade", "Use this selection if the item is only a small upgrade "..
                                      "for your main talent build and you wish to give the item "..
                                      "to players if they need it more than you.")
  end)
  btn:SetScript("OnLeave", self.HideInfoPopup)
  local btnUpgrade = btn

  btn = CreateFrame("Button", nil, lmf, "UIPanelButtonTemplate")
  btn:SetPoint("BOTTOMLEFT", btnUpgrade, "BOTTOMRIGHT", 1, 0)
  btn:SetHeight(25)
  btn:SetWidth(70)
  btn:SetText("Offspec")
  btn:SetScript("OnEnter", function()
    self:ShowInfoPopup("Offspec", "Use this selection if this item is an upgrade for your secondary "..
                                  "talent build.")
  end)
  btn:SetScript("OnLeave", self.HideInfoPopup)
  local btnOffspec = btn

  btn = CreateFrame("Button", nil, lmf, "UIPanelButtonTemplate")
  btn:SetPoint("BOTTOMLEFT", btnOffspec, "BOTTOMRIGHT", 1, 0)
  btn:SetHeight(25)
  btn:SetWidth(95)
  btn:SetText("Greed / Alt")
  btn:SetScript("OnEnter", function()
    self:ShowInfoPopup("Greed / Alt / Roll", "Use this selection if you wish to use this item for "..
                                      "a third talent build or on an alt. Greeds are roll based by "..
                                      "default, yet still take MinEP into account.")
  end)
  btn:SetScript("OnLeave", self.HideInfoPopup)
  local btnGreed = btn

  btn = CreateFrame("Button", nil, lmf, "UIPanelButtonTemplate")
  btn:SetPoint("BOTTOMLEFT", btnGreed, "BOTTOMRIGHT", 1, 0)
  btn:SetHeight(25)
  btn:SetWidth(55)
  btn:SetText("Pass")
  btn:SetScript("OnEnter", function()
    self:ShowInfoPopup("Pass", "Use this selection if you do not wish to bid "..
                                   "on the item. Another player will receive it.")
  end)
  btn:SetScript("OnLeave", self.HideInfoPopup)
  local btnPass = btn

  local timer = self:CreateTimeoutBar(lmf)
  timer:SetPoint("LEFT", btnPass, "RIGHT", 5, 0)

  local color = ITEM_QUALITY_COLORS[4]
  if not color then
    color = ITEM_QUALITY_COLORS[1]
  end
  local lblItemLink = lmf:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  lblItemLink:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, 1)
  lblItemLink:SetVertexColor(color.r, color.g, color.b)
  lblItemLink:SetText("[Uber leet epix item]")

  local lblItemInfo = lmf:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  lblItemInfo:SetPoint("RIGHT", timer, "RIGHT", 0, 0)
  lblItemInfo:SetPoint("TOP", lblItemLink, "TOP", 0, -5)
  lblItemInfo:SetVertexColor(1, 1, 1)
  lblItemInfo:SetText("GP 252 or 99, BoP, Lootmaster: Bushmaster")

end

function mod:CreateEPGPFrame()
  -- EPGPLootmasterFrame
  if self.frame then return self.frame end

  local f = CreateFrame("Frame", "EPGPLootmasterFrame", UIParent)
  self.frame = f
  f:Show() -- TODO(mackatack) Obviously for testing purposes, final version will be hidden at first.
  f:SetToplevel(true)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:SetAttribute("UIPanelLayout-defined", true)
  f:SetAttribute("UIPanelLayout-enabled", true)
  f:SetAttribute("UIPanelLayout-area", "left")
  f:SetAttribute("UIPanelLayout-pushable", 5)
  f:SetAttribute("UIPanelLayout-whileDead", true)

  f:SetWidth(718)
  f:SetHeight(512)
  f:SetPoint("TOPLEFT", nil, "TOPLEFT", 0, -104)
  f:SetHitRectInsets(0, 30, 0, 45)

  f:SetBackdrop({
    bgFile = "Interface\\Addons\\epgp\\images\\frame_bg",
    tile = true, tileSize = 128,
    insets = { left = 13, right = 22, top = 15, bottom = 10 }
  })

  local icon = f:CreateTexture(nil, "BORDER")
  icon:SetTexture("Interface\\PetitionFrame\\GuildCharter-Icon")
  icon:SetWidth(60)
  icon:SetHeight(60)
  icon:SetPoint("TOPLEFT", f, "TOPLEFT", 7, -6)

  local tl = f:CreateTexture(nil, "ARTWORK")
  tl:SetTexture("Interface\\AddOns\\epgp\\images\\frame")
  tl:SetWidth(102.4)
  tl:SetHeight(102.4)--76.8)
  tl:SetTexCoordModifiesRect(false)
  tl:SetTexCoord(0, 0.4, 0, 0.4)
  tl:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)

  local tr = f:CreateTexture(nil, "OVERLAY")
  tr:SetTexture("Interface\\AddOns\\epgp\\images\\frame")
  tr:SetWidth(102.4)
  tr:SetHeight(102.4)
  tr:SetTexCoordModifiesRect(false)
  tr:SetTexCoord(0.6, 1, 0, 0.4)
  tr:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)

  local top = f:CreateTexture(nil, "OVERLAY")
  top:SetTexture("Interface\\AddOns\\epgp\\images\\frame", true)
  top:SetHeight(102.4)
  top:SetTexCoordModifiesRect(false)
  top:SetTexCoord(0.4, 0.6, 0, 0.4)
  top:SetPoint("TOPLEFT", tl, "TOPRIGHT", 0, 0)
  top:SetPoint("TOPRIGHT", tr, "TOPLEFT", 0, 0)

  local bl = f:CreateTexture(nil, "OVERLAY")
  bl:SetTexture("Interface\\AddOns\\epgp\\images\\frame")
  bl:SetWidth(102.4)
  bl:SetHeight(102.4)
  bl:SetTexCoord(0, 0.4, 0.6, 1)
  bl:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)

  local br = f:CreateTexture(nil, "OVERLAY")
  br:SetTexture("Interface\\AddOns\\epgp\\images\\frame")
  br:SetWidth(102.4)
  br:SetHeight(102.4)
  br:SetTexCoordModifiesRect(false)
  br:SetTexCoord(0.6, 1, 0.6, 1)
  br:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)

  local bottom = f:CreateTexture(nil, "OVERLAY")
  bottom:SetTexture("Interface\\AddOns\\epgp\\images\\frame", true)
  bottom:SetHeight(102.4)
  bottom:SetTexCoordModifiesRect(false)
  bottom:SetTexCoord(0.4, 0.6, 0.6, 1)
  bottom:SetPoint("BOTTOMLEFT", bl, "BOTTOMRIGHT", 0, 0)
  bottom:SetPoint("BOTTOMRIGHT", br, "BOTTOMLEFT", 0, 0)

  local left = f:CreateTexture(nil, "OVERLAY")
  left:SetTexture("Interface\\AddOns\\epgp\\images\\frame", true)
  left:SetWidth(102.4)
  left:SetTexCoordModifiesRect(false)
  left:SetTexCoord(0, 0.4, 0.4, 0.6)
  left:SetPoint("TOPLEFT", tl, "BOTTOMLEFT", 0, 0)
  left:SetPoint("BOTTOMLEFT", bl, "TOPLEFT", 0, 0)

  local right = f:CreateTexture(nil, "ARTWORK")
  right:SetTexture("Interface\\AddOns\\epgp\\images\\frame", true)
  right:SetWidth(102.4)
  right:SetTexCoordModifiesRect(false)
  right:SetTexCoord(0.6, 1, 0.4, 0.6)
  right:SetPoint("TOPRIGHT", tr, "BOTTOMRIGHT", 0, 0)
  right:SetPoint("BOTTOMRIGHT", br, "TOPRIGHT", 0, 0)

  local caption = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  caption:SetWidth(250)
  caption:SetHeight(16)
  caption:SetPoint("TOP", f, "TOP", 3, -16)
  caption:SetText("EPGP Lootmaster (wip) "..EPGP.version)
  f.caption = caption
  
  local btnClose = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  btnClose:SetPoint("TOPRIGHT", f, "TOPRIGHT", -15, -8)
  
  self:CreateTable(f)

  -- Create some data for the table
  local lastRow
  local num = GetNumGuildMembers(true)
  self:SetTableNumItems(num)
  for i=1, num do
    local name, guildrank, _, _, _, _, _, _, online = GetGuildRosterInfo(i)

    tinsert(rowdata, {
      name      = name,
      guildrank = guildrank,
      online    = online
    })
  end
  
  self:UpdateTable()

  return f
end

function mod:CreateTimeoutBar(parent)
  local timerFrame = CreateFrame("Frame", nil, parent)
  timerFrame:SetHeight(20)
  timerFrame:SetWidth(115)
  timerFrame:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    tile = true, tileSize = 64, edgeSize = 12,
    insets = { left = 2, right = 1, top = 2, bottom = 2 }
  })
  timerFrame:SetBackdropColor(1, 0, 0, 0.4)
  timerFrame:SetBackdropBorderColor(1, 0.6980392, 0, 0)

  local lblTimeout
  local b = CreateFrame("STATUSBAR", nil, timerFrame, "TextStatusBar")
  local bCount = 99
  local bElapse = 0
  b:SetPoint("TOPLEFT", timerFrame, "TOPLEFT", 3, -3)
  b:SetPoint("BOTTOMRIGHT", timerFrame, "BOTTOMRIGHT", -2, 3)
  b:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
  b:SetStatusBarColor(0.4, 0.8, 0.4, 0.8)
  b:SetMinMaxValues(0, 99)
  b:SetScript("OnUpdate", function(o, elapsed)
      if not lblTimeout then return end
      bElapse = bElapse + elapsed
      if bElapse<1 then return end
      bElapse = 0
      lblTimeout:SetText(format("Pass in %d secs", bCount))
      b:SetValue(bCount)
      bCount = bCount - 1
      if bCount<0 then bCount=99 end
  end)
  timerFrame.progressBar = b

  local timerBorderFrame = CreateFrame("Frame", nil, timerFrame)
  timerBorderFrame:SetToplevel(true)
  timerBorderFrame:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 64, edgeSize = 12,
    insets = {left = 2, right = 1, top = 2, bottom = 2}
  })
  timerBorderFrame:SetBackdropColor(1, 0, 0, 0.0)
  timerBorderFrame:SetBackdropBorderColor(1, 0.6980392, 0, 1)
  timerBorderFrame:SetPoint("TOPLEFT", timerFrame, "TOPLEFT", 0, 0)
  timerBorderFrame:SetPoint("BOTTOMRIGHT", timerFrame, "BOTTOMRIGHT", 0, 0)

  lblTimeout = timerBorderFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  lblTimeout:SetPoint("CENTER", timerBorderFrame, "CENTER", 1, 0)
  lblTimeout:SetVertexColor(1, 1, 1)
  lblTimeout:SetText("timeout")

  timerFrame:Show()

  return timerFrame
end

function mod:SetTableNumItems(num)
  num = num - maxrows
  local slider = self.tableSlider
  if num>0 then
    slider:Enable()
    slider:SetMinMaxValues(0, num)
    local offset = slider:GetValue()
    if offset>num then
      slider:SetValue(num)
    end
  else
    slider:Disable()
    slider:SetMinMaxValues(0, 0)
    slider:SetValue(0)
  end
end

-- All the drawing magic happens in here. We have complete control of the
-- row and cell objects in here. This function also allows us to just update
-- a single row.
function mod:UpdateRow(rowID, rowData, rowObj, rowNum)

  -- colObjs holds a table of cells named by the name in the columns table.
  local colObjs = rowObj.colObjs

  if rowData.online then
    colObjs.status:SetText("ONLINE")
  else
    colObjs.status:SetText("")
  end
  
  local class = select(1,EPGP:GetClass(rowData.name)) or select(2,UnitClass(rowData.name))
  local color = RAID_CLASS_COLORS[class];
  if not color then color = ITEM_QUALITY_COLORS[1] end
  
  -- Set candidate name and color
  colObjs.candidate:SetText(rowData.name)
  colObjs.candidate.text:SetVertexColor(color.r, color.g, color.b)
  
  -- Set candidate class icon
  if class then
    local classObj = colObjs.class
    -- Set the texture and position just once
    if not classObj.classIcon then
      classObj:SetNormalTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
      local classIcon = classObj:GetNormalTexture()
      classIcon:ClearAllPoints()
      classIcon:SetPoint("RIGHT", classObj, "RIGHT", -2, 0)
      classIcon:SetHeight(13)
      classIcon:SetWidth(13)
      classObj.classIcon = classIcon      
    end
    local coords = CLASS_ICON_TCOORDS[class]
    if coords then
      classObj:Show()
      classObj.classIcon:SetTexCoord(coords[1],coords[2],coords[3],coords[4]);
    else
      classObj:Hide()
    end
  else
    colObjs.class:Hide()
  end
  
  
  colObjs.guildrank:SetText(rowData.guildrank)

  local ep, gp, main = EPGP:GetEPGP(rowData.name)
  colObjs.ep:SetText(ep)
  colObjs.equipment:SetText(rowID)
  colObjs.gp:SetText(gp)
  colObjs.pr:SetText(pr)
  colObjs.roll:SetText(math.random(1,99))
end

function mod:UpdateTable(offset)
  local offset = offset or self.tableSlider:GetValue()
  local tableObj = self.table

  for rowNum=1, maxrows do
    local rowID = rowNum + offset
    
    local rowData = rowdata[rowID]

    -- Lazy creation of rows and cells
    local rowObj = rows[rowNum]
    if not rowObj and rowData then
      rowObj = self:CreateTableRow(tableObj)
      rows[rowNum] = rowObj
      if rowNum>1 then
        rowObj:SetPoint("TOP", rows[rowNum-1], "BOTTOM", 0, 0)
      else
        rowObj:SetPoint("TOP", tableObj, "TOP", 0, -5)
      end
    end

    -- Do we have data? 
    if rowData then
      -- show the row and update it
      rowObj:Show()
      self:UpdateRow(rowID, rowData, rowObj, rowNum)
    elseif rowObj then
      -- No data, just hide the row
      rowObj:Hide()
    end
  end
end

function mod:CreateTableCell(parent, previousCell)
  local cell = CreateFrame("Button", nil, parent)
  cell:RegisterForClicks("AnyUp")
  cell:SetPushedTextOffset(0,0)
  cell:SetPoint("TOP", parent, "TOP")
  cell:SetPoint("BOTTOM", parent, "BOTTOM")
  if previousCell then
    cell:SetPoint("LEFT", previousCell, "RIGHT")
  else
    cell:SetPoint("LEFT", parent, "LEFT")
  end

  local text = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  text:SetPoint("TOPLEFT", cell, "TOPLEFT", 3, 0)
  text:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -3, 0)
  cell.text = text
  cell.SetText = function (self, value) return text:SetText(value) end
  cell.GetText = function (self) return text:GetText() end
  
  return cell
end

function mod:CreateTableRow(parent)
  local row = CreateFrame("Button", nil, parent)
  row:SetPoint("LEFT", parent, "LEFT")
  row:SetPoint("RIGHT", parent, "RIGHT")
  row:SetHeight(14)
  row.colObjs = {}
  
  -- I've used a table "columns" to define the columnswidths, names, alignments etc
  -- We could also create every cell manually, whatever you think is nicer.
  local previousCell
  for colNum, colData in ipairs(columns) do
    local cell = self:CreateTableCell(row, previousCell)
    
    cell.text:SetJustifyH(colData.align or "LEFT")
    cell:SetWidth(colData.width or 20)
    
    if colData.name then
      row.colObjs[colData.name] = cell
    end
    previousCell = cell
  end

  return row
end

function mod:CreateTable(parent)
  local tableBackground = CreateFrame("Frame", "EPGPLMScrollTable", parent)
  tableBackground:SetBackdrop({
    bgFile = "Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 512, edgeSize = 12,
    insets = { left = 2, right = 1, top = 1, bottom = 2 }
  })
  tableBackground:SetPoint("TOPLEFT", parent, "TOPLEFT", 80, -140)
  tableBackground:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -25, 13)
  tableBackground:EnableMouseWheel(true) 
  self.table = tableBackground

  local slider = CreateFrame("Slider", "EPGPLMScrollbar", tableBackground, "UIPanelScrollBarTemplateLightBorder")
  self.tableSlider = slider
  slider:SetPoint("TOPRIGHT", tableBackground, "TOPRIGHT", -5, -21)
  slider:SetPoint("BOTTOMRIGHT", tableBackground, "BOTTOMRIGHT", -5, 20)
  slider:SetScript("OnValueChanged", function(obj, offset)
    self:UpdateTable(offset)
  end)
  slider:SetMinMaxValues(0,0)
  slider:SetValueStep(1)
  slider:SetValue(0)
  slider:SetWidth(15)
  slider:Disable()
  
  -- Change the behaviour of the slider buttons a little
  EPGPLMScrollbarScrollDownButton:SetScript("OnClick", function()
    slider:SetValue(slider:GetValue()+5)
    PlaySound("UChatScrollButton");
  end)
  EPGPLMScrollbarScrollUpButton:SetScript("OnClick", function()
    slider:SetValue(slider:GetValue()-5)
    PlaySound("UChatScrollButton");
  end)
  
  -- Scroll the table when the user uses the mousewheel
  tableBackground:SetScript("OnMouseWheel", function(obj, delta)
    local value = slider:GetValue()
    if delta>0 and value == 0 then return end
    --TODO(mackatack): also check upper bound
    slider:SetValue(value - delta)
  end)
  
  -- Make column headers
  local lastHeader
  for i, colData in ipairs(columns) do
    local header = self:CreateTableHeader(tableBackground)
    header:SetText(colData.text)
    header:SetWidth(colData.width)
    header:SetScript("OnEnter", function()
      self:ShowInfoPopup("Sorting", colData.popup)
    end)
    header:SetScript("OnLeave", self.HideInfoPopup)
    if lastHeader then      
      header:SetPoint("TOPLEFT", lastHeader, "TOPRIGHT", 0, 0)
    else
      header:SetPoint("BOTTOMLEFT", tableBackground, "TOPLEFT", 0, -2)
    end
    lastHeader = header
  end
end

function mod:ShowInfoPopup(...)
  if not self.frame then return end
  GameTooltip:SetOwner(self.frame, "ANCHOR_NONE")
  for i=1, select("#", ...) do
    if i==1 then
      GameTooltip:AddLine(tostring(select(i, ...)), 1, 1, 1)
    else
      GameTooltip:AddLine(tostring(select(i, ...)), nil, nil, nil, true)
    end
  end
  GameTooltip:Show()
  GameTooltip:ClearAllPoints()
  GameTooltip:SetPoint("TOPLEFT", self.frame , "TOPRIGHT", -15, -13)
end

function mod:HideInfoPopup()
  GameTooltip:Hide()
end

function mod:CreateTableHeader(parent)
  local h = CreateFrame("Button", nil, parent)
  h:SetHeight(20)

  h:SetNormalFontObject("GameFontHighlightSmall")
  h:GetNormalFontObject():SetJustifyH("CENTER")
  h:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight", "ADD")

  local tl = h:CreateTexture(nil, "BACKGROUND")
  tl:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
  tl:SetWidth(5)
  tl:SetHeight(20)
  tl:SetPoint("TOPLEFT")
  tl:SetTexCoord(0, 0.07815, 0, 0.625)

  local tr = h:CreateTexture(nil, "BACKGROUND")
  tr:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
  tr:SetWidth(3)
  tr:SetHeight(20)
  tr:SetPoint("TOPRIGHT")
  --tr:SetTexCoord(0.90625, 0.96875, 0, 0.625)
  tr:SetTexCoord(0.07815, 0, 0, 0.625)

  local tm = h:CreateTexture(nil, "BACKGROUND")
  tm:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
  tm:SetHeight(20)
  tm:SetPoint("LEFT", tl, "RIGHT")
  tm:SetPoint("RIGHT", tr, "LEFT")
  tm:SetTexCoord(0.07815, 0.90625, 0, 0.625)

  return h
end

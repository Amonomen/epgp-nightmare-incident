--[[ EPGP User Interface ]]--

local mod = EPGP:NewModule("EPGP_UI")
local L = LibStub("AceLocale-3.0"):GetLocale("EPGP")
local GS = LibStub("LibGuildStorage-1.0")
local GPTooltip = EPGP:GetModule("EPGP_GPTooltip")

local CURRENT_VERSION = GetAddOnMetadata('EPGP', 'Version')
if not CURRENT_VERSION or #CURRENT_VERSION == 0 then
  CURRENT_VERSION = "(development)"
end

local BUTTON_TEXT_PADDING = 20
local BUTTON_HEIGHT = 22
local ROW_TEXT_PADDING = 5

local function Debug(fmt, ...)
  DEFAULT_CHAT_FRAME:AddMessage(string.format(fmt, ...))
end

local function DebugFrame(frame, r, g, b)
  local t = frame:CreateTexture()
  t:SetAllPoints(frame)
  t:SetTexture(r or 0, g or 1, b or 0, 0.05)
end

local SIDEFRAMES = {}
local function ToggleOnlySideFrame(frame)
  for _,f in ipairs(SIDEFRAMES) do
    if f == frame then
      if f:IsShown() then
        f:Hide()
      else
        f:Show()
      end
    else
      f:Hide()
    end
  end
end

local function CreateEPGPFrame()
  -- EPGPFrame
  local f = CreateFrame("Frame", "EPGPFrame", UIParent)
  f:Hide()
  f:SetToplevel(true)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:SetAttribute("UIPanelLayout-defined", true)
  f:SetAttribute("UIPanelLayout-enabled", true)
  f:SetAttribute("UIPanelLayout-area", "left")
  f:SetAttribute("UIPanelLayout-pushable", 5)
  f:SetAttribute("UIPanelLayout-whileDead", true)

  f:SetWidth(384)
  f:SetHeight(512)
  f:SetPoint("TOPLEFT", nil, "TOPLEFT", 0, -104)
  f:SetHitRectInsets(0, 30, 0, 45)

  local t = f:CreateTexture(nil, "BACKGROUND")
  t:SetTexture("Interface\\PetitionFrame\\GuildCharter-Icon")
  t:SetWidth(60)
  t:SetHeight(60)
  t:SetPoint("TOPLEFT", f, "TOPLEFT", 7, -6)

  t = f:CreateTexture(nil, "ARTWORK")
  t:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-TopLeft")
  t:SetWidth(256)
  t:SetHeight(256)
  t:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)

  t = f:CreateTexture(nil, "ARTWORK")
  t:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-TopRight")
  t:SetWidth(128)
  t:SetHeight(256)
  t:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)

  t = f:CreateTexture(nil, "ARTWORK")
  t:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-General-BottomLeft")
  t:SetWidth(256)
  t:SetHeight(256)
  t:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)

  t = f:CreateTexture(nil, "ARTWORK")
  t:SetTexture(
    "Interface\\PaperDollInfoFrame\\UI-Character-General-BottomRight")
  t:SetWidth(128)
  t:SetHeight(256)
  t:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)

  t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  t:SetWidth(250)
  t:SetHeight(16)
  t:SetPoint("TOP", f, "TOP", 3, -16)
  t:SetText("EPGP "..CURRENT_VERSION)

  local cb = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  cb:SetPoint("TOPRIGHT", f, "TOPRIGHT", -30, -8)

  f:SetScript("OnHide", ToggleOnlySideFrame)
end

local function CreateTableHeader(parent)
  local h = CreateFrame("Button", nil, parent)
  h:SetHeight(24)

  local tl = h:CreateTexture(nil, "BACKGROUND")
  tl:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
  tl:SetWidth(5)
  tl:SetHeight(24)
  tl:SetPoint("TOPLEFT")
  tl:SetTexCoord(0, 0.07815, 0, 0.75)

  local tr = h:CreateTexture(nil, "BACKGROUND")
  tr:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
  tr:SetWidth(5)
  tr:SetHeight(24)
  tr:SetPoint("TOPRIGHT")
  tr:SetTexCoord(0.90625, 0.96875, 0, 0.75)

  local tm = h:CreateTexture(nil, "BACKGROUND")
  tm:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
  tm:SetHeight(24)
  tm:SetPoint("LEFT", tl, "RIGHT")
  tm:SetPoint("RIGHT", tr, "LEFT")
  tm:SetTexCoord(0.07815, 0.90625, 0, 0.75)

  local hl = h:CreateTexture()
  h:SetHighlightTexture(
    "Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight", "ADD")
  hl:SetPoint("TOPLEFT", tl, "TOPLEFT", -2, 5)
  hl:SetPoint("BOTTOMRIGHT", tr, "BOTTOMRIGHT", 2, -7)

  return h
end

local function CreateTableRow(parent, rowHeight, widths, justifiesH)
  local row = CreateFrame("Button", nil, parent)
  row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
  row:SetHeight(rowHeight)
  row:SetPoint("LEFT")
  row:SetPoint("RIGHT")

  row.cells = {}
  for i,w in ipairs(widths) do
    local c = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    c:SetHeight(rowHeight)
    c:SetWidth(w - (2 * ROW_TEXT_PADDING))
    c:SetJustifyH(justifiesH[i])
    if #row.cells == 0 then
      c:SetPoint("LEFT", row, "LEFT", ROW_TEXT_PADDING, 0)
    else
      c:SetPoint("LEFT", row.cells[#row.cells], "RIGHT", 2 * ROW_TEXT_PADDING, 0)
    end
    table.insert(row.cells, c)
    c:SetText(w)
  end

  return row
end

local function CreateTable(parent, texts, widths, justfiesH, rightPadding)
  assert(#texts == #widths and #texts == #justfiesH,
         "All specification tables must be the same size")
  -- Compute widths
  local totalFixedWidths = rightPadding or 0
  local numDynamicWidths = 0
  for i,w in ipairs(widths) do
    if w > 0 then
      totalFixedWidths = totalFixedWidths + w
    else
      numDynamicWidths = numDynamicWidths + 1
    end
  end
  local remainingWidthSpace = parent:GetWidth() - totalFixedWidths
  assert(remainingWidthSpace >= 0, "Widths specified exceed parent width")

  local dynamicWidth = math.floor(remainingWidthSpace / numDynamicWidths)
  local leftoverWidth = remainingWidthSpace % numDynamicWidths
  for i,w in ipairs(widths) do
    if w <= 0 then
      numDynamicWidths = numDynamicWidths - 1
      if numDynamicWidths then
        widths[i] = dynamicWidth
      else
        widths[i] = dynamicWidth + leftoverWidth
      end
    end
  end

  -- Make headers
  parent.headers = {}
  for i=1,#texts do
    local text, width, justifyH = texts[i], widths[i], justfiesH[i]
    local h = CreateTableHeader(parent, text, width)
    h:SetNormalFontObject("GameFontHighlightSmall")
    h:SetText(text)
    h:GetFontString():SetJustifyH(justifyH)
    h:SetWidth(width)
    if #parent.headers == 0 then
      h:SetPoint("TOPLEFT")
    else
      h:SetPoint("TOPLEFT", parent.headers[#parent.headers], "TOPRIGHT")
    end
    table.insert(parent.headers, h)
  end

  -- Make a frame for the rows
  local rowFrame = CreateFrame("Frame", nil, parent)
  rowFrame:SetPoint("TOP", parent.headers[#parent.headers], "BOTTOM")
  rowFrame:SetPoint("BOTTOMLEFT")
  rowFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -rightPadding, 0)
  parent.rowFrame = rowFrame

  -- Compute number of rows
  local fontHeight = select(2, GameFontNormalSmall:GetFont())
  local rowHeight = fontHeight + 4
  rowFrame.rowHeight = rowHeight
  local numRows = math.floor(rowFrame:GetHeight() / rowHeight)

  -- Make rows
  rowFrame.rows = {}
  for i=1,numRows do
    local r = CreateTableRow(rowFrame, rowHeight, widths, justfiesH)
    if #rowFrame.rows == 0 then
      r:SetPoint("TOP")
    else
      r:SetPoint("TOP", rowFrame.rows[#rowFrame.rows], "BOTTOM")
    end
    table.insert(rowFrame.rows, r)
  end
end

local function CreateEPGPLogFrame()
  local f = CreateFrame("Frame", "EPGPLogFrame", EPGPFrame)
  table.insert(SIDEFRAMES, f)

  f:Hide()
  f:SetWidth(435)
  f:SetHeight(435)
  f:SetPoint("TOPLEFT", EPGPFrame, "TOPRIGHT", -37, -6)

  local t = f:CreateTexture(nil, "OVERLAY")
  t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Corner")
  t:SetWidth(32)
  t:SetHeight(32)
  t:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -7)

  t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  t:SetPoint("TOPLEFT", f, "TOPLEFT", 17, -17)
  t:SetText(L["Personal Action Log"])

  f:SetBackdrop(
    {
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true,
      tileSize = 32,
      edgeSize = 32,
      insets = { left=11, right=12, top=12, bottom=11 }
    })

  local cb = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  cb:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -3)

  local undo = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  undo:SetNormalFontObject("GameFontNormalSmall")
  undo:SetHighlightFontObject("GameFontHighlightSmall")
  undo:SetDisabledFontObject("GameFontDisableSmall")
  undo:SetHeight(BUTTON_HEIGHT)
  undo:SetText(L["Undo"])
  undo:SetWidth(undo:GetTextWidth() + BUTTON_TEXT_PADDING)
  undo:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -9, 13)
  undo:SetScript("OnClick",
                 function (self, value)
                   EPGP:GetModule("EPGP_Log"):UndoLastAction()
                 end)
  function undo:SetCurrentState()
    if EPGP:GetModule("EPGP_Log"):CanUndo() then
      self:Enable()
    else
      self:Disable()
    end
  end
  EPGP:GetModule("EPGP_Log").RegisterCallback(
    undo, "LogChanged", "SetCurrentState")
  GS.RegisterCallback(undo, "StateChanged", "SetCurrentState")

  local redo = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  redo:SetNormalFontObject("GameFontNormalSmall")
  redo:SetHighlightFontObject("GameFontHighlightSmall")
  redo:SetDisabledFontObject("GameFontDisableSmall")
  redo:SetHeight(BUTTON_HEIGHT)
  redo:SetText(L["Redo"])
  redo:SetWidth(redo:GetTextWidth() + BUTTON_TEXT_PADDING)
  redo:SetPoint("RIGHT", undo, "LEFT")
  redo:SetScript("OnClick",
                 function (self, value)
                   EPGP:GetModule("EPGP_Log"):RedoLastUndo()
                 end)
  function redo:SetCurrentState()
    if EPGP:GetModule("EPGP_Log"):CanRedo() then
      self:Enable()
    else
      self:Disable()
    end
  end
  EPGP:GetModule("EPGP_Log").RegisterCallback(
    redo, "LogChanged", "SetCurrentState")
  GS.RegisterCallback(redo, "StateChanged", "SetCurrentState")

  local scrollParent = CreateFrame("Frame", nil, f)
  scrollParent:SetWidth(f:GetWidth() - 20)
  scrollParent:SetHeight(f:GetHeight() - 65)
  scrollParent:SetPoint("TOPLEFT", f, "TOPLEFT", 11, -32)
  scrollParent:SetBackdrop(
    {
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true,
      tileSize = 16,
      edgeSize = 16,
      insets = { left=5, right=5, top=5, bottom=5 }
    })
  scrollParent:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r,
                                      TOOLTIP_DEFAULT_COLOR.g,
                                      TOOLTIP_DEFAULT_COLOR.b)
  scrollParent:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,
                                TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,
                                TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)

  local font = "ChatFontSmall"
  local fontHeight = select(2, getglobal(font):GetFont())
  local recordHeight = fontHeight + 2
  local recordWidth = scrollParent:GetWidth() - 35
  local numLogRecordFrames = math.floor(
    (scrollParent:GetHeight() - 3) / recordHeight)
  local record = scrollParent:CreateFontString("EPGPLogRecordFrame1", "OVERLAY", font)
  record:SetHeight(recordHeight)
  record:SetWidth(recordWidth)
  record:SetMultilineIndent(false)
  record:SetPoint("TOPLEFT", scrollParent, "TOPLEFT", 5, -3)
  for i=2,numLogRecordFrames do
    record = scrollParent:CreateFontString("EPGPLogRecordFrame"..i, "OVERLAY", font)
    record:SetHeight(recordHeight)
    record:SetWidth(recordWidth)
    record:SetMultilineIndent(false)
    record:SetPoint("TOPLEFT", "EPGPLogRecordFrame"..(i-1), "BOTTOMLEFT")
  end

  local scrollBar = CreateFrame("ScrollFrame", "EPGPLogRecordScrollFrame",
                                scrollParent, "FauxScrollFrameTemplateLight")
  scrollBar:SetWidth(scrollParent:GetWidth() - 35)
  scrollBar:SetHeight(scrollParent:GetHeight() - 10)
  scrollBar:SetPoint("TOPRIGHT", scrollParent, "TOPRIGHT", -28, -6)

  function LogChanged()
    if not EPGPLogFrame:IsVisible() then
      return
    end
    local log = EPGP:GetModule("EPGP_Log")
    local offset = FauxScrollFrame_GetOffset(scrollBar)
    local numRecords = log:GetNumRecords()
    local numDisplayedRecords = math.min(numLogRecordFrames, numRecords - offset)
    for i=1,numLogRecordFrames do
      local record = getglobal("EPGPLogRecordFrame"..i)
      local logIndex = i + offset - 1
      if logIndex < numRecords then
        record:SetText(log:GetLogRecord(logIndex))
        record:SetJustifyH("LEFT")
        record:Show()
      else
        record:Hide()
      end
    end

    FauxScrollFrame_Update(
      scrollBar, numRecords, numDisplayedRecords, recordHeight)
  end

  EPGPLogFrame:SetScript("OnShow", LogChanged)
  scrollBar:SetScript(
    "OnVerticalScroll",
    function(self, value)
      FauxScrollFrame_OnVerticalScroll(scrollBar, value, recordHeight, LogChanged)
    end)
  EPGP:GetModule("EPGP_Log"):RegisterCallback("LogChanged", LogChanged)
end

local function EPGPSideFrameGPDropDown_Initialize(dropDown)
  local parent = dropDown:GetParent()
  for i=1,GPTooltip:GetNumRecentItems() do
    local info = UIDropDownMenu_CreateInfo()
    local _, itemLink = GetItemInfo(GPTooltip:GetRecentItemID(i))
    info.text = itemLink
    info.arg1 = itemLink
    info.func = function(self, arg1)
                  UIDropDownMenu_SetSelectedID(dropDown, self:GetID())
                  local text = GPTooltip:GetGPValueText(arg1)
                  parent.editBox:SetText(text)
                  parent.editBox:SetFocus()
                  parent.editBox:HighlightText()
                  parent.button:SetCurrentState()
                end
    UIDropDownMenu_AddButton(info)
  end
end

local function AddGPControls(frame)
  local reasonLabel =
    frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  reasonLabel:SetText(L["GP Reason"])
  reasonLabel:SetPoint("TOPLEFT")

  local dropDown = CreateFrame("Frame", "$parentGPControlDropDown",
                               frame, "UIDropDownMenuTemplate")
  dropDown:EnableMouse(true)
  UIDropDownMenu_Initialize(dropDown, EPGPSideFrameGPDropDown_Initialize)
  UIDropDownMenu_SetWidth(dropDown, 150)
  UIDropDownMenu_JustifyText(dropDown, "LEFT")
  dropDown:SetPoint("TOPLEFT", reasonLabel, "BOTTOMLEFT")
  getglobal(dropDown:GetName().."Button"):SetScript(
    "OnEnter",
    function(self)
      local itemLink = UIDropDownMenu_GetText(self:GetParent())
      if itemLink then
        GameTooltip:SetOwner(self:GetParent(), "ANCHOR_RIGHT", 5)
        GameTooltip:SetHyperlink(itemLink)
      end
    end)
  dropDown:SetScript("OnLeave", function() GameTooltip:Hide() end)

  local label =
    frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  label:SetText(L["Value"])
  label:SetPoint("LEFT", reasonLabel)
  label:SetPoint("TOP", dropDown, "BOTTOM")

  local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  button:SetNormalFontObject("GameFontNormalSmall")
  button:SetHighlightFontObject("GameFontHighlightSmall")
  button:SetDisabledFontObject("GameFontDisableSmall")
  button:SetHeight(BUTTON_HEIGHT)
  button:SetText(L["Credit GP"])
  button:SetWidth(button:GetTextWidth() + BUTTON_TEXT_PADDING)
  button:SetPoint("RIGHT", dropDown, "RIGHT", -15, 0)
  button:SetPoint("TOP", label, "BOTTOM")

  local editBox = CreateFrame("EditBox", "$parentGPControlEditBox",
                              frame, "InputBoxTemplate")
  editBox:SetFontObject("GameFontHighlightSmall")
  editBox:SetHeight(24)
  editBox:SetAutoFocus(false)
  editBox:SetPoint("LEFT", frame, "LEFT", 25, 0)
  editBox:SetPoint("RIGHT", button, "LEFT")
  editBox:SetPoint("TOP", label, "BOTTOM")
  editBox:SetScript("OnTextChanged",
                    function(self) button:SetCurrentState() end)

  function button:SetCurrentState()
    if EPGP:CanIncGPBy(UIDropDownMenu_GetText(dropDown),
                       editBox:GetNumber()) then
      self:Enable()
    else
      self:Disable()
    end
  end
  GS.RegisterCallback(button, "StateChanged", "SetCurrentState")

  frame:SetHeight(
    reasonLabel:GetHeight() +
    dropDown:GetHeight() +
    label:GetHeight() +
    button:GetHeight())

  frame.reasonLabel = reasonLabel
  frame.dropDown = dropDown
  frame.label = label
  frame.button = button
  frame.editBox = editBox

  frame:SetScript("OnShow",
                  function(self)
                    self.editBox:SetText("")
                    UIDropDownMenu_ClearAll(self.dropDown)
                  end)
end

local function EPGPSideFrameEPDropDown_Initialize(dropDown)
  local parent = dropDown:GetParent()
  local dungeons = {CalendarEventGetTextures(1)}
  for i=1,#dungeons,3 do
    if dungeons[i+2] == 2 then
      local info = UIDropDownMenu_CreateInfo()
      info.text = dungeons[i]
      info.func = function(self)
                    UIDropDownMenu_SetSelectedID(dropDown, self:GetID())
                    parent.otherLabel:SetAlpha(0.25)
                    parent.otherEditBox:SetAlpha(0.25)
                    parent.otherEditBox:EnableKeyboard(false)
                    parent.otherEditBox:EnableMouse(false)
                    parent.otherEditBox:ClearFocus()
                    local reason = UIDropDownMenu_GetText(dropDown)
                    local last_award = EPGP.db.profile.last_awards[reason]
                    if last_award then
                      parent.editBox:SetText(last_award)
                    end
                    parent.button:SetCurrentState()
                    if parent.recurring then
                      parent.recurring:SetCurrentState()
                    end
                  end
      UIDropDownMenu_AddButton(info)
    end
  end

  local info = UIDropDownMenu_CreateInfo()
  info.text = L["Other"]
  info.func = function(self)
                UIDropDownMenu_SetSelectedID(dropDown, self:GetID())
                parent.otherLabel:SetAlpha(1)
                parent.otherEditBox:SetAlpha(1)
                parent.otherEditBox:EnableKeyboard(true)
                parent.otherEditBox:EnableMouse(true)
                parent.otherEditBox:SetFocus()
                local reason = parent.otherEditBox:GetText()
                local last_award = EPGP.db.profile.last_awards[reason]
                if last_award then
                  parent.editBox:SetText(last_award)
                end
                parent.button:SetCurrentState()
                if parent.recurring then
                  parent.recurring:SetCurrentState()
                end
              end
  info.checked = false
  UIDropDownMenu_AddButton(info)
end

local function AddEPControls(frame, withRecurring)
  local reasonLabel =
    frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  reasonLabel:SetText(L["EP Reason"])
  reasonLabel:SetPoint("TOPLEFT")

  local dropDown = CreateFrame("Frame", "$parentEPControlDropDown",
                               frame, "UIDropDownMenuTemplate")
  dropDown:EnableMouse(true)
  UIDropDownMenu_Initialize(dropDown, EPGPSideFrameEPDropDown_Initialize)
  UIDropDownMenu_SetWidth(dropDown, 150)
  UIDropDownMenu_JustifyText(dropDown, "LEFT")
  dropDown:SetPoint("TOPLEFT", reasonLabel, "BOTTOMLEFT")

  local otherLabel =
    frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  otherLabel:SetText(L["Other"])
  otherLabel:SetPoint("LEFT", reasonLabel)
  otherLabel:SetPoint("TOP", dropDown, "BOTTOM")

  local otherEditBox = CreateFrame("EditBox", "$parentEPControlOtherEditBox",
                                   frame, "InputBoxTemplate")
  otherEditBox:SetFontObject("GameFontHighlightSmall")
  otherEditBox:SetHeight(24)
  otherEditBox:SetAutoFocus(false)
  otherEditBox:SetPoint("LEFT", frame, "LEFT", 25, 0)
  otherEditBox:SetPoint("RIGHT", frame, "RIGHT", -15, 0)
  otherEditBox:SetPoint("TOP", otherLabel, "BOTTOM")
  otherEditBox:SetScript("OnTextChanged",
                         function(self)
                           local last_award =
                             EPGP.db.profile.last_awards[self:GetText()]
                           if last_award then
                             frame.editBox:SetText(last_award)
                           end
                           frame.button:SetCurrentState()
                           if frame.recurring then
                             frame.recurring:SetCurrentState()
                           end
                         end)

  local label = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  label:SetText(L["Value"])
  label:SetPoint("LEFT", reasonLabel)
  label:SetPoint("TOP", otherEditBox, "BOTTOM")

  local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  button:SetNormalFontObject("GameFontNormalSmall")
  button:SetHighlightFontObject("GameFontHighlightSmall")
  button:SetDisabledFontObject("GameFontDisableSmall")
  button:SetHeight(BUTTON_HEIGHT)
  button:SetText(L["Award EP"])
  button:SetWidth(button:GetTextWidth() + BUTTON_TEXT_PADDING)
  button:SetPoint("RIGHT", otherEditBox, "RIGHT")
  button:SetPoint("TOP", label, "BOTTOM")

  local editBox = CreateFrame("EditBox", "$parentEPControlEditBox",
                              frame, "InputBoxTemplate")
  editBox:SetFontObject("GameFontHighlightSmall")
  editBox:SetHeight(24)
  editBox:SetAutoFocus(false)
  editBox:SetPoint("LEFT", frame, "LEFT", 25, 0)
  editBox:SetPoint("RIGHT", button, "LEFT")
  editBox:SetPoint("TOP", label, "BOTTOM")
  editBox:SetScript("OnTextChanged",
                    function(self)
                      frame.button:SetCurrentState()
                      if frame.recurring then
                        frame.recurring:SetCurrentState()
                      end
                    end)

  function button:SetCurrentState()
    local reason = UIDropDownMenu_GetText(dropDown)
    if reason == L["Other"] then
      reason = otherEditBox:GetText()
    end
    local amount = editBox:GetNumber()
    if EPGP:CanIncEPBy(reason, amount) then
      self:Enable()
    else
      self:Disable()
    end
  end
  GS.RegisterCallback(button, "StateChanged", "SetCurrentState")

  if withRecurring then
    local recurring =
      CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    recurring:SetWidth(20)
    recurring:SetHeight(20)
    recurring:SetPoint("TOP", editBox, "BOTTOMLEFT")
    recurring:SetPoint("LEFT", reasonLabel)

    function recurring:SetCurrentState()
      if EPGP:RunningRecurringEP() then
        self:Enable()
      else
        button.SetCurrentState(self)
      end
    end
    GS.RegisterCallback(recurring, "StateChanged", "SetCurrentState")

    local label =
      frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    label:SetText(L["Recurring"])
    label:SetPoint("LEFT", recurring, "RIGHT")

    local timePeriod =
      frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    timePeriod:SetJustifyH("RIGHT")

    local incButton = CreateFrame("Button", nil, frame)
    incButton:SetNormalTexture(
      "Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Up")
    incButton:SetPushedTexture(
      "Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Down")
    incButton:SetDisabledTexture(
      "Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Disabled")
    incButton:SetWidth(24)
    incButton:SetHeight(24)

    local decButton = CreateFrame("Button", nil, frame)
    decButton:SetNormalTexture(
      "Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Up")
    decButton:SetPushedTexture(
      "Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Down")
    decButton:SetDisabledTexture(
      "Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Disabled")
    decButton:SetWidth(24)
    decButton:SetHeight(24)

    decButton:SetPoint("RIGHT", -15, 0)
    decButton:SetPoint("TOP", recurring, "TOP")
    incButton:SetPoint("RIGHT", decButton, "LEFT", 8, 0)
    timePeriod:SetPoint("RIGHT", incButton, "LEFT")

    function frame:UpdateTimeControls()
      local period_mins = EPGP:RecurringEPPeriodMinutes()
      local fmt, val = SecondsToTimeAbbrev(period_mins * 60)
      timePeriod:SetText(fmt:format(val))
      recurring:SetChecked(EPGP:RunningRecurringEP())
      if period_mins == 1 or EPGP:RunningRecurringEP() then
        decButton:Disable()
      else
        decButton:Enable()
      end
      if EPGP:RunningRecurringEP() then
        incButton:Disable()
      else
        incButton:Enable()
      end
    end

    incButton:SetScript("OnClick",
                        function(self)
                          local period_mins = EPGP:RecurringEPPeriodMinutes()
                          EPGP:RecurringEPPeriodMinutes(period_mins + 1)
                          self:GetParent():UpdateTimeControls()
                        end)

    decButton:SetScript("OnClick",
                        function(self)
                          local period_mins = EPGP:RecurringEPPeriodMinutes()
                          EPGP:RecurringEPPeriodMinutes(period_mins - 1)
                          self:GetParent():UpdateTimeControls()
                        end)

    frame.recurring = recurring
    frame.incButton = incButton
    frame.decButton = decButton
  end

  frame:SetHeight(
    reasonLabel:GetHeight() +
    dropDown:GetHeight() +
    otherLabel:GetHeight() +
    otherEditBox:GetHeight() +
    label:GetHeight() +
    button:GetHeight() +
    (withRecurring and frame.recurring:GetHeight() or 0))

  frame.reasonLabel = reasonLabel
  frame.dropDown = dropDown
  frame.otherLabel = otherLabel
  frame.otherEditBox = otherEditBox
  frame.label = label
  frame.editBox = editBox
  frame.button = button

  frame:SetScript("OnShow",
                  function(self)
                    self.editBox:SetText("")
                    UIDropDownMenu_ClearAll(self.dropDown)
                    self.otherLabel:SetAlpha(0.25)
                    self.otherEditBox:SetAlpha(0.25)
                    self.otherEditBox:EnableKeyboard(false)
                    self.otherEditBox:EnableMouse(false)
                    if self.UpdateTimeControls then
                      self:UpdateTimeControls()
                    end
                  end)
end

local function CreateEPGPSideFrame(self)
  local f = CreateFrame("Frame", "EPGPSideFrame", EPGPFrame)
  table.insert(SIDEFRAMES, f)

  f:Hide()
  f:SetWidth(225)
  f:SetHeight(255)
  f:SetPoint("TOPLEFT", EPGPFrame, "TOPRIGHT", -33, -20)

  local h = f:CreateTexture(nil, "ARTWORK")
  h:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
  h:SetWidth(300)
  h:SetHeight(68)
  h:SetPoint("TOP", -9, 12)

  f.title = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  f.title:SetPoint("TOP", h, "TOP", 0, -15)

  local t = f:CreateTexture(nil, "OVERLAY")
  t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Corner")
  t:SetWidth(32)
  t:SetHeight(32)
  t:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -7)

  f:SetBackdrop(
    {
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true,
      tileSize = 32,
      edgeSize = 32,
      insets = { left=11, right=12, top=12, bottom=11 }
    })

  local cb = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  cb:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -3)

  local gpFrame = CreateFrame("Frame", nil, f)
  gpFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 15, -30)
  gpFrame:SetPoint("TOPRIGHT", f, "TOPRIGHT", -15, -30)
  AddGPControls(gpFrame)
  gpFrame.button:SetScript(
    "OnClick",
    function(self)
      EPGP:IncGPBy(f.name,
                   UIDropDownMenu_GetText(gpFrame.dropDown),
                   gpFrame.editBox:GetNumber())
    end)

  local epFrame = CreateFrame("Frame", nil, f)
  epFrame:SetPoint("TOPLEFT", gpFrame, "BOTTOMLEFT", 0, -15)
  epFrame:SetPoint("TOPRIGHT", gpFrame, "BOTTOMRIGHT", 0, -15)
  AddEPControls(epFrame)
  epFrame.button:SetScript(
    "OnClick",
    function(self)
      local reason = UIDropDownMenu_GetText(epFrame.dropDown)
      if reason == L["Other"] then
        reason = epFrame.otherEditBox:GetText()
      end
      local amount = epFrame.editBox:GetNumber()
      EPGP:IncEPBy(f.name, reason, amount)
    end)

  f:SetScript("OnShow",
              function(self)
                self.title:SetText(self.name)
              end)
end

local function CreateEPGPSideFrame2()
  local f = CreateFrame("Frame", "EPGPSideFrame2", EPGPFrame)
  table.insert(SIDEFRAMES, f)

  f:Hide()
  f:SetWidth(225)
  f:SetHeight(165)
  f:SetPoint("BOTTOMLEFT", EPGPFrame, "BOTTOMRIGHT", -33, 72)

  f:SetBackdrop(
    {
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true,
      tileSize = 32,
      edgeSize = 32,
      insets = { left=11, right=12, top=12, bottom=11 }
    })

  local cb = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  cb:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -3)

  local epFrame = CreateFrame("Frame", nil, f)
  epFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 15, -15)
  epFrame:SetPoint("TOPRIGHT", f, "TOPRIGHT", -15, -15)
  AddEPControls(epFrame, true)
  epFrame.button:SetScript(
    "OnClick",
    function(self)
      local reason = UIDropDownMenu_GetText(epFrame.dropDown)
      if reason == L["Other"] then
        reason = epFrame.otherEditBox:GetText()
      end
      local amount = epFrame.editBox:GetNumber()
      EPGP:IncMassEPBy(reason, amount)
    end)

  epFrame.recurring:SetScript(
    "OnClick",
    function(self)
      if not EPGP:RunningRecurringEP() then
        local reason = UIDropDownMenu_GetText(epFrame.dropDown)
        if reason == L["Other"] then
          reason = epFrame.otherEditBox:GetText()
        end
        local amount = epFrame.editBox:GetNumber()
        EPGP:StartRecurringEP(reason, amount)
      else
        EPGP:StopRecurringEP()
      end
      self:GetParent():UpdateTimeControls()
    end)
end

local function CreateEPGPFrameStandings()
  -- Make the show everyone checkbox
  local f = CreateFrame("Frame", nil, EPGPFrame)
  f:SetHeight(28)
  f:SetPoint("TOPRIGHT", EPGPFrame, "TOPRIGHT", -42, -38)

  local tr = f:CreateTexture(nil, "BACKGROUND")
  tr:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
  tr:SetWidth(12)
  tr:SetHeight(28)
  tr:SetPoint("TOPRIGHT")
  tr:SetTexCoord(0.90625, 1, 0, 1)

  local tl = f:CreateTexture(nil, "BACKGROUND")
  tl:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
  tl:SetWidth(12)
  tl:SetHeight(28)
  tl:SetPoint("TOPLEFT")
  tl:SetTexCoord(0, 0.09375, 0, 1)

  local tm = f:CreateTexture(nil, "BACKGROUND")
  tm:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
  tm:SetHeight(28)
  tm:SetPoint("RIGHT", tr, "LEFT")
  tm:SetPoint("LEFT", tl, "RIGHT")
  tm:SetTexCoord(0.09375, 0.90625, 0, 1)

  local cb = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
  cb:SetWidth(20)
  cb:SetHeight(20)
  cb:SetPoint("RIGHT", f, "RIGHT", -8, 0)
  cb:SetScript("OnShow",
               function(self)
                 self:SetChecked(EPGP:StandingsShowEveryone())
               end)
  cb:SetScript("OnClick",
               function(self)
                 EPGP:StandingsShowEveryone(not not self:GetChecked())
               end)
  local t = cb:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  t:SetText(L["Show everyone"])
  t:SetPoint("RIGHT", cb, "LEFT", 0, 2)
  f:SetWidth(t:GetStringWidth() + 4 * tl:GetWidth() + cb:GetWidth())

  local function HideWhileNotInRaid(self)
    if UnitInRaid("player") then
      self:Show()
    else
      self:Hide()
    end
  end

  f:RegisterEvent("RAID_ROSTER_UPDATE")
  f:SetScript("OnEvent", HideWhileNotInRaid)
  f:SetScript("OnShow", HideWhileNotInRaid)

  -- Make the log frame
  CreateEPGPLogFrame()

  -- Make the side frame
  CreateEPGPSideFrame()

  -- Make the second side frame
  CreateEPGPSideFrame2()

  -- Make the main frame
  local main = CreateFrame("Frame", nil, EPGPFrame)
  main:SetWidth(325)
  main:SetHeight(358)
  main:SetPoint("TOPLEFT", EPGPFrame, 19, -72)

  local award = CreateFrame("Button", nil, main, "UIPanelButtonTemplate")
  award:SetNormalFontObject("GameFontNormalSmall")
  award:SetHighlightFontObject("GameFontHighlightSmall")
  award:SetDisabledFontObject("GameFontDisableSmall")
  award:SetHeight(BUTTON_HEIGHT)
  award:SetPoint("BOTTOMLEFT")
  award:SetText(L["Mass EP Award"])
  award:SetWidth(award:GetTextWidth() + BUTTON_TEXT_PADDING)
  award:RegisterEvent("RAID_ROSTER_UPDATE")
  award:SetScript("OnClick",
                  function()
                    ToggleOnlySideFrame(EPGPSideFrame2)
                  end)

  local log = CreateFrame("Button", nil, main, "UIPanelButtonTemplate")
  log:SetNormalFontObject("GameFontNormalSmall")
  log:SetHighlightFontObject("GameFontHighlightSmall")
  log:SetDisabledFontObject("GameFontDisableSmall")
  log:SetHeight(BUTTON_HEIGHT)
  log:SetPoint("BOTTOMRIGHT")
  log:SetText(GUILD_BANK_LOG)
  log:SetWidth(log:GetTextWidth() + BUTTON_TEXT_PADDING)
  log:SetScript("OnClick",
                function(self, button, down)
                  ToggleOnlySideFrame(EPGPLogFrame)
                end)
  local decay = CreateFrame("Button", nil, main, "UIPanelButtonTemplate")
  decay:SetNormalFontObject("GameFontNormalSmall")
  decay:SetHighlightFontObject("GameFontHighlightSmall")
  decay:SetDisabledFontObject("GameFontDisableSmall")
  decay:SetHeight(BUTTON_HEIGHT)
  decay:SetPoint("RIGHT", log, "LEFT")
  decay:SetText(L["Decay"])
  decay:SetWidth(decay:GetTextWidth() + BUTTON_TEXT_PADDING)
  decay:SetScript("OnClick",
                  function(self, button, down)
                    StaticPopup_Show("EPGP_DECAY_EPGP", EPGP:GetDecayPercent())
                  end)
  function decay:SetCurrentState()
    if EPGP:CanDecayEPGP() then
      self:Enable()
    else
      self:Disable()
    end
  end
  decay:SetScript("OnShow", decay.SetCurrentState)
  EPGP.RegisterCallback(decay, "DecayPercentChanged", "SetCurrentState")
  GS.RegisterCallback(decay, "StateChanged", "SetCurrentState")

  local recurringTime = main:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  recurringTime:SetHeight(16)
  recurringTime:SetJustifyH("CENTER")
  recurringTime:SetPoint("LEFT", award, "RIGHT")
  recurringTime:SetPoint("RIGHT", decay, "LEFT")
  recurringTime:Hide()
  function recurringTime:StartRecurringAward()
    self:Show()
  end
  function recurringTime:StopRecurringAward()
    self:Hide()
  end
  function recurringTime:RecurringAwardUpdate(
      event_type, reason, amount, time_left)
    local fmt, val = SecondsToTimeAbbrev(time_left)
    self:SetFormattedText(L["Next award in "] .. fmt, val)
  end

  EPGP.RegisterCallback(recurringTime, "StartRecurringAward")
  EPGP.RegisterCallback(recurringTime, "StopRecurringAward")
  EPGP.RegisterCallback(recurringTime, "RecurringAwardUpdate")

  -- Make the status text
  local statusText = main:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  statusText:SetHeight(16)
  statusText:SetJustifyH("CENTER")
  statusText:SetPoint("BOTTOMLEFT", award, "TOPLEFT")
  statusText:SetPoint("BOTTOMRIGHT", log, "TOPRIGHT")

  function statusText:StatusTextUpdate()
    local mode
    if UnitInRaid("player") then
      mode = "|cFFFF0000"..RAID.."|r"
    else
      mode = "|cFF00FF00"..GUILD.."|r"
    end
    self:SetFormattedText(
      L["%s (%s)  Decay=%s%% BaseGP=%s MinEP=%s"],
      mode,
      "|cFFFFFFFF"..EPGP:GetNumMembersInAwardList().."|r",
      "|cFFFFFFFF"..EPGP:GetDecayPercent().."|r",
      "|cFFFFFFFF"..EPGP:GetBaseGP().."|r",
      "|cFFFFFFFF"..EPGP:GetMinEP().."|r")
  end
  EPGP.RegisterCallback(statusText, "StandingsChanged", "StatusTextUpdate")
  EPGP.RegisterCallback(statusText, "DecayPercentChanged", "StatusTextUpdate")
  EPGP.RegisterCallback(statusText, "BaseGPChanged", "StatusTextUpdate")
  EPGP.RegisterCallback(statusText, "MinEPChanged", "StatusTextUpdate")

  -- Make the table frame
  local tabl = CreateFrame("Frame", nil, main)
  tabl:SetPoint("TOPLEFT")
  tabl:SetPoint("TOPRIGHT")
  tabl:SetPoint("BOTTOM", statusText, "TOP")

  -- Populate the table
  CreateTable(tabl,
              {"Name", "EP", "GP", "PR"},
              {0, 64, 64, 64},
              {"LEFT", "RIGHT", "RIGHT", "RIGHT"},
              27)  -- The scrollBarWidth

  -- Make the scrollbar
  local rowFrame = tabl.rowFrame
  local scrollBar = CreateFrame("ScrollFrame", "EPGPScrollFrame",
                                rowFrame, "FauxScrollFrameTemplateLight")
  scrollBar:SetWidth(rowFrame:GetWidth())
  scrollBar:SetPoint("TOPRIGHT", rowFrame, "TOPRIGHT", 0, -2)
  scrollBar:SetPoint("BOTTOMRIGHT")

  -- Make all our rows have a check on them and setup the OnClick
  -- handler for each row.
  for i,r in ipairs(rowFrame.rows) do
    r.check = r:CreateTexture(nil, "BACKGROUND")
    r.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
    r.check:SetWidth(r:GetHeight())
    r.check:SetHeight(r:GetHeight())
    r.check:SetPoint("RIGHT", r.cells[1])

    r:RegisterForClicks("LeftButtonDown")
    r:SetScript("OnClick",
                function(self, value)
                  if IsModifiedClick("QUESTWATCHTOGGLE") then
                    if self.check:IsShown() then
                      EPGP:DeSelectMember(self.name)
                    else
                      EPGP:SelectMember(self.name)
                    end
                  else
                    if EPGPSideFrame.name ~= self.name then
                      self:LockHighlight()
                      EPGPSideFrame:Hide()
                      EPGPSideFrame.name = self.name
                    end
                    ToggleOnlySideFrame(EPGPSideFrame)
                  end
                end)

    r:SetScript("OnEnter",
                function(self)
                  if EPGP:GetNumAlts(self.name) > 0 then
                    GameTooltip_SetDefaultAnchor(GameTooltip, self)
                    GameTooltip:AddLine(L["Alts"])
                    for i=1,EPGP:GetNumAlts(self.name) do
                      GameTooltip:AddLine(EPGP:GetAlt(self.name, i), 1, 1, 1)
                    end
                    GameTooltip:ClearAllPoints()
                    GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT")
                    GameTooltip:Show()
                  end
                end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
  end

  -- Hook up the headers
  tabl.headers[1]:SetScript("OnClick",
                            function(self)
                              EPGP:StandingsSort("NAME")
                            end)
  tabl.headers[2]:SetScript("OnClick",
                            function(self)
                              EPGP:StandingsSort("EP")
                            end)
  tabl.headers[3]:SetScript("OnClick",
                            function(self)
                              EPGP:StandingsSort("GP")
                            end)
  tabl.headers[4]:SetScript("OnClick",
                            function(self)
                              EPGP:StandingsSort("PR")
                            end)

  -- Install the update function
  function UpdateStandings()
    if not rowFrame:IsVisible() then
      return
    end
    local offset = FauxScrollFrame_GetOffset(EPGPScrollFrame)
    local numMembers = EPGP:GetNumMembers()
    local numDisplayedMembers = math.min(#rowFrame.rows, numMembers - offset)
    local minEP = EPGP:GetMinEP()
    for i=1,#rowFrame.rows do
      local row = rowFrame.rows[i]
      local j = i + offset
      if j <= numMembers then
        row.name = EPGP:GetMember(j)
        row.cells[1]:SetText(row.name)
        local c = RAID_CLASS_COLORS[EPGP:GetClass(row.name)]
        row.cells[1]:SetTextColor(c.r, c.g, c.b)
        local ep, gp = EPGP:GetEPGP(row.name)
        row.cells[2]:SetText(ep)
        row.cells[3]:SetText(gp)
        local pr = 0
        if gp then
          pr = ep / gp
        end
        if pr > 9999 then
          row.cells[4]:SetText(math.floor(pr))
        else
          row.cells[4]:SetFormattedText("%.4g", pr)
        end
        row.check:Hide()
        if UnitInRaid("player") and EPGP:StandingsShowEveryone() then
          if EPGP:IsMemberInAwardList(row.name) then
            row.check:Show()
          end
        elseif EPGP:IsAnyMemberInExtrasList() then
          if EPGP:IsMemberInAwardList(row.name) then
            row.check:Show()
          end
        end
        row:SetAlpha(ep < minEP and 0.6 or 1)
        row:Show()
      else
        row:Hide()
      end
      -- Fix the highlighting of the rows
      if row.name == EPGPSideFrame.name then
        row:LockHighlight()
      else
        row:UnlockHighlight()
      end
    end
    FauxScrollFrame_Update(EPGPScrollFrame, numMembers, numDisplayedMembers,
                           rowFrame.rowHeight, nil, nil, nil, nil,
                           nil, nil, true)
    EPGPSideFrame:SetScript("OnHide",
                            function(self)
                              self.name = nil
                              UpdateStandings()
                            end)
  end

  EPGP.RegisterCallback(EPGPScrollFrame, "StandingsChanged", UpdateStandings)
  rowFrame:SetScript("OnShow", UpdateStandings)
  scrollBar:SetScript("OnVerticalScroll",
                      function(self, value)
                        FauxScrollFrame_OnVerticalScroll(
                          self, value, rowFrame.rowHeight, UpdateStandings)
                      end)
end

function mod:OnEnable()
  if not EPGPFrame then
    CreateEPGPFrame()
    CreateEPGPFrameStandings()
  end

  HideUIPanel(EPGPFrame)
  EPGPFrame:SetScript("OnShow", GuildRoster)
end

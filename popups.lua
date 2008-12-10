local mod = EPGP:NewModule("EPGP_Popups")

local L = LibStub("AceLocale-3.0"):GetLocale("EPGP")
local GPTooltip = EPGP:GetModule("EPGP_GPTooltip")

local function EPGP_CONFIRM_GP_CREDIT_UpdateButtons(self)
  local link = self.itemFrame.link
  local gp = tonumber(self.editBox:GetText())
  if EPGP:CanIncGPBy(link, gp) then
    self.button1:Enable()
    self.button3:Enable()
  else
    self.button1:Disable()
    self.button3:Disable()
  end
end

local blizzardAnchors = {}

local function savePoint(frame, i)
  local point, relativeTo, relativePoint, x, y = frame:GetPoint(i)
    
  if point then
    tinsert(blizzardAnchors, {frame, point, relativeTo, relativePoint, x, y})
  end  
end

local function makeAnchorTable(itemFrame, editBox, button1)  
  for i=1,itemFrame:GetNumPoints() do
    savePoint(itemFrame, i)
  end

  for i=1,editBox:GetNumPoints() do
    savePoint(editBox, i)
  end
  
  for i=1,button1:GetNumPoints() do
    savePoint(button1, i)
  end
end

StaticPopupDialogs["EPGP_CONFIRM_GP_CREDIT"] = {
  text = L["Credit GP to %s"],
  button1 = ACCEPT,
  button2 = CANCEL,
  timeout = 0,
  whileDead = 1,
  maxLetters = 16,
  hideOnEscape = 1,
  hasEditBox = 1,
  hasItemFrame = 1,                    

  OnAccept = function(self)
               local link = self.itemFrame.link
               local gp = tonumber(self.editBox:GetText())
               EPGP:IncGPBy(self.name, link, gp)
             end,

  OnCancel = function(self)
               self:Hide()
               ClearCursor()
             end,

  OnShow = function(self)
             local itemFrame = getglobal(self:GetName().."ItemFrame")
             local editBox = getglobal(self:GetName().."EditBox")
             local button1 = getglobal(self:GetName().."Button1")

             if #blizzardAnchors == 0 then makeAnchorTable(itemFrame, editBox, button1) end

             itemFrame:SetPoint("TOPLEFT", 35, -35)
             editBox:SetPoint("TOPLEFT", itemFrame, "TOPRIGHT", 150, -10)
             editBox:SetPoint("RIGHT", -35, 0)
             button1:SetPoint("TOPRIGHT", itemFrame, "BOTTOMRIGHT", 85, -6)

             local gp1, gp2 = GPTooltip:GetGPValue(itemFrame.link)
             if gp1 then
               if gp2 then
                 editBox:SetText(L["%d or %d"]:format(gp1, gp2))
               else
                 editBox:SetText(gp1)
               end
             end
             editBox:HighlightText()
             EPGP_CONFIRM_GP_CREDIT_UpdateButtons(self)
           end,

  OnHide = function(self)
             local itemFrame = getglobal(self:GetName().."ItemFrame")
             local editBox = getglobal(self:GetName().."EditBox")
             local button1 = getglobal(self:GetName().."Button1")
             
             -- Clear anchor points of frames that we modified, and revert them.
             itemFrame:ClearAllPoints()
             editBox:ClearAllPoints()
             button1:ClearAllPoints()
             
             for p=1,#blizzardAnchors do
               local frame, point, relativeTo, relativePoint, x, y = unpack(blizzardAnchors[p])
               frame:SetPoint(point, relativeTo, relativePoint, x, y)
             end
           
             if ChatFrameEditBox:IsShown() then
               ChatFrameEditBox:SetFocus()
             end
           end,

  EditBoxOnEnterPressed = function(self)
                            local parent = self:GetParent()
                            local link = parent.itemFrame.link
                            local gp = tonumber(parent.editBox:GetText())
                            if EPGP:CanIncGPBy(link, gp) then
                              EPGP:IncGPBy(parent.name, link, gp)
                              parent:Hide()
                            end
                          end,

  EditBoxOnTextChanged = function(self)
                           local parent = self:GetParent()
                           EPGP_CONFIRM_GP_CREDIT_UpdateButtons(parent)
                         end,

  EditBoxOnEscapePressed = function(self)
                             self:GetParent():Hide()
                             ClearCursor()
                           end
}

StaticPopupDialogs["EPGP_DECAY_EPGP"] = {
  text = "",
  button1 = ACCEPT,
  button2 = CANCEL,
  timeout = 0,
  hideOnEscape = 1,
  whileDead = 1,
  OnShow = function()
             local text = getglobal(this:GetName().."Text")
             text:SetFormattedText(L["Decay EP and GP by %d%%?"],
                                   EPGP:GetDecayPercent())
           end,
  OnAccept = function()
               EPGP:DecayEPGP()
             end
}

StaticPopupDialogs["EPGP_RESET_EPGP"] = {
  text = L["Reset all main toons' EP and GP to 0?"],
  button1 = ACCEPT,
  button2 = CANCEL,
  timeout = 0,
  hideOnEscape = 1,
  whileDead = 1,
  OnAccept = function()
               EPGP:ResetEPGP()
             end
}

local function Debug(fmt, ...)
  DEFAULT_CHAT_FRAME:AddMessage(string.format(fmt, ...))
end

function mod:OnInitialize()
--   local playername = UnitName("player")
--   local itemName, itemLink, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(34541)
--   local r, g, b = GetItemQualityColor(itemRarity);

--   Debug("ItemName: %s ItemLink: %s ItemRarity: %d ItemTexture: %s",
--         itemName, itemLink, itemRarity, itemTexture)
--   local dialog = StaticPopup_Show("EPGP_CONFIRM_GP_CREDIT", playername, "", {
--                                     texture = itemTexture,
--                                     name = itemName,
--                                     color = {r, g, b, 1},
--                                     link = itemLink
--                                   })
--   if dialog then
--     dialog.name = playername
--   end
end

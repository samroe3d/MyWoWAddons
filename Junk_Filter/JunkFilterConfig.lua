-- Author      : CaptJack2883
-- Create Date : 10/13/2012 
-- Modify Date : 11/03/2020 
-- Version     : 1.13

-- Put Variables in Junk_Filter.lua

function JunkFilterConfig_OnLoad(panel)	
	panel.name = "Junk Filter"
	panel.okay = function (self) JunkFilterConfig_Close() end
	panel.cancel = function (self) JunkFilterConfig_CancelOrLoad() end
	panel.refresh = function (self) JunkFilterConfig_Refresh() end
	panel.default = function (self) JunkFilterConfig_Default() end
	InterfaceOptions_AddCategory(panel)
end

function JFConfigShow()
	InterfaceOptionsFrame_OpenToCategory(JunkFilterConfig)
	InterfaceOptionsFrame_OpenToCategory(JunkFilterConfig)
end

function JunkFilterConfig_Default()
	JFBoxMaxDelete:SetNumeric(true)
	JFBoxHowMany:SetNumeric(true)
	JFBoxMaxDelete:SetNumber(10000)
	JFBoxHowMany:SetNumber(5)
	JFVerboseCheckbox:SetChecked(true)
  PoorCheckbox:SetChecked(true)
  CommonCheckbox:SetChecked(false)
  UncommonCheckbox:SetChecked(false)
  RareCheckbox:SetChecked(false)
  EpicCheckbox:SetChecked(false)
  LegendaryCheckbox:SetChecked(false)
end

function JunkFilterConfig_Refresh()	
	JFBoxMaxDelete:SetNumeric(true)
	JFBoxHowMany:SetNumeric(true)
	JFBoxMaxDelete:SetNumber(JFMaxCopperDelete)
	JFBoxHowMany:SetNumber(JFHowMany)
	JFVerboseCheckbox:SetChecked(JFVerboseToggle)
  PoorCheckbox:SetChecked(JFPoor)
  CommonCheckbox:SetChecked(JFCommon)
  UncommonCheckbox:SetChecked(JFUncommon)
  RareCheckbox:SetChecked(JFRare)
  EpicCheckbox:SetChecked(JFEpic)
  LegendaryCheckbox:SetChecked(JFLegendary)
end

function JFOptionsButtonHide_OnClick()
	JunkFrame:Hide()
	JFMainHidden = 0
end

function JFOptionsButtonShowJF_OnClick()
	JunkFrame:Show()
	JFMainHidden = 1
end

function JunkFilterConfig_Close()
	JFHowMany = JFBoxHowMany:GetNumber()
	JFMaxCopperDelete = JFBoxMaxDelete:GetNumber()
	JFVerboseToggle = JFVerboseCheckbox:GetChecked()
	JFSetEnglishVerbose(JFVerboseToggle)
  JFPoor = PoorCheckbox:GetChecked()
  JFCommon = CommonCheckbox:GetChecked()
  JFUncommon = UncommonCheckbox:GetChecked()
  JFRare = RareCheckbox:GetChecked()
  JFEpic = EpicCheckbox:GetChecked()
  JFLegendary = LegendaryCheckbox:GetChecked()
	if JFDebug == true then
		print("Junk Filter:")
		print("You have chosen:")
		print("Empty Slots:", JFHowMany)
		print("Max Delete (copper):", JFMaxCopperDelete)
		print("Reporting Mode:", JFEnglishVerbose)
    print("Qualities Selected to Delete: ", "Poor: ", JFPoor, "  Common:", JFCommon, "  Uncommon:", JFUncommon, "  Rare: ", JFRare, "  Epic: ", JFEpic, "  Legendary: ", JFLegendary)
	end
end

function JunkFilterConfig_CancelOrLoad()
	JFBoxMaxDelete:SetNumeric(true)
	JFBoxHowMany:SetNumeric(true)
	JFBoxMaxDelete:SetNumber(JFMaxCopperDelete)
	JFBoxHowMany:SetNumber(JFHowMany)
	JFVerboseCheckbox:SetChecked(JFVerboseToggle)
  PoorCheckbox:SetChecked(JFPoor)
  CommonCheckbox:SetChecked(JFCommon)
  UncommonCheckbox:SetChecked(JFUncommon)
  RareCheckbox:SetChecked(JFRare)
  EpicCheckbox:SetChecked(JFEpic)
  LegendaryCheckbox:SetChecked(JFLegendary)
end

function JFSetEnglishVerbose(toggle)
	if toggle == 1 then
		JFEnglishVerbose = "On"
	else
    JFEnglishVerbose = "Off"
  end  
end   
   
function QualityButton_OnClick()
  JFPoor = PoorCheckbox:GetChecked()
  JFCommon = CommonCheckbox:GetChecked()
  JFUncommon = UncommonCheckbox:GetChecked()
  JFRare = RareCheckbox:GetChecked()
  JFEpic = EpicCheckbox:GetChecked()
  JFLegendary = LegendaryCheckbox:GetChecked()
  if JFDebug == true then 
    print("Qualities Selected: ", "Poor: ", JFPoor, "  Common:", JFCommon, "  Uncommon:", JFUncommon, "  Rare: ", JFRare, "  Epic: ", JFEpic, "  Legendary: ", JFLegendary)
  end
end

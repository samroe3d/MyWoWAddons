-- Author      : CaptJack2883
-- Create Date : 10/08/2012 
-- Modify Date : 11/03/2020 
-- Version     : 1.13

local bagTable = {0}
local bagTypes = {0}
local emptySlots = 0
local newIndex = 1
local tablePoor = {}
local tableGSorted = {}
local newSortIndex = 1

JFDebug = false

JFHowMany = nil
JFMaxCopperDelete = nil
JFVerboseToggle = nil
JFEnglishVerbose = "Off"
JFWaitTotal = 0
JFWaitFrame = nil
JFEventFrame = nil
JFMainHidden = nil
JFPoor = nil
JFCommon = nil
JFUncommon = nil
JFRare = nil
JFEpic = nil
JFLegendary = nil

JFEventFrame = CreateFrame("FRAME", nil, UIParent)
if JFEventFrame ~= nil then
	print("JFEventFrame has been created")
end
JFWaitFrame = CreateFrame("FRAME", nil, UIParent)
if JFWaitFrame ~= nil then
	print("JFWaitFrame is not NIL")
end

JFEventFrame:RegisterEvent("LOOT_CLOSED")
JFEventFrame:RegisterEvent("ADDON_LOADED")
JFEventFrame:RegisterEvent("PLAYER_LOGOUT") --	Probably don't need/use this.
JFEventFrame:RegisterForDrag("LeftButton")

function JFEventHandler(self, event, ...)
	local arg1 = ...
	if event == "ADDON_LOADED" and arg1 == "Junk_Filter" then		
		if JFHowMany == nil then
			JFHowMany = 5
    end
    if JFPoor == nil then
      JFPoor = true
    end
    if JFCommon == nil then
      JFCommon = false
    end
    if JFUncommon == nil then
      JFUncommon = false
    end
    if JFRare == nil then
      JFRare = false
    end
    if JFEpic == nil then
      JFEpic = false
    end
    if JFLegendary == nil then
      JFLegendary = false
    end
		if JFMaxCopperDelete == nil then
			JFMaxCopperDelete = 10000
		end
		if JFVerboseToggle == nil then
			JFVerboseToggle = true
    end  
		if JFMainHidden == nil then
			JFMainHidden = 1
		end
		if JFMainHidden == 0 then
			JunkFrame:Hide()
		elseif JFMainHidden == 1 then
			JunkFrame:Show()
		end
			JFGetEmptySlots()
		print("Junk Filter has been loaded.")
	elseif event == "PLAYER_LOGOUT" then
		-- What to do on logout.
	elseif event == "LOOT_CLOSED" then
		JFGetEmptySlots()
		if emptySlots < JFHowMany then
			for i = 1,JFHowMany do
				JFGetEmptySlots()
				if emptySlots < JFHowMany then
					JFLootClosed()
				end
			end
		end
	end
end

function JFonUpdate(self,elapsed)
    JFWaitTotal = JFWaitTotal + elapsed
    if JFWaitTotal >= 1 then
		-- This is where you put stuff that happens every Tick.
        
		--print("ping!")
				
		
		--After you do your stuff, reset the wait time.
        JFWaitTotal = 0 
	end
end

--SetScripts MUST be AFTER the function they call.
JFEventFrame:SetScript("OnEvent", JFEventHandler)
JFWaitFrame:SetScript("OnUpdate", JFonUpdate)

function JFBtnCheck_OnClick() --Happens when Button is clicked.
	JFGetEmptySlots()	
  print("Junk Filter has found", emptySlots, "Empty Slots.")	
end

function JFGetEmptySlots() --Tells me how many empty slots there are.
  emptySlots = 0
  bagType = nil
  
  --ContainerIDs are 1 to NUM_BAG_SLOTS + NUM_BANKBAGSLOTS, 0 is 'backpack'.
  -- Need to check backpack separately.
  emptySlots = GetContainerNumFreeSlots(0) --Checking empty slots in backpack.
  
  for i=1, NUM_BAG_SLOTS do
    bagID = ContainerIDToInventoryID(i)
    bagLink = GetInventoryItemLink("player", bagID)
    bagType = GetItemFamily(bagLink)
    if JFDebug == true then
      print("JF: Bag ID:", bagID, "Bag Link:", bagLink, "Bag Type:", bagType)
    end
    if bagType == 0 then
      bagTable[i] = GetContainerNumFreeSlots(i)
      emptySlots = emptySlots + bagTable[i]
    end
  end
  if JFDebug == true then
		print("Junk Filter has found", emptySlots, "Empty Slots.")
  end
end

function JFLootClosed() --Called when Loot Window is closed.
	if JFDebug == true then
		print("The Loot Window has been Closed.")
	end
	JFGetEmptySlots()
	if JFHowMany ~= nil then
		if emptySlots < JFHowMany then --check to see if you have enough slots empty.
			JFDeleteItems()
		end
		if emptySlots > JFHowMany then
   			if JFDebug == true then
				print("You still have plenty of bag space.")
			end
		end
	end
end


function JFDeleteItems()
	JFGetEmptySlots()
	if emptySlots < JFHowMany then
		--This will delete the lowest vendoring Grey Item
		if JFMaxCopperDelete ~= nil then
			if JFVerboseToggle == true then
				print("You have less than", JFHowMany, "slots empty.")
				print("An item will be deleted.")
			end
			tablePoor = {}
			tableGSorted = {}
			newIndex = 1
			newSortIndex = 1
			JFFindGreyItems()
			--This works.
			for i = 1,JFMaxCopperDelete do
				if tablePoor[i] ~= nil then
					tableGSorted[newSortIndex] = tablePoor[i]
					newSortIndex = newSortIndex + 1
				else	
				end
			end
			for i = 1,newSortIndex do			
				JFGetEmptySlots()
				if emptySlots < JFHowMany then
					if tableGSorted[i] ~= nil then
						JFDeleteItem(tableGSorted[i])
						tablePoor = {}
						tableGSorted = {}
						--break						
					else
					end
				else
				end
			end
		end
	end
end

function JFFindGreyItems()
	--Finds lowest cost grey item.
	for bag = 0,NUM_BAG_SLOTS do
		for slot = 1,GetContainerNumSlots(bag) do
			texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bag, slot)
			
      if quality ~= nil then 
        iName, iLink, iRarity, iLevel, iMinLevel, iType, iSubType, iStackCount, iEquipLoc, iTexture, iSellPrice = GetItemInfo(itemLink)
      
      --if JFDebug == true then print("I have found an empty slot.") end			
      
        if iRarity == 0 then
          if JFDebug == true then  print("I have found", itemCount, iLink, "it is Poor.")	end
          if JFPoor == true then JFPutIntoDeleteTable() end
        elseif iRarity == 1 then 
          if JFDebug == true then print("I have found", itemCount, iLink, "it is Common.") end 
          if JFCommon == true then JFPutIntoDeleteTable() end
        elseif iRarity == 2 then 
          if JFDebug == true then print("I have found", itemCount, iLink, "it is Uncommon.") end 
          if JFUncommon == true then JFPutIntoDeleteTable() end
        elseif iRarity == 3 then 
          if JFDebug == true then print("I have found", itemCount, iLink, "it is Rare.") end 
          if JFRare == true then JFPutIntoDeleteTable() end
        elseif iRarity == 4 then 
          if JFDebug == true then print("I have found", itemCount, iLink, "it is Epic.") end 
          if JFEpic == true then JFPutIntoDeleteTable() end
        elseif iRarity == 5 then 
          if JFDebug == true then print("I have found", itemCount, iLink, "it is Legendary.") end 
          if JFLegendary == true then JFPutIntoDeleteTable() end
        elseif iRarity == -1 then 
          if JFDebug == true then print("I have found", itemCount, iLink, "but I don't know this item.") end 
        elseif iRarity == nil then
          if JFDebug == true then print("This", itemCount, iLink, "Has No Quality.") end
        end
      end
    end
  end
end

function JFBtnTest_OnClick()
	print("You have selected:", JFHowMany, "empty slots.")
	print("You have selected:", JFMaxCopperDelete, "max copper delete.")
	JFFindGreyItems()
  print("Table of items that would be deleted based on current settings: ")
  for items in pairs(tablePoor) do
    print(tablePoor[items])
  end
  tablePoor = {}
end

function JFBtnDelete_OnClick()
	JFGetEmptySlots()
	if JFHowMany ~= nil then
		if emptySlots < JFHowMany then
			JFDeleteItems()
		end
	end
end

--	Creates a table of items to be deleted.
function JFPutIntoDeleteTable()
  if iSellPrice > 0 then
    tablePoor[iSellPrice*itemCount+newIndex] = iLink
    newIndex = newIndex + 1
  end
	iRarity = nil
	quality = nil
end

--	Deletes the item whose link is given.
function JFDeleteItem(iLinkDelete)
	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			JFGetEmptySlots()
			if JFHowMany ~= nil then
				if emptySlots < JFHowMany then
					texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bag, slot)
					if quality ~= nil then
						if iLinkDelete == itemLink then
							PickupContainerItem(bag, slot)
							DeleteCursorItem()
							if JFVerboseToggle == true then	
								print("I have deleted", itemLink)
							end
							tablePoor = {}
							tableGSorted = {}
						else
						end
					else
					end
				else
				end
			end
		end				
	end
end

function JFBtnHide_OnClick()
	JunkFrame:Hide()
	JFMainHidden = 0
end

function JFButtonOptions_OnClick()
	JFConfigShow()
end
 
 
-- Basically this makes sure we can go off the original text so other mods don't affect it
local buttonIndex = 1
local function setButtonText(...)
	for i=1, select("#", ...), 3 do
		getglobal("GossipTitleButton" .. buttonIndex).originalText = select(i, ...)
		buttonIndex = buttonIndex + 1
	end
	
	if( buttonIndex > 1 ) then
		buttonIndex = buttonIndex + 1
	end
end

local function setButtonOptionText(...)
	for i=1, select("#", ...), 2 do
		getglobal("GossipTitleButton" .. buttonIndex).originalText = select(i, ...)
		buttonIndex = buttonIndex + 1
	end
	
	if( buttonIndex > 1 ) then
		buttonIndex = buttonIndex + 1
	end
end

hooksecurefunc("GossipFrameAvailableQuestsUpdate", setButtonText)
hooksecurefunc("GossipFrameActiveQuestsUpdate", setButtonText)
hooksecurefunc("GossipFrameOptionsUpdate", setButtonOptionText)
hooksecurefunc("GossipFrameUpdate", function()
	buttonIndex = 1
end)

function checkQuestText(buttonText, texture)
	buttonText = string.trim(buttonText)
	
	local textHasBracket = string.match(buttonText, "%[")
	
	if( not textHasBracket ) then
		buttonText = string.gsub(buttonText, "%-", "%%-")
		buttonText = string.gsub(buttonText, "%(", "%%(")
		buttonText = string.gsub(buttonText, "%)", "%%)")
	end
	
	for i=1, GetNumQuestLogEntries() do
		local questName, _, _, _, _, _, isComplete = GetQuestLogTitle(i)
		local questHasBracket = string.match(questName, "%[")

		if( not questHasBracket ) then
			questName = string.gsub(questName, "%-", "%%-")
			questName = string.gsub(questName, "%(", "%%(")
			questName = string.gsub(questName, "%)", "%%)")
		end
		
		local isMatch
		
		-- Button: FooBar / Quest: FooBar
		-- Button: [50] FooBar / Quest: [50] FooBar
		if( textHasBracket == questHasBracket and buttonText == questName ) then
			isMatch = true
		
		-- Button: FooBar / Quest: [50] FooBar
		elseif( not textHasBracket and questHasBracket and string.match(questName, buttonText) ) then
			isMatch = true
		
		-- Button: [50] FooBar / Quest: FooBar
		elseif( textHasBracket and not questHasBracket and string.match(buttonText, questName) ) then
			isMatch = true
		end
		
		-- Matched, break and change texture
		if( isMatch ) then
			if( ( isComplete and isComplete > 0 ) or GetNumQuestLeaderBoards(i) == 0 ) then
				SetDesaturation(texture, nil)
				return
			end
			break
		end
	end
		
	SetDesaturation(texture, true)
end

local function updateGossipIcons()
	if( not GossipFrame:IsVisible() ) then
		return
	end
	
	for i=1, GossipFrame.buttonIndex do
		local button = getglobal("GossipTitleButton" .. i)
					
		if( button:IsVisible() ) then
			if( button.type == "Active" ) then
				checkQuestText(button.originalText, getglobal(button:GetName() .. "GossipIcon"))
			else
				SetDesaturation(getglobal(button:GetName() .. "GossipIcon"), nil)
			end
		end
	end
end

local function updateQuestIcons()
	if( not QuestFrameGreetingPanel:IsVisible() ) then
		return
	end
	
	for i=1, (GetNumActiveQuests() + GetNumAvailableQuests()) do
		local button = getglobal("QuestTitleButton" .. i)
		
		if( button:IsVisible() ) then
			if( button.isActive == 1 ) then
				checkQuestText(button.originalText, (button:GetRegions()))
			else
				SetDesaturation((button:GetRegions()), nil)
			end
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("QUEST_GREETING")
frame:RegisterEvent("GOSSIP_SHOW")
frame:RegisterEvent("QUEST_LOG_UPDATE")
frame:SetScript("OnEvent", function(self, event)
	updateQuestIcons()
	updateGossipIcons()
end)

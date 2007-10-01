function isQuestComplete(buttonText)
	for i=1, GetNumQuestLogEntries() do
		local questName, _, _, _, _, isHeader, isComplete = GetQuestLogTitle(i)

		if( not isHeader ) then
			-- Damn you people modifying quest name *glares at Cide*
			if( questName == buttonText or string.match(questName, buttonText) or string.match(buttonText, questName) ) then
				if( isComplete or GetNumQuestLeaderBoards(i) == 0 ) then
					return false
				end
			end
		end
	end
	
	return true
end

local function updateGossipIcons()
	if( not GossipFrame:IsVisible() ) then
		return
	end
	
	for i=1, GossipFrame.buttonIndex do
		local button = getglobal("GossipTitleButton" .. i)
					
		if( button:IsVisible() ) then
			getglobal(button:GetName() .. "GossipIcon"):SetDesaturated(isQuestComplete(button:GetText()))
		else
			getglobal(button:GetName() .. "GossipIcon"):SetDesaturated(false)
		end
	end
end

local function updateQuestIcons()
	if( not QuestFrameGreetingPanel:IsVisible() ) then
		return
	end
		
	-- Reset all buttons or we end up with issues later
	for i=1, (GetNumAvailableQuests() + GetNumActiveQuests()) do
		local button = getglobal("QuestTitleButton" .. i)
		if( button ) then
			local texture = button:GetRegions()
			texture:SetDesaturated(false)
		end
	end
	
	-- Now set all the active ones
	for i=1, GetNumActiveQuests() do
		local button = getglobal("QuestTitleButton" .. i)
		
		if( button:IsVisible() ) then
			-- The texture is unnamed, so use GetRegions to grab it
			local texture = button:GetRegions()
			texture:SetDesaturated(isQuestComplete(button:GetText()))
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("QUEST_GREETING")
frame:RegisterEvent("GOSSIP_SHOW")
frame:RegisterEvent("QUEST_LOG_UPDATE")
frame:SetScript("OnEvent", function()
	updateQuestIcons()
	updateGossipIcons()
end)

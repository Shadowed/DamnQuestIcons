local function updateGossipIcons()
	if( not GossipFrame:IsVisible() ) then
		return
	end
	
	for i=1, GossipFrame.buttonIndex do
		local button = getglobal("GossipTitleButton" .. i)
					
		if( button:IsVisible() ) then
			local buttonText = button:GetText()
			local texture = getglobal(button:GetName() .. "GossipIcon")
			
			for j=1, GetNumQuestLogEntries() do
				local questName, _, _, _, _, isHeader, isComplete = GetQuestLogTitle(j)
				
				if( not isHeader ) then
					-- Damn you people modifying quest name *glares at Cide*
					if( questName == buttonText or string.match(questName, buttonText) ) then
						if( isComplete or GetNumQuestLeaderBoards(j) == 0 ) then
							texture:SetDesaturated(false)
						else
							texture:SetDesaturated(true)
						end
						
						break
					else
						texture:SetDesaturated(false)
					end
				end
			end
		end
	end
end

local function updateQuestIcons()
	if( not QuestFrameGreetingPanel:IsVisible() ) then
		return
	end
	
	for i=1, GetNumActiveQuests(), 1 do
		local button = getglobal("QuestTitleButton" .. i)
		local buttonText = button:GetText()
		
		-- The texture is unnamed, so use GetRegions to grab it
		local texture = button:GetRegions()
		
		for j=1, GetNumQuestLogEntries() do
			local questName, _, _, _, _, isHeader, isComplete = GetQuestLogTitle(j)

			if( not isHeader ) then
				-- Damn you people modifying quest name *glares at Cide*
				if( questName == buttonText or string.match(questName, buttonText) ) then
					if( isComplete or GetNumQuestLeaderBoards(j) == 0 ) then
						texture:SetDesaturated(false)
					else
						texture:SetDesaturated(true)
					end

					break
				else
					texture:SetDesaturated(false)
				end
			end
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

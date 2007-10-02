function checkQuestText(buttonText, texture)
	for i=1, GetNumQuestLogEntries() do
		local questName, _, _, _, _, isHeader, isComplete = GetQuestLogTitle(i)

		if( not isHeader ) then
			-- Damn you people modifying quest name *glares at Cide*
			if( questName == buttonText or string.match(questName, buttonText) or string.match(buttonText, questName) ) then
				if( isComplete or GetNumQuestLeaderBoards(i) == 0 ) then
					SetDesaturation(texture, nil)
				end

				break
			end
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
				checkQuestText(button:GetText(), getglobal(button:GetName() .. "GossipIcon"))
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
			if( button.isActive == 0 ) then
				checkQuestText(button:GetText(), (button:GetRegions()))
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
frame:SetScript("OnEvent", function()
	updateQuestIcons()
	updateGossipIcons()
end)

local _G = getfenv(0)

-- Tries to deal with incompatabilities that other mods cause
local function stripStupid(text)
	if( not text ) then
		return nil
	end
	
	-- Strip [<level crap>] <quest title>
	text = string.gsub(text, "%[(.+)%]", "")
	-- Strip color codes
	text = string.gsub(text, "|c%x%x%x%x%x%x%x%x(.+)|r", "%1")
	-- Strip (low level) at the end of a quest
	text = string.gsub(text, "(.+) %((.+)%)", "%1")
	
	text = string.trim(text)
	text = string.lower(text)
	return text
end

function checkQuestText(buttonText, texture)
	buttonText = stripStupid(buttonText)
	
	for i=1, GetNumQuestLogEntries() do
		local questName, _, _, _, _, _, isComplete = GetQuestLogTitle(i)
		
		if( buttonText == stripStupid(questName) ) then
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
		local button = _G["GossipTitleButton" .. i]
		if( button:IsVisible() ) then
			if( button.type == "Active" ) then
				checkQuestText(button:GetText(), _G[button:GetName() .. "GossipIcon"])
			else
				SetDesaturation(_G[button:GetName() .. "GossipIcon"], nil)
			end
		end
	end
end

local function updateQuestIcons()
	if( not QuestFrameGreetingPanel:IsVisible() ) then
		return
	end
	
	for i=1, (GetNumActiveQuests() + GetNumAvailableQuests()) do
		local button = _G["QuestTitleButton" .. i]
		if( button:IsVisible() ) then
			if( button.isActive == 1 ) then
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
frame:SetScript("OnEvent", function(self, event)
	updateQuestIcons()
	updateGossipIcons()
end)

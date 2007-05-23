local frame = CreateFrame( "Frame" );

local function OnEvent()
	if( not GossipFrame:IsVisible() ) then
		return;
	end
	
	local texture, button, buttonText, questName, isHeader, isComplete;
	for i=1, GossipFrame.buttonIndex do
		button = getglobal( "GossipTitleButton" .. i );
		
		if( button:IsVisible() ) then
			buttonText = button:GetText();
			texture = getglobal( button:GetName() .. "GossipIcon" );
			
			for i=1, GetNumQuestLogEntries() do
				questName, _, _, _, _, isHeader, isComplete = GetQuestLogTitle( i );
				
				if( not isHeader ) then
					-- Damn you people modifying quest name *glares at Cide*
					if( questName == buttonText or string.find( questName, buttonText ) ) then
						if( isComplete or GetNumQuestLeaderBoards( i ) == 0 ) then
							texture:SetDesaturated( false );
						else
							texture:SetDesaturated( true );
						end
						
						break;
					else
						texture:SetDesaturated( false );
					end
				end
			end
		end
	end
end

frame:SetScript( "OnEvent", OnEvent );
frame:RegisterEvent( "GOSSIP_SHOW" );
frame:RegisterEvent( "QUEST_LOG_UPDATE" );
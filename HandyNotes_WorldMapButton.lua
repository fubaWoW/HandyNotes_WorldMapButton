local AddOnName, AddOn = ...
-- Handynotes Worldmap Button by fuba
if not IsAddOnLoaded('HandyNotes') then return end

local isClassicWow = select(4,GetBuildInfo()) < 20000

local L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes_WorldMapButton", false);

local iconDefault = [[Interface\AddOns\]] .. AddOnName .. [[\Buttons\Default]];
local iconDisabled = [[Interface\AddOns\]] .. AddOnName .. [[\Buttons\Disabled]];

local point, relativeTo, relativePoint, xOfs, yOfs

local ButtonName = "HandyNotesWorldMapButton"
local btn = _G[ButtonName]

local function SetIconTexture()
	local btn = _G[ButtonName]
	if not btn then return end
	if HandyNotes then
		if HandyNotes:IsEnabled() then
			btn:SetNormalTexture(iconDefault);
		else
			btn:SetNormalTexture(iconDisabled);
		end
	else
		btn:Hide();
	end
end

local function SetIconTooltip(IsRev)
	local btn = _G[ButtonName]
	if not btn then return end
	if not WorldMapTooltip then return end
	WorldMapTooltip:Hide();
	WorldMapTooltip:SetOwner(btn, "ANCHOR_BOTTOMLEFT");
	if HandyNotes:IsEnabled() then
		WorldMapTooltip:AddLine(L["TEXT_TOOLTIP_HIDE_ICONS"], nil, nil, nil, nil, 1 );
	else
		WorldMapTooltip:AddLine(L["TEXT_TOOLTIP_SHOW_ICONS"], nil, nil, nil, nil, 1 );
	end
	WorldMapTooltip:Show();
end

local function btnOnEnter(self, motion)
	SetIconTexture();
	SetIconTooltip(false);
end

local function btnOnLeave(self, motion)
	SetIconTexture();
	if WorldMapTooltip then
		WorldMapTooltip:Hide();
	end
end

local function btnOnClick(self)
	local db = LibStub("AceDB-3.0"):New("HandyNotesDB", defaults).profile;

	if HandyNotes:IsEnabled() then
		db.enabled = false
		HandyNotes:Disable();
	else
		db.enabled = true
		HandyNotes:Enable();
	end
	SetIconTexture();
	SetIconTooltip(false);
end

hooksecurefunc(HandyNotes, "OnEnable", function(self)
	SetIconTexture()
end)

hooksecurefunc(HandyNotes, "OnDisable", function(self)
	SetIconTexture()
end)


if isClassicWow then
	btn = _G[ButtonName] or CreateFrame("Button", ButtonName, WorldMapFrame, "UIPanelButtonTemplate");
else
	btn = _G[ButtonName] or CreateFrame("Button", ButtonName, WorldMapFrame.ScrollContainer, "UIPanelButtonTemplate");
end
btn:RegisterForClicks("AnyUp");
btn:SetText("");
btn:SetScript("OnClick", btnOnClick);
btn:SetScript("OnEnter", btnOnEnter);
btn:SetScript("OnLeave", btnOnLeave);

WorldMapFrame:HookScript("OnShow", function(self)		
	if isClassicWow then
		btn = _G[ButtonName] or CreateFrame("Button", ButtonName, WorldMapFrame, "UIPanelButtonTemplate");
		btn:ClearAllPoints();
		btn:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", -16, -76)
		btn:SetSize(24, 24);
		btn:SetFrameLevel(5000);
	else
		local FilterButton = WorldMapFrame.overlayFrames[2]
		btn = _G[ButtonName] or CreateFrame("Button", ButtonName, WorldMapFrame.ScrollContainer, "UIPanelButtonTemplate");
		btn:ClearAllPoints();
		if FilterButton and FilterButton:IsVisible() then
			parent = FilterButton:GetParent()	
			btn:SetPoint("RIGHT", FilterButton, "LEFT", -5, 0)
			btn:SetSize(24, 24);
			btn:SetFrameLevel(5000);
		else
			btn:SetPoint("TOPRIGHT", WorldMapFrame.ScrollContainer, "TOPRIGHT", -10, -7)
			btn:SetSize(24, 24);
			btn:SetFrameLevel(5000);
		end
	end
	
	if IsAddOnLoaded('Leatrix_Maps') then
		if isClassicWow then
			if LeaMapsDB and (LeaMapsDB["NoMapBorder"] == "On" and LeaMapsDB["UseDefaultMap"] == "Off") then
				if IsAddOnLoaded('WorldMapTrackingEnhanced') then
					local wmteb = _G["WorldMapTrackingEnhancedButton"];
					if wmteb then
						if WorldMapFrameCloseButton and WorldMapFrameCloseButton:IsVisible() then
							wmteb:ClearAllPoints()
							wmteb:SetPoint("RIGHT", WorldMapFrameCloseButton, "LEFT", -5, 0)
							btn = _G[ButtonName] or CreateFrame("Button", ButtonName, WorldMapFrame, "UIPanelButtonTemplate");
							btn:ClearAllPoints();
							btn:SetPoint("RIGHT", WorldMapTrackingEnhancedButton, "LEFT", -5, 0);
							btn:SetFrameLevel(5000);
							btn:SetSize(24, 24);
						end
					end
				else
					btn = _G[ButtonName] or CreateFrame("Button", ButtonName, WorldMapFrame, "UIPanelButtonTemplate");
					btn:ClearAllPoints();
					btn:SetPoint("RIGHT", WorldMapFrameCloseButton, "LEFT", 0, 0);
					btn:SetFrameLevel(5000);
					btn:SetSize(18, 18);
				end
			else
				if IsAddOnLoaded('WorldMapTrackingEnhanced') then
					btn = _G[ButtonName] or CreateFrame("Button", ButtonName, WorldMapFrame, "UIPanelButtonTemplate");
					btn:ClearAllPoints();
					btn:SetPoint("RIGHT", WorldMapTrackingEnhancedButton, "LEFT", -5, 0);
					btn:SetFrameLevel(5000);
					btn:SetSize(24, 24);					
				end
			end
		end
	end
	btn:Show();	
	SetIconTexture();
end)
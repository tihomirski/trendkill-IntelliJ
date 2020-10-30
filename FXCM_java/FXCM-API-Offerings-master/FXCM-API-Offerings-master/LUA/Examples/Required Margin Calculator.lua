-- The Required Margin Calculator indicator (available at www.FXCMApps.com) displays the amount of margin required to open positions in specified instruments/sizes and calculates the amount of usable margin that would be remaining in the user's account if the position was in fact opened.

-- Features
--    * 5 Instrument/Lotsize Inputs - Allows user to select 5 different Instrument/Lotsize combinations to be displayed at one time
--    * DashboardPosition - Allows user to select which corner of the chart the information will be displayed in
--    * General style options are also available


function Init()
    indicator:name("Required Margin Calculator");
    indicator:description("No description");
    indicator:requiredSource(core.Bar);
    indicator:type(core.Indicator);

	indicator.parameters:addString("Account", "Account", "", "");
		indicator.parameters:setFlag("Account", core.FLAG_ACCOUNT);
		
	indicator.parameters:addGroup("Instrument 1")
	indicator.parameters:addString("Instrument1", "Instrument", "", "EUR/USD");
		indicator.parameters:setFlag("Instrument1", core.FLAG_INSTRUMENTS);
	indicator.parameters:addInteger("Instrument1Size", "Lotsize", "", 1, 1, 50000);	
	
	indicator.parameters:addGroup("Instrument 2")
	indicator.parameters:addString("Instrument2", "Instrument", "", "GBP/USD");
		indicator.parameters:setFlag("Instrument2", core.FLAG_INSTRUMENTS);
	indicator.parameters:addInteger("Instrument2Size", "Lotsize", "", 10, 1, 50000);	

	indicator.parameters:addGroup("Instrument 3")
	indicator.parameters:addString("Instrument3", "Instrument", "", "USD/CHF");
		indicator.parameters:setFlag("Instrument3", core.FLAG_INSTRUMENTS);
	indicator.parameters:addInteger("Instrument3Size", "Lotsize", "", 50, 1, 50000);	

	indicator.parameters:addGroup("Instrument 4")
	indicator.parameters:addString("Instrument4", "Instrument 4", "", "USD/JPY");
		indicator.parameters:setFlag("Instrument4", core.FLAG_INSTRUMENTS);
	indicator.parameters:addInteger("Instrument4Size", "Lotsize", "", 100, 1, 50000);	
	
	indicator.parameters:addGroup("Instrument 5")
	indicator.parameters:addString("Instrument5", "Instrument", "", "GBP/JPY");
		indicator.parameters:setFlag("Instrument5", core.FLAG_INSTRUMENTS);
	indicator.parameters:addInteger("Instrument5Size", "Lotsize", "", 250, 1, 50000);		
	
	indicator.parameters:addGroup("Display Options")
	indicator.parameters:addString("DashboardPosition", "Advanced Dashboard Position", "", "Bottom-Left");
		indicator.parameters:addStringAlternative("DashboardPosition", "Bottom-Left", "", "Bottom-Left");
		indicator.parameters:addStringAlternative("DashboardPosition", "Bottom-Right", "", "Bottom-Right");
		indicator.parameters:addStringAlternative("DashboardPosition", "Top-Right", "", "Top-Right");
		indicator.parameters:addStringAlternative("DashboardPosition", "Top-Left", "", "Top-Left");
	
	indicator.parameters:addString("ColorTheme", "Select Color Theme", "", "Light");
		indicator.parameters:addStringAlternative("ColorTheme", "Light", "", "Light");
		indicator.parameters:addStringAlternative("ColorTheme", "Dark", "", "Dark");
		indicator.parameters:addStringAlternative("ColorTheme", "Blue", "", "Blue");
		indicator.parameters:addStringAlternative("ColorTheme", "Custom", "", "Custom");	
	
	indicator.parameters:addGroup("Custom Theme Colors")
	indicator.parameters:addColor("TopBarColor", "Top Bar Color", "", core.rgb(110,110,110))
	indicator.parameters:addColor("PrimaryColor", "Primary Color", "", core.rgb(226,226,228))
	indicator.parameters:addColor("SecondaryColor", "Secondary Color", "", core.rgb(242,242,248))
	indicator.parameters:addColor("TopTextColor", "Top Text Color", "", core.rgb(233,233,233))
	indicator.parameters:addColor("BodyTextColor", "Body Text Color", "", core.rgb(90,90,90))


end

-- Global Variables
local DashboardPosition;
local ColorTheme;

local TopBarColor;
local PrimaryColor;
local SecondaryColor;
local TopTextColor;
local BodyTextColor;

local Instrument1_MMR;
local Instrument2_MMR;
local Instrument3_MMR;
local Instrument4_MMR;
local Instrument5_MMR;

local Instrument1_BaseSize;
local Instrument2_BaseSize;
local Instrument3_BaseSize;
local Instrument4_BaseSize;
local Instrument5_BaseSize;

local instrument1mmr, instrument2mmr, instrument3mmr, instrument4mmr, instrument5mmr;

local timerId;
local MasterTimer;

local first;
local source = nil;

local init = true;

function Prepare(onlyName)
	-- Assign chosen parameters to their respective Global Variable
	ColorTheme = instance.parameters.ColorTheme;
	DashboardPosition = instance.parameters.DashboardPosition;

	-- Assign main price source
    source = instance.source;
    first = source:first();
	
	-- Assign name to indicator instance
	local name = profile:id();
    instance:name(name);
	if onlyName then
        return ;
    end
	
	-- get MMR values
	Instrument1_MMR = core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument1).MMR;
	Instrument2_MMR = core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument2).MMR;
	Instrument3_MMR = core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument3).MMR;
	Instrument4_MMR = core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument4).MMR;
	Instrument5_MMR = core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument5).MMR;
	
	-- get baseUnitSize values
	Instrument1_BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.parameters.Instrument1, instance.parameters.Account)
	Instrument2_BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.parameters.Instrument2, instance.parameters.Account)
	Instrument3_BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.parameters.Instrument3, instance.parameters.Account)
	Instrument4_BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.parameters.Instrument4, instance.parameters.Account)
	Instrument5_BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.parameters.Instrument5, instance.parameters.Account)
	
	-- make sure lotsizes are appropriate for each instrument selected
	assert(core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument1).InstrumentType == 1 or instance.parameters.Instrument1Size % Instrument1_BaseSize == 0, instance.parameters.Instrument1 .. " Lotsize must be a number evenly divided by " .. tostring(Instrument1_BaseSize).. " lots.")
	assert(core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument2).InstrumentType == 1 or instance.parameters.Instrument2Size % Instrument2_BaseSize == 0, instance.parameters.Instrument2 .. " Lotsize must be a number evenly divided by " .. tostring(Instrument2_BaseSize).. " lots.")
	assert(core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument3).InstrumentType == 1 or instance.parameters.Instrument3Size % Instrument3_BaseSize == 0, instance.parameters.Instrument3 .. " Lotsize must be a number evenly divided by " .. tostring(Instrument3_BaseSize).. " lots.")
	assert(core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument4).InstrumentType == 1 or instance.parameters.Instrument4Size % Instrument4_BaseSize == 0, instance.parameters.Instrument4 .. " Lotsize must be a number evenly divided by " .. tostring(Instrument4_BaseSize).. " lots.")
	assert(core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument5).InstrumentType == 1 or instance.parameters.Instrument5Size % Instrument5_BaseSize == 0, instance.parameters.Instrument5 .. " Lotsize must be a number evenly divided by " .. tostring(Instrument5_BaseSize).. " lots.")
		
	instance:ownerDrawn(true);
		
end

-- update function is unused
function Update(period, mode)

end


-- drawing graphics on the chart
function Draw(stage, context)

	-- called after the price and all indicators which are applied before this indicator are painted.
	if stage == 1 then
		
		-- create brushes, colors, fonts first time called
		if init then
			init = false;
			
			-- assign color theme
			if ColorTheme == "Light" then
				TopBarColor = core.rgb(110,110,110);
				PrimaryColor = core.rgb(226,226,228);
				SecondaryColor = core.rgb(242,242,248);
				TopTextColor = core.rgb(233,233,233);
				BodyTextColor = core.rgb(90,90,90);
			elseif ColorTheme == "Dark" then
				TopBarColor = core.rgb(45,45,45)
				PrimaryColor = core.rgb(66,66,66);
				SecondaryColor = core.rgb(85,85,85);
				TopTextColor = core.rgb(210,210,210);
				BodyTextColor = core.rgb(233,233,233);
			elseif ColorTheme == "Blue" then
				TopBarColor = core.rgb(24,46,86)
				PrimaryColor = core.rgb(36,69,130);
				SecondaryColor = core.rgb(53,133,198)
				TopTextColor = core.rgb(233,242,249);
				BodyTextColor = core.rgb(233,242,249)
			else
				TopBarColor = instance.parameters.TopBarColor;
				PrimaryColor = instance.parameters.PrimaryColor;
				SecondaryColor = instance.parameters.SecondaryColor;
				TopTextColor = instance.parameters.TopTextColor;
				BodyTextColor = instance.parameters.BodyTextColor;
			end
			
			-- assign fill colors
			context:createSolidBrush(0, PrimaryColor); -- main box
			context:createSolidBrush(2, SecondaryColor); -- window color
			context:createSolidBrush(3, TopBarColor); -- top bar color
			
			-- create fonts
			context:createFont(1, "Verdana", 0, 12, 0) -- normal text size
			context:createFont(4, "Verdana", 0, 13, 0) -- title text size
			context:createFont(5, "Verdana", 0, 13, context.BOLD) -- title text size
			
			-- required margin calculations
			if core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument1).InstrumentType == 1 then
				instrument1mmr = instance.parameters.Instrument1Size * Instrument1_MMR
			else
				instrument1mmr = instance.parameters.Instrument1Size/Instrument1_BaseSize * Instrument1_MMR
			end
			if core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument2).InstrumentType == 1 then
				instrument2mmr = instance.parameters.Instrument2Size * Instrument2_MMR
			else
				instrument2mmr = instance.parameters.Instrument2Size/Instrument2_BaseSize * Instrument2_MMR
			end
			if core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument3).InstrumentType == 1 then
				instrument3mmr = instance.parameters.Instrument3Size * Instrument3_MMR
			else
				instrument3mmr = instance.parameters.Instrument3Size/Instrument3_BaseSize * Instrument3_MMR
			end
			if core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument4).InstrumentType == 1 then
				instrument4mmr = instance.parameters.Instrument4Size * Instrument4_MMR
			else
				instrument4mmr = instance.parameters.Instrument4Size/Instrument4_BaseSize * Instrument4_MMR
			end
			if core.host:findTable("offers"):find("Instrument", instance.parameters.Instrument5).InstrumentType == 1 then
				instrument5mmr = instance.parameters.Instrument5Size * Instrument5_MMR
			else
				instrument5mmr = instance.parameters.Instrument5Size/Instrument5_BaseSize * Instrument5_MMR
			end
			
			-- logging
			core.host:trace(instance.parameters.Instrument1 .. "  " .. tostring(instance.parameters.Instrument1Size) .. "  " .. tostring(instrument1mmr));
			core.host:trace(instance.parameters.Instrument2 .. "  " .. tostring(instance.parameters.Instrument2Size) .. "  " .. tostring(instrument2mmr));
			core.host:trace(instance.parameters.Instrument3 .. "  " .. tostring(instance.parameters.Instrument3Size) .. "  " .. tostring(instrument3mmr));
			core.host:trace(instance.parameters.Instrument4 .. "  " .. tostring(instance.parameters.Instrument4Size) .. "  " .. tostring(instrument4mmr));
			core.host:trace(instance.parameters.Instrument5 .. "  " .. tostring(instance.parameters.Instrument5Size) .. "  " .. tostring(instrument5mmr));
			
			
        end

			
		-- general coordinates
		left = context:left()
		right = context:right()
		top = context:top()
		bottom = context:bottom()
		
		-- 360 x 180 reference box
		if DashboardPosition == "Bottom-Left" then
			mastertopleft_X = left+10
			mastertopleft_Y = bottom-190
			masterbottomright_X = left+370
			masterbottomright_Y = bottom-10
		elseif DashboardPosition == "Bottom-Right" then
			mastertopleft_X = right-370
			mastertopleft_Y = bottom-190
			masterbottomright_X = right-10
			masterbottomright_Y = bottom-10
		elseif DashboardPosition == "Top-Left" then
			mastertopleft_X = left+10
			mastertopleft_Y = top+38
			masterbottomright_X = left+370
			masterbottomright_Y = top+218
		elseif DashboardPosition == "Top-Right" then
			mastertopleft_X = right-370
			mastertopleft_Y = top+38
			masterbottomright_X = right-10
			masterbottomright_Y = top+218
		end
		
		-- collect account values
		local Equity, UsedMargin, UsableMargin;
		local findAccount = core.host:findTable("accounts"):find("AccountID", instance.parameters.Account);
		if findAccount ~= nil then
			Equity = findAccount:cell("Equity");
			UsedMargin = findAccount:cell("UsedMargin");
			UsableMargin = findAccount:cell("UsableMargin");
		end
		
		
		-- create graphics ================================
		-- ================================================
		
		-- main box
		context:drawRectangle(-1, 0, mastertopleft_X, mastertopleft_Y, masterbottomright_X, masterbottomright_Y) -- main box
		
		-- top bar box
		context:drawRectangle(-1, 3, mastertopleft_X, mastertopleft_Y-28, masterbottomright_X, mastertopleft_Y+1) -- top bar rectangle
		context:drawText(4, "Equity: ", TopTextColor, -1, mastertopleft_X+5, mastertopleft_Y-23, mastertopleft_X+53, mastertopleft_Y+1, context.LEFT) -- Equity text
		context:drawText(5, win32.formatNumber(Equity, true, 2), TopTextColor, -1, mastertopleft_X+54, mastertopleft_Y-23, mastertopleft_X+170, mastertopleft_Y+1, context.LEFT) -- Equity value
		
		-- usable margin
		local UsableMarginLength = context:measureText(5, win32.formatNumber(UsableMargin, true, 2), context.RIGHT) -- length of usable margin in pixels
		context:drawText(4, "Usbl Margin: ", TopTextColor, -1, mastertopleft_X+160, mastertopleft_Y-23, masterbottomright_X-3-UsableMarginLength, mastertopleft_Y+1, context.RIGHT) -- Usbl Margin test
		context:drawText(5, win32.formatNumber(UsableMargin, true, 2), TopTextColor, -1, mastertopleft_X+248, mastertopleft_Y-23, masterbottomright_X-5, mastertopleft_Y+1, context.RIGHT) -- Usbl Margin value
	
		-- symbols column
		context:drawRectangle(-1, 2, mastertopleft_X+5, mastertopleft_Y+31, mastertopleft_X+74, masterbottomright_Y-5) -- symbol column rectangle
		context:drawText(1, "Symbol", BodyTextColor, -1, mastertopleft_X+5, mastertopleft_Y+8, mastertopleft_X+73, masterbottomright_Y, context.CENTER) -- Symbol column header
		context:tooltip(mastertopleft_X+5, mastertopleft_Y+8, mastertopleft_X+73, masterbottomright_Y, "Symbol = The instrument that you plan to trade.") -- tooltip description
		context:drawText(1, instance.parameters.Instrument1, BodyTextColor, -1, mastertopleft_X+11, mastertopleft_Y+37, mastertopleft_X+88, masterbottomright_Y, context.LEFT) -- Instrument1 name
		context:drawText(1, instance.parameters.Instrument2, BodyTextColor, -1, mastertopleft_X+11, mastertopleft_Y+66, mastertopleft_X+88, masterbottomright_Y, context.LEFT) -- Instrument2 name
		context:drawText(1, instance.parameters.Instrument3, BodyTextColor, -1, mastertopleft_X+11, mastertopleft_Y+95, mastertopleft_X+88, masterbottomright_Y, context.LEFT) -- Instrument3 name
		context:drawText(1, instance.parameters.Instrument4, BodyTextColor, -1, mastertopleft_X+11, mastertopleft_Y+124, mastertopleft_X+88, masterbottomright_Y, context.LEFT) -- Instrument4 name
		context:drawText(1, instance.parameters.Instrument5, BodyTextColor, -1, mastertopleft_X+11, mastertopleft_Y+153, mastertopleft_X+88, masterbottomright_Y, context.LEFT)  -- Instrument5 name
		
		-- lots column
		context:drawRectangle(-1, 2, mastertopleft_X+78, mastertopleft_Y+31, mastertopleft_X+130, masterbottomright_Y-5) -- lots column rectangle
		context:drawText(1, "Lots", BodyTextColor, -1, mastertopleft_X+78, mastertopleft_Y+8, mastertopleft_X+130, masterbottomright_Y, context.CENTER) -- Lots column header
		context:tooltip(mastertopleft_X+78, mastertopleft_Y+8, mastertopleft_X+130, masterbottomright_Y, "Lots = The number of lots that you plan to trade.") -- tooltip description
		context:drawText(1, win32.formatNumber(instance.parameters.Instrument1Size, true, 0), BodyTextColor, -1, mastertopleft_X+78, mastertopleft_Y+37, mastertopleft_X+125, masterbottomright_Y, context.RIGHT) -- Instrument1 lots
		context:drawText(1, win32.formatNumber(instance.parameters.Instrument2Size, true, 0), BodyTextColor, -1, mastertopleft_X+78, mastertopleft_Y+66, mastertopleft_X+125, masterbottomright_Y, context.RIGHT) -- Instrument2 lots
		context:drawText(1, win32.formatNumber(instance.parameters.Instrument3Size, true, 0), BodyTextColor, -1, mastertopleft_X+78, mastertopleft_Y+95, mastertopleft_X+125, masterbottomright_Y, context.RIGHT) -- Instrument3 lots
		context:drawText(1, win32.formatNumber(instance.parameters.Instrument4Size, true, 0), BodyTextColor, -1, mastertopleft_X+78, mastertopleft_Y+124, mastertopleft_X+125, masterbottomright_Y, context.RIGHT) -- Instrument4 lots
		context:drawText(1, win32.formatNumber(instance.parameters.Instrument5Size, true, 0), BodyTextColor, -1, mastertopleft_X+78, mastertopleft_Y+153, mastertopleft_X+125, masterbottomright_Y, context.RIGHT) -- Instrument5 lots
		
		-- Required Margin
		context:drawRectangle(-1, 2, mastertopleft_X+134, mastertopleft_Y+31, mastertopleft_X+242, masterbottomright_Y-5) -- required margin rectangle
		context:drawText(1, "Required Margin", BodyTextColor, -1, mastertopleft_X+134, mastertopleft_Y+8, mastertopleft_X+242, masterbottomright_Y, context.CENTER) -- Required Margin column header
		context:tooltip(mastertopleft_X+134, mastertopleft_Y+8, mastertopleft_X+242, masterbottomright_Y, "Required Margin = The Margin Requirement of the lotsize and instrument you plan to trade.") -- tooltip description
		context:drawText(1, win32.formatNumber(instrument1mmr, true, 0), BodyTextColor, -1, mastertopleft_X+126, mastertopleft_Y+37, mastertopleft_X+230, masterbottomright_Y, context.RIGHT) -- Instrument1 required margin
		context:drawText(1, win32.formatNumber(instrument2mmr, true, 0), BodyTextColor, -1, mastertopleft_X+126, mastertopleft_Y+66, mastertopleft_X+230, masterbottomright_Y, context.RIGHT) -- Instrument2 required margin
		context:drawText(1, win32.formatNumber(instrument3mmr, true, 0), BodyTextColor, -1, mastertopleft_X+126, mastertopleft_Y+95, mastertopleft_X+230, masterbottomright_Y, context.RIGHT) -- Instrument3 required margin
		context:drawText(1, win32.formatNumber(instrument4mmr, true, 0), BodyTextColor, -1, mastertopleft_X+126, mastertopleft_Y+124, mastertopleft_X+230, masterbottomright_Y, context.RIGHT) -- Instrument4 required margin
		context:drawText(1, win32.formatNumber(instrument5mmr, true, 0), BodyTextColor, -1, mastertopleft_X+126, mastertopleft_Y+153, mastertopleft_X+230, masterbottomright_Y, context.RIGHT) -- Instrument5 required margin
		
		-- Projected Margin
		context:drawRectangle(-1, 2, mastertopleft_X+246, mastertopleft_Y+31, mastertopleft_X+356, masterbottomright_Y-5) -- required margin rectangle
		context:drawText(1, "Proj. Usbl Margin", BodyTextColor, -1, mastertopleft_X+246, mastertopleft_Y+8, mastertopleft_X+356, masterbottomright_Y, context.CENTER) -- Projected Margin column header
		context:tooltip(mastertopleft_X+246, mastertopleft_Y+8, mastertopleft_X+356, masterbottomright_Y, "Projected Usable Margin = The estimated Usable Margin that will remain available \nafter a trade is placed for the selected lotsize on the selected instrument. Calculated \nby subtracting the 'Required Margin' field from the Account's current 'Usbl Margin.' \nThis is only an estimate. Usbl Margin is subject to change at any time.") -- tooltip description
		context:drawText(1, win32.formatNumber(UsableMargin-instrument1mmr, true, 2), BodyTextColor, -1, mastertopleft_X+246, mastertopleft_Y+37, mastertopleft_X+351, masterbottomright_Y, context.RIGHT) -- Instrument1 projected margin
		context:drawText(1, win32.formatNumber(UsableMargin-instrument2mmr, true, 2), BodyTextColor, -1, mastertopleft_X+246, mastertopleft_Y+66, mastertopleft_X+351, masterbottomright_Y, context.RIGHT) -- Instrument2 projected margin
		context:drawText(1, win32.formatNumber(UsableMargin-instrument3mmr, true, 2), BodyTextColor, -1, mastertopleft_X+246, mastertopleft_Y+95, mastertopleft_X+351, masterbottomright_Y, context.RIGHT) -- Instrument3 projected margin
		context:drawText(1, win32.formatNumber(UsableMargin-instrument4mmr, true, 2), BodyTextColor, -1, mastertopleft_X+246, mastertopleft_Y+124, mastertopleft_X+351, masterbottomright_Y, context.RIGHT) -- Instrument4 projected margin
		context:drawText(1, win32.formatNumber(UsableMargin-instrument5mmr, true, 2), BodyTextColor, -1, mastertopleft_X+246, mastertopleft_Y+153, mastertopleft_X+351, masterbottomright_Y, context.RIGHT) -- Instrument5 projected margin
		
	end
	
end

-- unused
function AsyncOperationFinished(id, success, msg)

end

-- actions taken when indicator has been deleted from a chart
function ReleaseInstance()
	core.host:execute("removeAll") -- delete all lines/rectangles/text
end


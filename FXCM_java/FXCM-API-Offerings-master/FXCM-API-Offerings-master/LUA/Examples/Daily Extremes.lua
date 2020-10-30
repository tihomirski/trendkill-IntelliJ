-- The Daily Extremes indicator (available at www.FXCMApps.com) displays the previous day's high and low prices on top of the current day's price, regardless of the chart's timeframe.

-- Features
--    * ShowMode - Allows user to select whether to see only the previous day's high/low or to see all historical high/low levels
--    * Display Type - Allows user to select whether historical prices levels are connected to each other or not.
--    * General style options are also available


function Init()
    indicator:name("Daily Extremes");
    indicator:description("This indicator displays the prior day's high and low prices.");
    indicator:requiredSource(core.Bar);
    indicator:type(core.Indicator);
	
	indicator.parameters:addString("ShowMode", "ShowMode", "if set to 'historical' then all bars displayed on screen will populate the selected price lines for that day. if set to 'today' only the most rececnt day's data will populate.", "Historical");
		indicator.parameters:addStringAlternative("ShowMode", "Today", "", "Today");
		indicator.parameters:addStringAlternative("ShowMode", "Historical", "", "Historical");
		
	indicator.parameters:addGroup("Line Appearance");
	indicator.parameters:addString("DisplayType", "Display Type", "select 'channel' to connect the price lines. select 'lines only' to leave the lines disconnected.", "Channel");
		indicator.parameters:addStringAlternative("DisplayType", "Channel", "", "Channel");
		indicator.parameters:addStringAlternative("DisplayType", "Lines Only", "", "Lines Only");
	indicator.parameters:addColor("LineColor", "Color", "set the color of the lines", core.rgb(0, 0, 0));
	indicator.parameters:addInteger("LineStyle", "Style", "set the style of the lines", 1);
		indicator.parameters:setFlag("LineStyle", core.FLAG_LINE_STYLE);
	indicator.parameters:addInteger("LineWidth", "Width", "set the width of the lines", 2, 1, 5);
	
	indicator.parameters:addString("LabelLocation", "Line Labels Location", "set the location of line labels", "At the End");
		indicator.parameters:addStringAlternative("LabelLocation", "At the End", "", "At the End");
		indicator.parameters:addStringAlternative("LabelLocation", "At the Beginning", "", "At the Beginning");
		indicator.parameters:addStringAlternative("LabelLocation", "Both", "", "Both");
	
end

-- Global Variables
local source = nil;
local first;
local dayref;
local dayloaded = false; -- a global switch that tells us whether or not all required daily data has been loaded
local loading;

local ShowMode;
local DisplayType;
local LineColor;
local LineStyle;
local LineWidth;
local LabelLocation;

local offset;
local weekoffset;


function Prepare()

	-- Assign chosen parameters to their respective Global Variable
	ShowMode = instance.parameters.ShowMode;
	DisplayType = instance.parameters.DisplayType
	LineColor = instance.parameters.LineColor;
	LineStyle = instance.parameters.LineStyle;
	LineWidth = instance.parameters.LineWidth;
	LabelLocation = instance.parameters.LabelLocation;

	-- Assign main price source
    source = instance.source;
	
	-- Assign the Daily/Weekly offset values, generally day candles start at 17:00 New York Time and weekly candles starts on Saturday at 17:00 (Sunday Trading day)
	offset = core.host:execute("getTradingDayOffset");
    weekoffset = core.host:execute("getTradingWeekOffset");
	
	-- Assign name to indicator instance
    local name = profile:id() .. "(" .. source:name() .. ")";
    instance:name(name);

	-- Request Daily candle data for chart's instrument, not immediately available: loading == true
	dayref = core.host:execute("getSyncHistory", source:instrument(), "D1", source:isBid(), 10, 100, 101);
	loading = true
	
	-- Request index of first period that contains Daily data
	first = dayref:first();
	
	-- Create historical price streams if ShowMode == "Historical"
	if ShowMode == "Historical" then
		
		-- Assign style options for Historical data
		PD_High = instance:addStream("High", core.Line, name .. "." .. "PriorDayHigh", "High", LineColor, 0);
		PD_High:setStyle(LineStyle);
		PD_High:setWidth(LineWidth);

		PD_Low = instance:addStream("Low", core.Line, name .. "." .. "PriorDayLow", "Low", LineColor, 0);
		PD_Low:setStyle(LineStyle);
		PD_Low:setWidth(LineWidth);
	
	end
	
	
	
end

-- Indicator calculation routine
function Update(period, mode)

	-- if bar's period is earlier that available daily data, skip bar
	if period < first then
		return;
	end

	-- if daily data is still loading, do nothing
	if loading then
		return;
	end

	
	-- get yesterday's OLE date
	local yesterday, today = getYesterday(source:date(period));
	

	-- find today's data
	local i;
	i = core.findDate(dayref, yesterday, false);

	if i >= 0 then
		-- make sure we have data for today
		if dayref:hasData(i) then
			d2 = source:date(period); -- current bar's date
			d1, d2 = core.getcandle("D1", d2, offset, weekoffset); -- get current daily candle's start and end time

			-- draw line from current daily bar start to current daily bar end time, at previous day's high
			core.host:execute("drawLine", 1, d1, dayref.high[i], d2, dayref.high[i], LineColor, LineStyle, LineWidth, "PD High(" .. tostring(dayref.high[i]) .. ")");
			-- draw label at specified location
			if LabelLocation == "At the End" or LabelLocation == "Both" then
				core.host:execute("drawLabel", 101, d2, dayref.high[i], "Prior High");
			end
			if LabelLocation == "At the Beginning" or LabelLocation == "Both" then
				core.host:execute("drawLabel", 201, d1, dayref.high[i], "Prior High");
			end
		
			-- draw line from current daily bar start to current daily bar end time, at previous day's low
			core.host:execute("drawLine", 2, d1, dayref.low[i], d2, dayref.low[i], LineColor, LineStyle, LineWidth, "PD Low(" .. tostring(dayref.low[i]) .. ")");
			-- draw label at specified location
			if LabelLocation == "At the End" or LabelLocation == "Both" then
				core.host:execute("drawLabel", 102, d2, dayref.low[i], "Prior Low");
			end
			if LabelLocation == "At the Beginning" or LabelLocation == "Both" then
				core.host:execute("drawLabel", 202, d1, dayref.low[i], "Prior Low");
			end
		end
		
	end
	
	
	-- Historical mode
	if ShowMode == "Historical" then
		 -- get specified period's daily candle's start and end time
		local yesterday, today = getYesterday(source:date(period));
		
		-- find the daily period needed for the specified candle
		local i = core.findDate(dayref, yesterday, false);
		
		-- make sure we have data for the required day
		if dayref:hasData(i) then
			
			-- assign price value to stream 'PD_High' at period, at specified daily high
			PD_High[period] = dayref.high[i]
			if PD_High[period] ~= PD_High[period-1] then
				if DisplayType == "Lines Only" then
					PD_High:setBreak(period, true) -- break line if DisplayType is "Lines Only"
				end
			end
			
			-- assign price value to stream 'PD_Low' at period, at specified daily low
			PD_Low[period] = dayref.low[i]
			if PD_Low[period] ~= PD_Low[period-1] then
				if DisplayType == "Lines Only" then
					PD_Low:setBreak(period, true) -- break line if DisplayType is "Lines Only"
				end
			end
			
		end
			
	end
	
	
 end
 
 -- return previous day's OLE date
 function getYesterday(date)
       local today, yesterday;
 
       -- get beginning of the today's candle and round it up to the second
       today = core.getcandle("D1", date, offset, weekoffset);
       today = math.floor(today * 86400 + 0.5) / 86400;
 
       -- get calendar yesterday
       yesterday = today - 1;
 
       local nontrading, nontradingstart;
       nontrading, nontradingstart = core.isnontrading(yesterday, offset);
 
       if nontrading then
           -- if the calendar yesterday date is non-trading (Friday 17:00 EST - Sunday 17:00 EST)
           -- nontradingstart is (Friday 17:00 EST). shift it for one day further.
           yesterday = nontradingstart - 1;
       end
 
       return yesterday, today;
end
 
-- manage when daily data has been loaded and ready
 function AsyncOperationFinished(cookie)
 
	-- daily data download completed
    if cookie == 100 then
		dayloaded = false
        loading = false;
        instance:updateFrom(0); -- reload data streams after data was successfully loaded
		
	-- daily data download started (or re-initalized, ie. chart was scrolled backwards)
    elseif cookie == 101 then
		dayloaded = true
        loading = true;
		
    end

	
end

-- actions taken when indicator has been deleted from a chart
function ReleaseInstance()
	core.host:execute("removeAll") -- delete all lines/streams
end

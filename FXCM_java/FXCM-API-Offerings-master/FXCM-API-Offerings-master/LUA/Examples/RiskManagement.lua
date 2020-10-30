function Init()
    indicator:name("Risk Management");
    indicator:description(" A tool which helps you analye your risk in Trading.");
    indicator:requiredSource(core.Bar);
    indicator:type(core.Indicator);

	indicator.parameters:addString("ACCOUNT", "Account", "", "");
    indicator.parameters:setFlag("ACCOUNT", core.FLAG_ACCOUNT);

    indicator.parameters:addGroup("Calculation");
    indicator.parameters:addDouble("Risk", "Risk Percent", "", 1.0, 0.01, 100);
    --indicator.parameters:addInteger("MaxDrawDown", "MaxDrawDown", "", 5.0, 1.0, 100);
    indicator.parameters:addInteger("Limit", "Take Profit pips", "", 100, 1, 100000);
    indicator.parameters:addInteger("Stop", "Stop Loss pips", "", 75, 1, 100000);

    indicator.parameters:addColor("Color", "Font color", "", core.rgb(0,0,255));
	indicator.parameters:addInteger("Size", "Font Size", "", 10, 1, 20);
    indicator.parameters:addString("Position", "Position", "", "UR");
    indicator.parameters:addStringAlternative("Position", "Upper-Right", "", "UR");
    indicator.parameters:addStringAlternative("Position", "Upper-Left", "", "UL");
    indicator.parameters:addStringAlternative("Position", "Bottom-Right", "", "BR");
    indicator.parameters:addStringAlternative("Position", "Bottom-Left", "", "BL");
end

local first;
local source;
local risk, maxDrawDown;
local takeProfit, stopLoss;
local index;
local indexCount = 0;
local fileName = "_FXCM_Risk_Management_";
local fontSize;
local fontColor;
local Debug = false;

local accountNumber;
local accountName;
local accountType;

local eachPipMoveWorth = pipCost;
local pipSize, pipCost;
local baseUnitSize;
local equityAmount, equityRiskAmount;
local contactSize;
local gainLossPerEachPip;
local maxDrawDownOnEquityCanStand;
local tpPipsMoveWorthInValue, tpPipsMoveWorthInPercent;
local slPipsMoveWorthInValue, slPipsMoveWorthInPercent;

local lastEquity = 0;
local lastMaxDrawDownOnEquityCanStand = 0;
local lastgainLossPerEachPip = 0;
local lastContractSize = 0;
local id = 0;
local lastId = 0;

local fontCreation1, fontCreation, valuefont;

local i;
local xType, yType, hAlign;

function Prepare()

	source = instance.source;
	first = source:first();

	risk = instance.parameters.Risk;
	--maxDrawDown = instance.parameters.MaxDrawDown;
	stopLoss = instance.parameters.Stop;
	takeProfit = instance.parameters.Limit;

	fontSize = instance.parameters.Size;
	fontColor = instance.parameters.Color;
    Position = instance.parameters.Position;
	pipSize = source:pipSize();

	accountNumber = instance.parameters.ACCOUNT;
	baseUnitSize = core.host:execute("getTradingProperty", "baseUnitSize", source:instrument(), accountNumber);
	equityAmount = core.host:findTable("accounts"):find("AccountID", accountNumber).Equity;

	--core.host:trace(" baseUnitSize = " .. baseUnitSize);
   -- core.host:trace(" Position = " .. Position);
	pipCost = core.host:findTable("offers"):find("Instrument", instance.source:instrument()).PipCost;

	if (baseUnitSize == 1000) then
		accountType = "MICRO";
	end

	if (baseUnitSize == 10000) then
		accountType = "MINI";
	end

	if (baseUnitSize == 100000) then
		accountType = "Standard";
	end

	if (Debug == true) then
		--core.host:trace(" pipCost = " .. pipCost);
		--core.host:trace(" baseUnitSize = " .. baseUnitSize);
	end

	fontCreationHeader = core.host:execute("createFont", "Arial", fontSize+2 , false, false);
	fontCreationNonItalics = core.host:execute("createFont", "Arial", fontSize , false, false);
	valuefont = core.host:execute("createFont", "Arial", fontSize , false, true);
	fontCreationItalics = core.host:execute("createFont", "Arial", fontSize , true, false);
	fontCreationNonItalicsNote = core.host:execute("createFont", "Arial", fontSize-2 , false, false);

	local name = profile:id() .. "(".. source:name() .. ", Risk = " .. risk .. ", StopLoss = " .. stopLoss .. ", Take Profit = " .. takeProfit..")";

	instance:name(name);

	--Dashboard positions
    if Position == "UR" then
        xType = core.CR_RIGHT;
        yType = core.CR_TOP;
        hAlign = core.H_Right;
    elseif Position == "UL" then
        xType = core.CR_LEFT;
        yType = core.CR_TOP;
        hAlign = core.H_Left;
    elseif Position == "BR" then
        xType = core.CR_RIGHT;
        yType = core.CR_BOTTOM;
        hAlign = core.H_Right;
    elseif Position == "BL" then
        xType = core.CR_LEFT;
        yType = core.CR_BOTTOM;
        hAlign = core.H_Left;
    end
	
	instrument = string.gsub(tostring(source:instrument()), "/", "");
    if Debug then
        --logger = Logger:create("FXCM-RiskManagement-"..instrument, Logger.DEBUG);
    else
        --logger = Logger:create("FXCM-RiskManagement-"..instrument, Logger.INFO);
    end
	
end

--Business Logic
function Update(period,mode)

	
	if period<source:size()-1 then
		return;
	end
	if LogTag then
		--logger:info(core.formatDate(core.now()).."   Starting Indicator...");
		--logger:info(core.formatDate(core.now()).."   Instrument:" .. source:instrument() .. "   AccountNumber:" .. tostring(accountNumber));
		LogTag = false;
	end
	
	--Calculations
	equityAmount = core.host:findTable("accounts"):find("AccountID", accountNumber).Equity;
	
	equityRiskAmount = equityAmount * risk/100 ;

	contractSize = (equityRiskAmount / stopLoss) / pipCost;

	--maxDrawDownOnEquityCanStand = (equityAmount*(maxDrawDown/100)) / contractSize / pipCost;

	gainLossPerEachPip = contractSize * pipCost;

	tpPipsMoveWorthInValue = takeProfit * gainLossPerEachPip;
	tpPipsMoveWorthInPercent = (tpPipsMoveWorthInValue / equityAmount) * 100;

	slPipsMoveWorthInValue = stopLoss * gainLossPerEachPip;
	slPipsMoveWorthInPercent = (slPipsMoveWorthInValue / equityAmount) * 100;

	if 	lastEquity ~= equityAmount or
		--lastMaxDrawDownOnEquityCanStand ~= maxDrawDownOnEquityCanStand or
		lastgainLossPerEachPip ~= gainLossPerEachPip or
		lastContractSize ~= contractSize
		then
		
		--logger:info(core.formatDate(core.now()).."      NEW OUTPUTS...##################################################################################");
		--logger:info(core.formatDate(core.now()).."                    lastEquity:             " .. tostring(lastEquity));
		--logger:info(core.formatDate(core.now()).."                    equityAmount:           " .. tostring(equityAmount));
		--logger:info(core.formatDate(core.now()).."                    lastgainLossPerEachPip: " .. tostring(lastgainLossPerEachPip));
		--logger:info(core.formatDate(core.now()).."                    gainLossPerEachPip:     " .. tostring(gainLossPerEachPip));
		--logger:info(core.formatDate(core.now()).."                    lastContractSize:       " .. tostring(lastContractSize));
		--logger:info(core.formatDate(core.now()).."                    contractSize:           " .. tostring(contractSize));
		
		--logger:info(core.formatDate(core.now()).."               1");
		for i=0, lastId, 1 do
			core.host:execute("removeLabel", id);
		end
		lastId = 0;
		--logger:info(core.formatDate(core.now()).."               2");
		if (Debug == true) then
			--logger:info(core.formatDate(core.now()).."   Stop Loss value = " .. stopLoss .. " x " .. gainLossPerEachPip .. "=" ..  slPipsMoveWorthInValue);
			--logger:info(core.formatDate(core.now()).."   Stop Loss value = Stoploss pips x Gain/Loss Per Pip" );
			--logger:info(core.formatDate(core.now()).."   Take profit value = " .. takeProfit .. " x " .. gainLossPerEachPip .. " = " .. tpPipsMoveWorthInValue);
			--logger:info(core.formatDate(core.now()).."   Take profit value = take profit pips x Gain/Loss Per Pip" );
			--logger:info(core.formatDate(core.now()).."   Gain/Loss Per Pip = " .. contractSize .. " x " .. pipCost .. " = " .. gainLossPerEachPip);
			--logger:info(core.formatDate(core.now()).."   Gain/Loss Per Pip = contractSize x pipCost" );
			--logger:info(core.formatDate(core.now()).."   contractSize = " .. "(" .. equityRiskAmount .. "/" .. stopLoss .. ")/" .. pipCost .. "=" .. contractSize);
			--logger:info(core.formatDate(core.now()).."   contractSize = (equityRiskAmount / stopLoss) / pipCost" );
			--logger:info(core.formatDate(core.now()).."   equityRiskAmount = " ..  equityAmount .. " x ("..risk.."/100) = " .. equityRiskAmount);
			--logger:info(core.formatDate(core.now()).."   equityRiskAmount = equityAmount x (risk/100)" );
			--logger:info(core.formatDate(core.now()).."   equityAmount = " .. equityAmount);
			--logger:info(core.formatDate(core.now()).."               3");
			--core.host:trace(" equityRiskAmount =  " );
			--core.host:trace(" baseUnitSize = " .. baseUnitSize);
			--core.host:trace(" eachPipMoveWorth = " .. pipCost);
			--core.host:trace(" equityRiskAmount = " .. equityRiskAmount);
			--core.host:trace(" maxDrawDownOnEquity = $" .. maxDrawDownOnEquity);
			--core.host:trace(" maxDrawDownOnEquityCanStand = " .. maxDrawDownOnEquityCanStand .. " pips.");
			--core.host:trace(" tpPipsMoveWorthInValue = " .. tpPipsMoveWorthInValue);
			--core.host:trace(" tpPipsMoveWorthInPercent = " .. tpPipsMoveWorthInPercent);
			--core.host:trace(" slPipsMoveWorthInValue = " .. slPipsMoveWorthInValue);
			--core.host:trace(" slPipsMoveWorthInPercent = " .. slPipsMoveWorthInPercent);

			--core.host:trace(" Stop Loss value = " .. stopLoss .. " x " .. gainLossPerEachPip .. "=" ..  slPipsMoveWorthInValue);
			--core.host:trace(" Stop Loss value = Stoploss pips x Gain/Loss Per Pip" );
			--core.host:trace(" Take profit value = " .. takeProfit .. " x " .. gainLossPerEachPip .. " = " .. tpPipsMoveWorthInValue);
			--core.host:trace(" Take profit value = take profit pips x Gain/Loss Per Pip" );
			--core.host:trace(" Gain/Loss Per Pip = " .. contractSize .. " x " .. pipCost .. " = " .. gainLossPerEachPip);
			--core.host:trace(" Gain/Loss Per Pip = contractSize x pipCost" );
			--core.host:trace(" contractSize = " .. "(" .. equityRiskAmount .. "/" .. stopLoss .. ")/" .. pipCost .. "=" .. contractSize);
			--core.host:trace(" contractSize = (equityRiskAmount / stopLoss) / pipCost" );
			--core.host:trace(" equityRiskAmount = " ..  equityAmount .. " x ("..risk.."/100) = " .. equityRiskAmount);
			--core.host:trace(" equityRiskAmount = equityAmount x (risk/100)" );
			--core.host:trace(" equityAmount = " .. equityAmount);
		end

		id = 0;

        --Set position of display according to user's selection
        if yType == core.CR_TOP then
            spacing = 10;
        else
            spacing = -200;
        end
		--logger:info(core.formatDate(core.now()).."               4");
        local xCo, xCo1, titleCo;
        if xType == core.CR_RIGHT then
            xCo = 1;
            xCo1 = 1;
            titleCo = 1;
        else
            xCo = -0.1;
            xCo1 = -1;
            titleCo = -1;
        end
		--logger:info(core.formatDate(core.now()).."               5");
		-- - - - - - - - - - - - - - - - -
		
		core.host:execute("drawLabel1", id, -375*titleCo, xType, spacing , yType, hAlign, core.V_Center, fontCreationNonItalics, fontColor, "---------------------------------------------------------------------------------------");
		id = id + 1;
		spacing = spacing + 15;
		--logger:info(core.formatDate(core.now()).."               6");

		-- FXCM Risk Management
		core.host:execute("drawLabel1", id, -290*titleCo, xType, spacing , yType, hAlign, core.V_Center, fontCreationHeader, core.rgb(255, 200, 0), " FXCM Risk Calculator");
		id = id + 1;
		spacing = spacing + 25;
		--logger:info(core.formatDate(core.now()).."               7");
		-- FXCM Programming Services
		core.host:execute("drawLabel1", id, -300*titleCo, xType, spacing , yType, hAlign, core.V_Center, fontCreationNonItalics, fontColor, " Inputs                       Outputs ");
		id = id + 1;
		spacing = spacing + 20;
		--logger:info(core.formatDate(core.now()).."               8");
		-- Risk %
		core.host:execute("drawLabel1", id, -340*xCo, xType, spacing, yType, core.H_Right, core.V_Center, fontCreationNonItalics, fontColor, " Risk % :    "  );
		id = id + 1;
		spacing = spacing;
		--logger:info(core.formatDate(core.now()).."               9");
		-- Risk % value
		core.host:execute("drawLabel1", id, -340*xCo, xType, spacing, yType, core.H_Right, core.V_Center, valuefont, fontColor, "              " .. round(risk,2) .. "%");
		id = id + 1;
		spacing = spacing;
		--logger:info(core.formatDate(core.now()).."               10");
		-- Trade Size
		core.host:execute("drawLabel1", id, -200*xCo1, xType, spacing, yType, core.H_Right, core.V_Center, fontCreationNonItalics, fontColor, " TradeSize :  ");
		id = id + 1;
		spacing = spacing + 20;
		--logger:info(core.formatDate(core.now()).."               11");
		-- Trade Size value
		core.host:execute("drawLabel1", id, -200*xCo1, xType, spacing - 20, yType, core.H_Right, core.V_Center, valuefont, fontColor, "                " .. math.floor(contractSize) .. " Lots");
		id = id + 1;
		spacing = spacing;
		--logger:info(core.formatDate(core.now()).."               12");

		-- S/L pips
		core.host:execute("drawLabel1", id, -340*xCo, xType, spacing, yType, core.H_Right, core.V_Center, fontCreationNonItalics, fontColor, " Stop pips :       ");
		id = id + 1;
		spacing = spacing;
		--logger:info(core.formatDate(core.now()).."               13");
		-- S/L pips value
		core.host:execute("drawLabel1", id, -340*xCo, xType, spacing, yType, core.H_Right, core.V_Center, valuefont, fontColor, "              " .. tostring(stopLoss));
		id = id + 1;
		spacing = spacing;
		--logger:info(core.formatDate(core.now()).."               14");
		-- SL
		core.host:execute("drawLabel1", id, -200*xCo1, xType, spacing, yType, core.H_Right, core.V_Center, fontCreationNonItalics, fontColor, " Stop :            ");
		id = id + 1;
		spacing = spacing + 20;
		--logger:info(core.formatDate(core.now()).."               15");
		-- SL value
		core.host:execute("drawLabel1", id, -200*xCo1, xType, spacing - 20, yType, core.H_Right, core.V_Center, valuefont, fontColor, "                -" .. format_num(slPipsMoveWorthInValue, 2, "", "()") );
		id = id + 1;
		spacing = spacing;
		--logger:info(core.formatDate(core.now()).."               16");
		-- T/P pips
		core.host:execute("drawLabel1", id, -340*xCo, xType, spacing, yType, core.H_Right, core.V_Center, fontCreationNonItalics, fontColor, " Limit pips :   " );
		id = id + 1;
		spacing = spacing;
		--logger:info(core.formatDate(core.now()).."               17");
		-- T/P pips value
		core.host:execute("drawLabel1", id, -340*xCo, xType, spacing, yType, core.H_Right, core.V_Center, valuefont, fontColor, "              " .. tostring(takeProfit));
		id = id + 1;
		spacing = spacing;
		--logger:info(core.formatDate(core.now()).."               18");
		-- TP
		core.host:execute("drawLabel1", id, -200*xCo1, xType, spacing, yType, core.H_Right, core.V_Center, fontCreationNonItalics, fontColor, " Limit :             ");
		id = id + 1;
		spacing = spacing + 20;
		--logger:info(core.formatDate(core.now()).."               19");
		-- TP value
		core.host:execute("drawLabel1", id, -200*xCo1, xType, spacing - 20, yType, core.H_Right, core.V_Center, valuefont, fontColor, "                " .. format_num(tpPipsMoveWorthInValue, 2, "", "()") );
		id = id + 1;
		--logger:info(core.formatDate(core.now()).."               20");

		core.host:execute("drawLabel1", id, -340*xCo, xType, spacing, yType, core.H_Right, core.V_Center, fontCreationNonItalics, fontColor, " Equity :     ");
		id = id + 1;
		spacing = spacing + 20;
		--logger:info(core.formatDate(core.now()).."               21");
		--Equity value
		core.host:execute("drawLabel1", id, -340*xCo, xType, spacing - 20, yType, core.H_Right, core.V_Center, valuefont, fontColor, "              ".. format_num(equityAmount,2,"", "()"));
		id = id + 1;
		--logger:info(core.formatDate(core.now()).."               22");
		-- - - - - - - - - - - - - - - - -
		core.host:execute("drawLabel1", id, -375*titleCo, xType, spacing , yType, hAlign, core.V_Center, fontCreationNonItalics, fontColor, "---------------------------------------------------------------------------------------");
		id = id + 1;
		spacing = spacing + 20;

		lastEquity = equityAmount;
		--lastMaxDrawDownOnEquityCanStand = maxDrawDownOnEquityCanStand;
		lastgainLossPerEachPip = gainLossPerEachPip;
		lastContractSize = contractSize;
		lastId = id;
		--logger:info(core.formatDate(core.now()).."               23");
	else
		--logger:info(core.formatDate(core.now()).."   NO NEW OUTPUTS...################################################");
		--logger:info(core.formatDate(core.now()).."                    lastEquity:             " .. tostring(lastEquity));
		--logger:info(core.formatDate(core.now()).."                    equityAmount:           " .. tostring(equityAmount));
		--logger:info(core.formatDate(core.now()).."                    lastgainLossPerEachPip: " .. tostring(lastgainLossPerEachPip));
		--logger:info(core.formatDate(core.now()).."                    gainLossPerEachPip:     " .. tostring(gainLossPerEachPip));
		--logger:info(core.formatDate(core.now()).."                    lastContractSize:       " .. tostring(lastContractSize));
		--logger:info(core.formatDate(core.now()).."                    contractSize:           " .. tostring(contractSize));
	end

end

--------------------------------------------------------------------
-- CODE below is from http://lua-users.org/wiki/FormattingNumbers --
--------------------------------------------------------------------

---============================================================
-- add comma to separate thousands
--
function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

---============================================================
-- rounds a number to the nearest decimal places
--
function round(val, decimal)
	if (decimal) then
		return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
	else
		return math.floor(val+0.5)
	end
end

--===================================================================
-- given a numeric value formats output with comma to separate thousands
-- and rounded to given decimal places
--
function format_num(amount, decimal, prefix, neg_prefix)
	local str_amount,  formatted, famount, remain

	decimal = decimal or 2  -- default 2 decimal places
	neg_prefix = neg_prefix or "-" -- default negative sign

	famount = math.abs(round(amount,decimal))
	famount = math.floor(famount)

	remain = round(math.abs(amount) - famount, decimal)

	-- comma to separate the thousands
	formatted = comma_value(famount)

	-- attach the decimal portion
	if (decimal > 0) then
		remain = string.sub(tostring(remain),3)
		formatted = formatted .. "." .. remain ..
		string.rep("0", decimal - string.len(remain))
	end

	-- attach prefix string e.g '$'
	formatted = (prefix or "") .. formatted

	-- if value is negative then format accordingly
	if (amount<0) then
		if (neg_prefix=="()") then
		formatted = "("..formatted ..")"
		else
		formatted = neg_prefix .. formatted
		end
	end
	return formatted
end

local function getLogPath()local path, fileName, fileHandle, cmd;path=os.getenv("USERPROFILE");if path~=nil then if string.find(path, "Users")~=
nil then path = path .. "\\Documents\\Marketscope";else path = path .. "\\Marketscope";end fileName=string.format("%s\\install.txt", path);
fileHandle=io.open(fileName, "w");if fileHandle==nil then cmd=string.format("MKDIR %s", path);os.execute(cmd);fileHandle = io.open(fileName, "w");
end if fileHandle~=nil then fileHandle:close();end end return path;end Logger={["OFF"]=0,["ERROR"]=1,["INFO"]=2,["DEBUG"]=3};Logger.__index
=Logger;function Logger:create(fileName,logLevel)assert(fileName~=nil,"Invalid log file name");assert(logLevel~=nil,"Invalid log level");assert(type(logLevel)
=="number","Invalid log level");assert(logLevel==Logger.OFF or logLevel==Logger.INFO or logLevel==Logger.DEBUG or logLevel==Logger.ERROR,
"Invalid log level");local logger={_logPath=getLogPath().."\\"..fileName..".txt",_logLevel=logLevel};setmetatable(logger,self);return logger;end function 
Logger:getLogPath()return self._logPath;end function Logger:writeLog(level,msg)local file=io.open(self._logPath,"a+");if file~=nil then file:write(os.date()
.."|"..level.."|"..msg.."\n");file:close();end end function Logger:info(msg)if self._logLevel>=Logger.INFO then self:writeLog("INFO",msg);end end 
function Logger:error(msg)if self._logLevel>=Logger.ERROR then self:writeLog("ERROR", msg);end end function Logger:debug(msg)if self._logLevel
>=Logger.DEBUG then self:writeLog("DEBUG", msg);end end




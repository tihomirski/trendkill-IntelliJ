function Init()
    strategy:name("MACD With SSI Filter");
    strategy:description("This strategy buys when MACD crosses above the Signal line and SSI is negative, and sells when MACD crosses below the Signal line and SSI is positive. Strategy only allows one trade open at a time, per instance.");
	
    strategy.parameters:addString("TF", "Time Frame", "Time frame ('m1', 'm5', etc.) the strategy will be run on.", "m1");
		strategy.parameters:setFlag("TF", core.FLAG_BARPERIODS);

	strategy.parameters:addGroup("MACD Settings");
	strategy.parameters:addInteger("MACDS", "MACDS", "Specify the short EMA length for the MACD calculation", 12);
	strategy.parameters:addInteger("MACDL", "MACDL", "Specify the long EMA length for the MACD calculation.", 26);
	strategy.parameters:addInteger("MACDSignal", "MACDSignal", "Specify the signal line length for the MACD calculation.", 9);
	
	
	-- SSI on/off switch and SSI Buffer Value #####################################
	strategy.parameters:addGroup("SSI (Trend Filter) Settings");
	strategy.parameters:addBoolean("UseSSIFilter", "Use SSI Trend Filter?", "When set to 'Yes' this strategy will only place buy trades when SSI is below -SSI Buffer and only place sell trades when SSI is above SSI Buffer. When set to 'No' SSI is ignored, completely. Does not work for Backtesting. If Backtesting, set to 'No.'", true);
	strategy.parameters:addDouble("SSIBuffer", "SSI Buffer", "Set the minimum SSI reading required in order to trade. (For example, if SSI Buffer is set to 1.75, SSI must be +1.75 or higher to place a sell trade and SSI must be -1.75 or below to place a buy trade. SSI Buffer set to 1 therefore means there is no minimum SSI reading required.)", 1.5, 1, 10000);
	-- ############################################################################
	
	
	strategy.parameters:addGroup("Money Management");
	strategy.parameters:addInteger("LotSize", "LotSize", "Set the trade size; an input of 1 refers to the minimum contract size available on the account", 1);
    strategy.parameters:addDouble("StopLoss", "StopLoss", "Set the distance, in pips, from entry price to place a stoploss on trades", 0.0);
    strategy.parameters:addDouble("Limit", "Limit", "Set the distance, in pips, from entry price to place a limit(ie. Limit) on trades", 0.0);

	strategy.parameters:addGroup("Misc");	
    strategy.parameters:addString("MagicNumber", "MagicNumber", "This will allow the strategy to more easily see what trades belong to it.", "12345");
	strategy.parameters:addString("Account", "Account to trade on", "", "");
		strategy.parameters:setFlag("Account", core.FLAG_ACCOUNT);
		
end

local MACDS;
local MACDL;
local MACDSignal;


-- Create Global Variables ####################################################
local UseSSIFilter;
local SSIBuffer;
-- ############################################################################


local LotSize;
local StopLoss;
local Limit;
local MagicNumber;
local Account;

local Source = nil;

local BaseSize, Offer, CanClose;

local CustomTXT;

local iMACD;


function Prepare(nameOnly)


	-- Assign Parameter Values to Global Variables ####################################
	UseSSIFilter = instance.parameters.UseSSIFilter;
	SSIBuffer = instance.parameters.SSIBuffer;
	-- ################################################################################
	
	
	
	MACDSignal = instance.parameters.MACDSignal;
	MACDS = instance.parameters.MACDS;
	MACDL = instance.parameters.MACDL;
	
    LotSize = instance.parameters.LotSize;
    StopLoss = instance.parameters.StopLoss;
    Limit = instance.parameters.Limit;
	MagicNumber = instance.parameters.MagicNumber;
	Account = instance.parameters.Account;


    local name = profile:id() .. "(" .. instance.bid:instrument() .. ", " .. tostring(instance.parameters.TF) .. ", " .. tostring(MACDS) .. ", " .. tostring(MACDL) .. ", " .. tostring(MACDSignal) .. ", " .. tostring(UseSSIFilter) .. ", " .. tostring(SSIBuffer) .. ", " .. tostring(LotSize) .. ", " .. tostring(StopLoss) .. ", " .. tostring(Limit) .. ", " .. tostring(MagicNumber) .. ")";
    instance:name(name);
    if nameOnly then
        return ;
    end
	
    BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.bid:instrument(), Account);
    Offer = core.host:findTable("offers"):find("Instrument", instance.bid:instrument()).OfferID;
    CanClose = core.host:execute("getTradingProperty", "canCreateMarketClose", instance.bid:instrument(), Account);

    Source = ExtSubscribe(1, nil, instance.parameters.TF, true, "bar");
	
	iMACD = core.indicators:create("MACD", Source.close, MACDS, MACDL, MACDSignal);
	
	CustomTXT = "PSS_MACD_SSI_Example_" .. MagicNumber
	
	
	-- When Using SSI Filter, Checks if SSI is available for symbol ################
	if UseSSIFilter then
		local compatible = false;
		local SSIInstrumentList = {"EUR/USD", "GER30", "USD/JPY", "GBP/USD", "XAU/USD", "GBP/JPY", "EUR/JPY", "USD/CAD", "AUD/USD", "NZD/USD", "US30", "UK100", "EUR/GBP", "AUD/JPY", "USD/CHF", "SPX500", "FRA40", "USOil"};
		for n=1, #SSIInstrumentList do
			if not compatible and SSIInstrumentList[n] == instance.bid:instrument() then
				compatible = true;
			end
		end
		assert(compatible, "\n\nSSI is not available for this trading symbol. Turn off 'SSI Trend Filter' or change symbol to one that is compatible with SSI.");
		require("ssic");
		ssic:init();
	end
	-- ############################################################################
	
	
end


function ExtUpdate(id, source, period)

	-- close bar actions
	if id == 1 then

		iMACD:update(core.UpdateLast);
		
		MACD = iMACD.MACD;
		SIGNAL = iMACD.SIGNAL;

		if not MACD:hasData(period) or not SIGNAL:hasData(period) then
			core.host:trace("Not enough data to calculate indicaor values. No action taken this bar");
			return;
		end
		
		
		-- Request SSI data ###########################################################
		local success, ssi;
		if UseSSIFilter then
			success, ssi = ssic:getSSI(string.gsub(instance.bid:instrument(), "/", ""));
			if not success then
				core.host:trace("Error: SSI Unavailable at this time. No action taken this bar");
				ssi = 0;
				return;
			end
			--core.host:trace("SSI = ".. tostring(ssi));
		end
		-- ############################################################################
		
		
		-- Trading Logic
		if not haveTrades() then
			if core.crossesOver(MACD, SIGNAL, period) and (not UseSSIFilter or ssi<-SSIBuffer) then -- Compares current SSI to SSIBuffer
				enter("B");
			end
			if core.crossesUnder(MACD, SIGNAL, period) and (not UseSSIFilter or ssi>SSIBuffer) then -- Compares current SSI to SSIBuffer
				enter("S");
			end
		end
		
	end
	
end


function enter(BuySell)
	local valuemap, success, msg;

    valuemap = core.valuemap();

    valuemap.OrderType = "OM";
    valuemap.OfferID = Offer;
    valuemap.AcctID = Account;
    valuemap.Quantity = LotSize * BaseSize;
    valuemap.BuySell = BuySell;
    valuemap.GTC = "GTC";
    valuemap.CustomID = CustomTXT;

    if Limit > 0 then
        valuemap.PegTypeLimit = "O";
        if BuySell == "B" then
           valuemap.PegPriceOffsetPipsLimit = Limit;
        else
           valuemap.PegPriceOffsetPipsLimit = -Limit;
        end
    end

    if StopLoss > 0 then
        valuemap.PegTypeStop = "O";
        if BuySell == "B" then
           valuemap.PegPriceOffsetPipsStop = -StopLoss;
        else
           valuemap.PegPriceOffsetPipsStop = StopLoss;
        end
    end

    if (not CanClose) and (StopLoss > 0 or Limit > 0) then
        valuemap.EntryLimitStop = 'Y'
    end
    
    success, msg = terminal:execute(100, valuemap);

    if not(success) then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "alert_OpenOrderFailed: " .. msg, instance.bid:date(instance.bid:size() - 1));
        return false;
    end

    return true;
	
end


function haveTrades(BuySell)
    local enum, row;
    local found = false;
    enum = core.host:findTable("trades"):enumerator();
    row = enum:next();
    while (not found) and (row ~= nil) do
        if row.AccountID == Account and
           row.OfferID == Offer and
           (row.BS == BuySell or BuySell == nil) and
           row.QTXT == CustomTXT then
           found = true;
        end
        row = enum:next();
    end

    return found;
end

function ReleaseInstance()
	-- Realeases SSI dll ##########################################################
	if UseSSIFilter then
		ssic:deinit();
	end
	-- ############################################################################
end



dofile(core.app_path() .. "\\strategies\\standard\\include\\helper.lua");









--+------------------------------------------------------------------+
--|                                      Stochastic MA Strategy.lua  |
--|                               Copyright © 2015, Gehtsoft USA LLC | 
--|                                            http://fxcodebase.com |
--+------------------------------------------------------------------+
--|                                      Developed by : Mario Jemic  |                    
--|                                          mario.jemic@gmail.com   |
--+------------------------------------------------------------------+
--|                                 Support our efforts by donating  | 
--|                                    Paypal: http://goo.gl/cEP5h5  |
--|                    BitCoin : 1MfUHS3h86MBTeonJzWdszdzF2iuKESCKU  |  
--+------------------------------------------------------------------+

function Init() --The strategy profile initialization
    strategy:name("End of Turn_Live Execution Strategy Template.lua");
    strategy:description("");
	
	strategy.parameters:addGroup("Price");
    strategy.parameters:addString("Type", "Price Type", "", "Bid");
    strategy.parameters:addStringAlternative("Type", "Bid", "", "Bid");
    strategy.parameters:addStringAlternative("Type", "Ask", "", "Ask");
	
	strategy.parameters:addString("TF", "Time frame", "", "H1");
    strategy.parameters:setFlag("TF", core.FLAG_PERIODS);

    strategy.parameters:addGroup("1. MA Calculation");
    strategy.parameters:addString("Price1", "MA Price Source", "", "close");
    strategy.parameters:addStringAlternative("Price1", "OPEN", "", "open");
    strategy.parameters:addStringAlternative("Price1", "HIGH", "", "high");
    strategy.parameters:addStringAlternative("Price1", "LOW", "", "low");
    strategy.parameters:addStringAlternative("Price1","CLOSE", "", "close");
    strategy.parameters:addStringAlternative("Price1", "MEDIAN", "", "median");
    strategy.parameters:addStringAlternative("Price1", "TYPICAL", "", "typical");
    strategy.parameters:addStringAlternative("Price1", "WEIGHTED", "", "weighted");	

	strategy.parameters:addString("Method1", "MA Method", "Method" , "EMA");
    strategy.parameters:addStringAlternative("Method1", "MVA", "MVA" , "MVA");
    strategy.parameters:addStringAlternative("Method1", "EMA", "EMA" , "EMA");
    strategy.parameters:addStringAlternative("Method1", "LWMA", "LWMA" , "LWMA");
    strategy.parameters:addStringAlternative("Method1", "TMA", "TMA" , "TMA");
    strategy.parameters:addStringAlternative("Method1", "SMMA", "SMMA" , "SMMA");
    strategy.parameters:addStringAlternative("Method1", "KAMA", "KAMA" , "KAMA");
    strategy.parameters:addStringAlternative("Method1", "VIDYA", "VIDYA" , "VIDYA");
    strategy.parameters:addStringAlternative("Method1", "WMA", "WMA" , "WMA");
	strategy.parameters:addInteger("Period1", "MA Period", "Period" , 25);
	
	strategy.parameters:addGroup("2. MA Calculation");	
	strategy.parameters:addString("Price2", "Price Source", "", "close");
    strategy.parameters:addStringAlternative("Price2", "OPEN", "", "open");
    strategy.parameters:addStringAlternative("Price2", "HIGH", "", "high");
    strategy.parameters:addStringAlternative("Price2", "LOW", "", "low");
    strategy.parameters:addStringAlternative("Price2","CLOSE", "", "close");
    strategy.parameters:addStringAlternative("Price2", "MEDIAN", "", "median");
    strategy.parameters:addStringAlternative("Price2", "TYPICAL", "", "typical");
    strategy.parameters:addStringAlternative("Price2", "WEIGHTED", "", "weighted");	

	strategy.parameters:addString("Method2", "MA Method", "Method" , "EMA");
    strategy.parameters:addStringAlternative("Method2", "MVA", "MVA" , "MVA");
    strategy.parameters:addStringAlternative("Method2", "EMA", "EMA" , "EMA");
    strategy.parameters:addStringAlternative("Method2", "LWMA", "LWMA" , "LWMA");
    strategy.parameters:addStringAlternative("Method2", "TMA", "TMA" , "TMA");
    strategy.parameters:addStringAlternative("Method2", "SMMA", "SMMA" , "SMMA");
    strategy.parameters:addStringAlternative("Method2", "KAMA", "KAMA" , "KAMA");
    strategy.parameters:addStringAlternative("Method2", "VIDYA", "VIDYA" , "VIDYA");
    strategy.parameters:addStringAlternative("Method2", "WMA", "WMA" , "WMA");
	
	strategy.parameters:addInteger("Period2", "MA Period", "Period" , 100);
	
	
	strategy.parameters:addGroup("Strategy Parameters");
    strategy.parameters:addInteger("K", "%K Period", "", 5, 2, 1000);
	strategy.parameters:addInteger("SD", "%D slowing periods", "", 3, 1, 1000);
    strategy.parameters:addInteger("D", "%D Period", "", 3, 1, 1000);
    

    strategy.parameters:addString("A1", "Smoothing method for %K", "", "MVA");
    strategy.parameters:addStringAlternative("A1", "MVA", "", "MVA");
    strategy.parameters:addStringAlternative("A1", "EMA", "", "EMA");
    strategy.parameters:addStringAlternative("A1", "MetaTrader", "", "MT");

    strategy.parameters:addString("A2", "Smoothing method for %D", "", "MVA");
    strategy.parameters:addStringAlternative("A2", "MVA", "", "MVA");
    strategy.parameters:addStringAlternative("A2", "EMA", "", "EMA");

	
    strategy.parameters:addDouble("OS", "Oversold level", "", 20, 1, 100);
    strategy.parameters:addDouble("OB", "Overbought level", "", 80, 1, 100);
	
	 
    

    CreateTradingParameters();
end

function CreateTradingParameters()
    strategy.parameters:addGroup("Trading Parameters");

    strategy.parameters:addBoolean("AllowTrade", "Allow strategy to trade", "", false);   
    strategy.parameters:setFlag("AllowTrade", core.FLAG_ALLOW_TRADE);
	
 
	strategy.parameters:addString("ExecutionType", "End of Turn / Live", "", "End of Turn");
    strategy.parameters:addStringAlternative("ExecutionType", "End of Turn", "", "End of Turn");
	strategy.parameters:addStringAlternative("ExecutionType", "Live", "", "Live");
	
	strategy.parameters:addBoolean("CloseOnOpposite", "Close On Opposite", "", true);
    strategy.parameters:addString("CustomID", "Custom Identifier", "The identifier that can be used to distinguish strategy instances", "SMAS");
	
	strategy.parameters:addInteger("MaxNumberOfPositionInAnyDirection", "Max Number Of Open Position In Any Direction", "", 2, 1, 100);
	strategy.parameters:addInteger("MaxNumberOfPosition", "Max Number Of Position In One Direction", "", 1, 1, 100);
    	
    strategy.parameters:addString("ALLOWEDSIDE", "Allowed side", "Allowed side for trading or signaling, can be Sell, Buy or Both", "Both");
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Both", "", "Both");
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Buy", "", "Buy");
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Sell", "", "Sell");
	
	strategy.parameters:addString("Direction", "Type of Signal / Trade", "", "direct");
    strategy.parameters:addStringAlternative("Direction", "Direct", "", "direct");
    strategy.parameters:addStringAlternative("Direction", "Reverse", "", "reverse");

    strategy.parameters:addString("Account", "Account to trade on", "", "");
    strategy.parameters:setFlag("Account", core.FLAG_ACCOUNT);
    strategy.parameters:addInteger("Amount", "Trade Amount in Lots", "", 1, 1, 100);
    strategy.parameters:addBoolean("SetLimit", "Set Limit Orders", "", false);
    strategy.parameters:addInteger("Limit", "Limit Order in pips", "", 30, 1, 10000);
    strategy.parameters:addBoolean("SetStop", "Set Stop Orders", "", false);
    strategy.parameters:addInteger("Stop", "Stop Order in pips", "", 30, 1, 10000);
    strategy.parameters:addBoolean("TrailingStop", "Trailing stop order", "", false);
    strategy.parameters:addBoolean("Exit", "Use Optional Exit", "", false);
	
    strategy.parameters:addGroup("Alerts");
    strategy.parameters:addBoolean("ShowAlert", "ShowAlert", "", true);
    strategy.parameters:addBoolean("PlaySound", "Play Sound", "", false);
    strategy.parameters:addFile("SoundFile", "Sound File", "", "");
    strategy.parameters:setFlag("SoundFile", core.FLAG_SOUND);
    strategy.parameters:addBoolean("RecurrentSound", "Recurrent Sound", "", true);
    strategy.parameters:addBoolean("SendEmail", "Send Email", "", false);
    strategy.parameters:addString("Email", "Email", "", "");
    strategy.parameters:setFlag("Email", core.FLAG_EMAIL);
	
	 strategy.parameters:addGroup("Time Parameters");
    strategy.parameters:addString("StartTime", "Start Time for Trading", "", "00:00:00");
    strategy.parameters:addString("StopTime", "Stop Time for Trading", "", "24:00:00");

    strategy.parameters:addBoolean("UseMandatoryClosing", "Use Mandatory Closing", "", false);
    strategy.parameters:addString("ExitTime", "Mandatory Closing  Time", "", "23:59:00");
    strategy.parameters:addInteger("ValidInterval", "Valid interval for operation in second", "", 60);
	
	
end
local OpenTime, CloseTime, ExitTime,ValidInterval;
local Source,TickSource;
local MaxNumberOfPositionInAnyDirection, MaxNumberOfPosition;
local SoundFile = nil;
local RecurrentSound = false;
local ALLOWEDSIDE;
local AllowTrade;
local Offer;
local CanClose;
local Account;
local Amount;
local SetLimit;
local Limit;
local SetStop;
local Stop;
local TrailingStop;
local ShowAlert;
local Email;
local SendEmail;
local BaseSize;
local ExecutionType;
local CloseOnOpposite
local first;
local Period1, Period2, Method1,Method2,Price1,Price2;
local OB,OS;
local Stochastic;
local MA1,MA2;
local Direction;
local CustomID;
local Exit;
-- Don't need to store hour + minute + second for each time
local OpenTime, CloseTime, ExitTime;
--
function Prepare( nameOnly)
    CustomID = instance.parameters.CustomID;
	ExecutionType = instance.parameters.ExecutionType;
    CloseOnOpposite = instance.parameters.CloseOnOpposite;
	MaxNumberOfPositionInAnyDirection = instance.parameters.MaxNumberOfPositionInAnyDirection;
	MaxNumberOfPosition = instance.parameters.MaxNumberOfPosition;
	Direction = instance.parameters.Direction == "direct";
	
	ValidInterval = instance.parameters.ValidInterval;
	UseMandatoryClosing = instance.parameters.UseMandatoryClosing;
	
	Price1 = instance.parameters.Price1;
	Price2 = instance.parameters.Price2;
	Method1 = instance.parameters.Method1;
	Method2 = instance.parameters.Method2;
	Period1 = instance.parameters.Period1;
	Period2 = instance.parameters.Period2;
	Exit = instance.parameters.Exit;
	OS = instance.parameters.OS;
    OB = instance.parameters.OB;
	
	

    assert(instance.parameters.TF ~= "t1", "The time frame must not be tick");

    local name;
    name = profile:id() .. "( " .. instance.bid:name() .. "," .. CustomID ..  " )";
    instance:name(name);
   
    PrepareTrading();

    if nameOnly then
        return ;
    end
	
	 
	
	if ExecutionType== "Live" then
	TickSource = ExtSubscribe(1, nil, "t1", instance.parameters.Type == "Bid", "close");
	end
	
    Source = ExtSubscribe(2, nil, instance.parameters.TF, instance.parameters.Type == "Bid", "bar");
    MA1 = core.indicators:create(Method1, Source[Price1],Period1);
	MA2 = core.indicators:create(Method2, Source[Price2],Period2);	
    Stochastic =  core.indicators:create("STOCHASTIC", Source ,instance.parameters.K,instance.parameters.SD, instance.parameters.D, instance.parameters.A1,instance.parameters.A2);
	
	
	first=math.max(MA1.DATA:first(), MA2.DATA:first(), Stochastic.D:first()); 
	
	 local valid;
    OpenTime, valid = ParseTime(instance.parameters.StartTime);
    assert(valid, "Time " .. instance.parameters.StartTime .. " is invalid");
    CloseTime, valid = ParseTime(instance.parameters.StopTime);
    assert(valid, "Time " .. instance.parameters.StopTime .. " is invalid");
    ExitTime, valid = ParseTime(instance.parameters.ExitTime);
    assert(valid, "Time " .. instance.parameters.ExitTime .. " is invalid");
	
	if UseMandatoryClosing then
        core.host:execute("setTimer", 100, math.max(ValidInterval / 2, 1));
    end
	
	
end


-- NG: create a function to parse time
function ParseTime(time)
    local Pos = string.find(time, ":");
    local h = tonumber(string.sub(time, 1, Pos - 1));
    time = string.sub(time, Pos + 1);
    Pos = string.find(time, ":");
    local m = tonumber(string.sub(time, 1, Pos - 1));
    local s = tonumber(string.sub(time, Pos + 1));
    return (h / 24.0 +  m / 1440.0 + s / 86400.0),                          -- time in ole format
           ((h >= 0 and h < 24 and m >= 0 and m < 60 and s >= 0 and s < 60) or (h == 24 and m == 0 and s == 0)); -- validity flag
end

function PrepareTrading()
    ALLOWEDSIDE = instance.parameters.ALLOWEDSIDE;

    local PlaySound = instance.parameters.PlaySound;
    if PlaySound then
        SoundFile = instance.parameters.SoundFile;
    else
        SoundFile = nil;
    end
    assert(not(PlaySound) or (PlaySound and SoundFile ~= ""), "Sound file must be chosen");

    ShowAlert = instance.parameters.ShowAlert;
    RecurrentSound = instance.parameters.RecurrentSound;

    SendEmail = instance.parameters.SendEmail;

    if SendEmail then
        Email = instance.parameters.Email;
    else
        Email = nil;
    end
    assert(not(SendEmail) or (SendEmail and Email ~= ""), "E-mail address must be specified");

    AllowTrade = instance.parameters.AllowTrade;
    Account = instance.parameters.Account;
    Amount = instance.parameters.Amount;
    BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.bid:instrument(), Account);
    Offer = core.host:findTable("offers"):find("Instrument", instance.bid:instrument()).OfferID;
    CanClose = core.host:execute("getTradingProperty", "canCreateMarketClose", instance.bid:instrument(), Account);
    SetLimit = instance.parameters.SetLimit;
    Limit = instance.parameters.Limit;
    SetStop = instance.parameters.SetStop;
    Stop = instance.parameters.Stop;
    TrailingStop = instance.parameters.TrailingStop;
end
 
local Last;
local LAST;
local ONE;


function ExtUpdate(id, source, period)  -- The method called every time when a new bid or ask price appears.
    if AllowTrade then
        if not(checkReady("trades")) or not(checkReady("orders")) then
            return ;
        end
    end
	
	
	if  ExecutionType ==  "Live" and  id == 1 then
			
			period= core.findDate (Source.close, TickSource:date(period), false );		
					
	end

	if  ExecutionType ==  "Live"  then
	
	        if ONE == Source:serial(period) then
			return;
			end
	
			if id == 2 then
			return;
			end		
			
			
		
	else	
			if id ~= 2 then       
			return;
			end
	end

 

    -- update indicators.

	MA1:update(core.UpdateLast);
	MA2:update(core.UpdateLast);
	Stochastic:update(core.UpdateLast);
	
	if period < first  then
        return;
    end
	
	--Buy: EMA25 > EMA100 and stochastic cross in oversold.
    --Sell: EMA25 < EMA100 and stochastic cross in overbought.
	
    
    -- only buy if we have a fast cross over slow and the price is above the moving averages.
    if   MA1.DATA[period]> MA2.DATA[period]
	and Stochastic.K[period] < OS
	and Stochastic.K[period-1]>= OS
	then	
          if Direction then
                BUY();
            else
                SELL();
            end
		ONE= Source:serial(period);
    elseif MA1.DATA[period]< MA2.DATA[period]
	and Stochastic.K[period] > OB
	and Stochastic.K[period-1]<= OB
	then
            if Direction then
                SELL();
            else
                BUY();
            end
		ONE= Source:serial(period);
    end
	
	
	--Closing Buy: cross in overbought.
    --Closing Sell: cross in oversold.
	
	if Exit then
		            if   Stochastic.K[period] > OB
					then 			
								if   Direction then
										   if haveTrades("B") then
											   exitSpecific("B");
											   Signal ("Close Long");
										   end
							   else 
										 if haveTrades("S") then
											   exitSpecific("S");
											   Signal ("Close Short");
										   end
								   
								end
					  end
					  if Stochastic.K[period] < OS
		               then
								   if   Direction then    
										if haveTrades("S") then
										   exitSpecific("S");
										   Signal ("Close Short");
									   end 
								  
								  
							   else 
							   
									  if haveTrades("B") then
										   exitSpecific("B");
										   Signal ("Close Long");
									   end
								
							 
							 end
				
					end
	   end
    

end

-- NG: Introduce async function for timer/monitoring for the order results
function ExtAsyncOperationFinished(cookie, success, message)

    if cookie == 100 then
        -- timer
        if UseMandatoryClosing and AllowTrade then
            now = core.host:execute("getServerTime");
            -- get only time
            now = now - math.floor(now);
            -- check whether the time is in the exit time period
            if now >= ExitTime and now < ExitTime + ValidInterval then
                if not(checkReady("trades")) or not(checkReady("orders")) then
                    return ;
                end
                if haveTrades("S") then
                     exitSpecific("S");
                     Signal ("Close Short");
                end
                if haveTrades("B") then
                     exitSpecific("B");
                     Signal ("Close Long");
               end
            end
        end
    elseif cookie == 200 and not success then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Open order failed" .. message, instance.bid:date(instance.bid:size() - 1));
    elseif cookie == 201 and not success then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Close order failed" .. message, instance.bid:date(instance.bid:size() - 1));
    end
end

--===========================================================================--
--                    TRADING UTILITY FUNCTIONS                              --
--============================================================================--
function BUY()
    if AllowTrade then
        if CloseOnOpposite and haveTrades("S") then
            -- close on opposite signal
            exitSpecific("S");
            Signal ("Close Short");
        end

        if ALLOWEDSIDE == "Sell"  then
            -- we are not allowed buys.
            return;
        end 

        enter("B");
    else
        Signal ("Buy Signal");	
    end
end   
    
function SELL ()		
    if AllowTrade then
        if CloseOnOpposite and haveTrades("B") then
            -- close on opposite signal
            exitSpecific("B");
            Signal ("Close Long");
        end

        if ALLOWEDSIDE == "Buy"  then
            -- we are not allowed sells.
            return;
        end

        enter("S");
    else
        Signal ("Sell Signal");	
    end
end

function Signal (Label)
    if ShowAlert then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[NOW],  Label, instance.bid:date(NOW));
    end

    if SoundFile ~= nil then
        terminal:alertSound(SoundFile, RecurrentSound);
    end

    if Email ~= nil then
        terminal:alertEmail(Email, Label, profile:id() .. "(" .. instance.bid:instrument() .. ")" .. instance.bid[NOW]..", " .. Label..", " .. instance.bid:date(NOW));
    end
end								

function checkReady(table)
    local rc;
    if Account == "TESTACC_ID" then
        -- run under debugger/simulator
        rc = true;
    else
        rc = core.host:execute("isTableFilled", table);
    end

    return rc;
end

function tradesCount(BuySell) 
    local enum, row;
    local count = 0;
    enum = core.host:findTable("trades"):enumerator();
    row = enum:next();
    while row ~= nil do
        if row.AccountID == Account and row.OfferID == Offer and row.QTXT == CustomID and (row.BS == BuySell or BuySell == nil) then
            count = count + 1;
        end

        row = enum:next();
    end

    return count;
end

function haveTrades(BuySell) 
    local enum, row;
    local found = false;
    enum = core.host:findTable("trades"):enumerator();
    row = enum:next();
    while (row ~= nil) do
        if row.AccountID == Account and row.OfferID == Offer and row.QTXT == CustomID and (row.BS == BuySell or BuySell == nil) then
            found = true;
            break;
        end

        row = enum:next();
    end

    return found;
end

-- enter into the specified direction
function enter(BuySell)
    -- do not enter if position in the specified direction already exists
    if tradesCount(BuySell) >= MaxNumberOfPosition
	or ((tradesCount(nil)) >= MaxNumberOfPositionInAnyDirection)	
	then
        return true;
    end

    -- send the alert after the checks to see if we can trade.
    if (BuySell == "S") then
        Signal ("Sell Signal");	
    else
        Signal ("Buy Signal");	
    end

    return MarketOrder(BuySell);
end


-- enter into the specified direction
function MarketOrder(BuySell)
    local valuemap, success, msg;
    valuemap = core.valuemap();

    valuemap.Command = "CreateOrder";
    valuemap.OrderType = "OM";
    valuemap.OfferID = Offer;
    valuemap.AcctID = Account;
    valuemap.Quantity = Amount * BaseSize;
    valuemap.BuySell = BuySell;
    valuemap.CustomID = CustomID;

    -- add stop/limit
    valuemap.PegTypeStop = "O";
    if SetStop then 
        if BuySell == "B" then
            valuemap.PegPriceOffsetPipsStop = -Stop;
        else
            valuemap.PegPriceOffsetPipsStop = Stop;
        end
    end
    if TrailingStop then
        valuemap.TrailStepStop = 1;
    end

    valuemap.PegTypeLimit = "O";
    if SetLimit then
        if BuySell == "B" then
            valuemap.PegPriceOffsetPipsLimit = Limit;
        else
            valuemap.PegPriceOffsetPipsLimit = -Limit;
        end
    end

    if (not CanClose) then
        valuemap.EntryLimitStop = 'Y'
    end

    success, msg = terminal:execute(200, valuemap);

    if not(success) then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Open order failed" .. msg, instance.bid:date(instance.bid:size() - 1));
        return false;
    end

    return true;
end

-- exit from the specified trade using the direction as a key
function exitSpecific(BuySell)
    -- we have to loop through to exit all trades in each direction instead
    -- of using the net qty flag because we may be running multiple strategies on the same account.
    local enum, row;
    local found = false;
    enum = core.host:findTable("trades"):enumerator();
    row = enum:next();
    while (not found) and (row ~= nil) do
        -- for every trade for this instance.
        if row.AccountID == Account and row.OfferID == Offer and row.QTXT == CustomID and (row.BS == BuySell or BuySell == nil) then
           exitTrade(row);
        end

        row = enum:next();
    end
end

-- exit from the specified direction
function exitTrade(tradeRow)
    if not(AllowTrade) then
        return true;
    end

    local valuemap, success, msg;
    valuemap = core.valuemap();

    -- switch the direction since the order must be in oppsite direction
    if tradeRow.BS == "B" then
        BuySell = "S";
    else
        BuySell = "B";
    end
    valuemap.OrderType = "CM";
    valuemap.OfferID = Offer;
    valuemap.AcctID = Account;
    if (CanClose) then
        -- Non-FIFO can close each trade independantly.
        valuemap.TradeID = tradeRow.TradeID;
        valuemap.Quantity = tradeRow.Lot;
    else
        -- FIFO.
        valuemap.NetQtyFlag = "Y"; -- this forces all trades to close in the opposite direction.
    end
    valuemap.BuySell = BuySell;
    valuemap.CustomID = CustomID;
    success, msg = terminal:execute(201, valuemap);

    if not(success) then
        terminal:alertMessage(instance.bid:instrument(), instance.bid[instance.bid:size() - 1], "Close order failed" .. msg, instance.bid:date(instance.bid:size() - 1));
        return false;
    end

    return true;
end

dofile(core.app_path() .. "\\strategies\\standard\\include\\helper.lua");


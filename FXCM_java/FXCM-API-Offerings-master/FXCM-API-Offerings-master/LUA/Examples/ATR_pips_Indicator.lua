function Init()
    indicator:name("ATR pips indicator");
    indicator:description("ATR pips indicator");
    indicator:requiredSource(core.Bar);
    indicator:type(core.Indicator);

    indicator.parameters:addGroup("Calculation");
    indicator.parameters:addInteger("Period", "Period", "", 14);
    indicator.parameters:addDouble("Multiplier", "Multiplier", "", 0.75);

    indicator.parameters:addGroup("Style");
    indicator.parameters:addColor("clr", "Color", "Color", core.rgb(255, 0, 0));
    indicator.parameters:addInteger("FontSize", "Font size", "", 12);
end

local first;
local source = nil;
local Period;
local Multiplier;
local ATR;
local font;

local pip;

function Prepare()
    source = instance.source;
    Period=instance.parameters.Period;
    Multiplier=string.format("%.2f", instance.parameters.Multiplier);

    ATR = core.indicators:create("ATR", source, Period);
    first = source:first()+2;
    local name = profile:id() .. "(" .. source:name() .. ", " .. instance.parameters.Period .. ", " .. instance.parameters.Multiplier .. ")";
    instance:name(name);
    font = core.host:execute("createFont", "Arial", instance.parameters.FontSize, true, false);
end

local temp = 0;
function Update(period, mode)
	--Process if period is the last period
	if (period==source:size()-1) then
		--update the indicator value
		ATR:update(mode);

		--Calculate the pip
		pip = math.floor(ATR.DATA[period]*Multiplier/source:pipSize());
		
		--Draw text onto the screen using position and font declared inside init()
		local Text="" .. math.floor(Multiplier*100) .. "% of ATR (" .. Period .. "):" .. pip .. " pips";
		core.host:execute("drawLabel1", 1,0, core.CR_RIGHT,50, core.CR_TOP, core.H_Left, core.V_Center,
		font, instance.parameters.clr,  Text);

		--Print pip if it changes to console.
		if temp ~= pip then
			core.host:trace(pip .. " Pips");
			temp = pip;
		end
	end
end


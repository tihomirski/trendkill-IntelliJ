
Lua is a scripting language FXCM chose to code indicators and strategies for the Trading Station II platform via its charting package Marketscope. 
FXCM decided on Lua because it is a lightweight, extremely fast, simple and powerful scripting language. 
Lua has been proven as a robust language with uses in several different applications ranging from industrial to gaming

Lua is an extension programming language designed to support procedural programming with data description facilities. 
It offers good support for object-oriented programming, functional programming, and data-driven programming. 
Lua is implemented as a library, written in clean C (that is, in the common subset of ANSI C and C++).

Being an extension language, Lua has no notion of a "main" program: 
it only works embedded in a host client, called the embedding program or simply the host. 
This host program can invoke functions to execute a piece of Lua code, can write and read Lua variables, and can register C functions to be called by Lua code. 
Through the use of C functions, Lua can be augmented to cope with a wide range of different domains, thus creating customized programming languages sharing a syntactical framework. 
The Lua distribution includes a sample host program called lua, which uses the Lua library to offer a complete, stand-alone Lua interpreter.

Lua allows programmers to implement namespaces, classes and other related features using its single table implementations. 
It also allows users to read and write files or parse JSON messages fetched from the web (HTTP requests). 
Lua can even read DLL files (Microsoft), so code can be more encrypted and safe.

The IDE we use for LUA at FXCM is [**Indicore SDK**] (http://fxcodebase.com/wiki/index.php/What_Is_Indicore_SDK/)
This SDK is used to create/debug/test and compile indicators or strategies to be used in Trading Station’s Marketscope charting package.


Indicators: 
Keltner Channel
3 Time Frame Stochastic
RSI Divergence
Golden Cross KAMA
Bullish / Bearish Engulfing Patterns

Alerts:
Price MA Cross Alert
RSI Divergence Signal

Strategies:
MACD with SSI Filter
Stochastic MA Strategy
Parabolic SAR Strategy

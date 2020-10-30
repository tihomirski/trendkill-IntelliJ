## Rest API (still on testing)
Our REST API is a web-based API using a Websocket connection and was developed with algorithmic trading in mind. 

Developers and investors can create custom trading applications, integrate into our platform, back test strategies and build robot trading. Calls can be made in any language that supports a standard HTTP. 

We utilize the new OAuth 2.0 specification for authentication via token. This allows for a more secure authorization to access your application and can easily be integrated with web applications, mobile devices, and desktop platforms

With the use of the socket.io library, the API has streaming capability and will push data notifications in a JSON format. Your application will have access to our real-time streaming market data, subscribe in real time access to trading tables and place live trades.

To begin using our API, you will need the following:

1.	A FXCM account. You can apply for a demo account <a href="https://www.fxcm.com/">here</a> 
2.	A persistent access token. You can generate one from the <a href="https://tradingstation.fxcm.com/">Trading Station web</a>. Click on User Account > Token Management on the upper right hand of the website.
3.	Download Rest API documentation at <a href="https://apiwiki.fxcorporate.com/api/RestAPI/Socket%20REST%20API%20Specs.pdf">here</a>
4. Documentation in Swagger format at <a href="https://fxcmapi.github.io/rest-api-docs/#">here</a> 
5. Start coding.  You will need to reference the <a href="https://socket.io/docs/client-api/">socket.io library</a> in your code. 
   a.	Using Javascript, click <a href="https://www.npmjs.com/package/socket.io">here</a>
   b.	 Using Python, click <a href="https://pypi.python.org/pypi/socketIO-client">here</a>
6. Sample code for Python at <a href="https://apiwiki.fxcorporate.com/api/RestAPI/PermanentTokenPost.py">here</a> 
7. Sample code for Java Script at <a href="https://apiwiki.fxcorporate.com/api/RestAPI/client4.js">here</a>

## Other Trading APIs
Except RestAPI, FXCM offers 3 other trading APIs for free:  Java API, FIX API and ForexConnect with each of them connecting directly to FXCM’s trading server.
 
FIX API is FIX Protocol standard designed for real-time, custom institutional interface which push up to 250 price update per second (not available on other APIs). It is our fastest and most popular option. You will get full range of trading order types available at FXCM. An FXCM TSII account with a $5,000 minimum balance is required.

Java API, a wrapper SDK of FIX API, provides clients with a fully functioning programmable API into the FXCM trading platform, including streaming live price, get historical price and live trades. It is a scalable, light and robust which compatible on any Java-compliant operating system.

The ForexConnect API offers all the same functionality of the powerful FXCM Trading Station. This includes all of the available order types, streaming live price, managing your positions, downloading historical instrument rates, getting account reports, and more. ForexConnect supports C++, C#, Java, VB, VBA, compatible with .Net, Linux, iOS and Android, and it is FREE.

|API Name|Price Feed Frequency|Supporting Languages|Cost|Historical Price|Support CFD|Support MT4|
|:---:|---|---|---|---|---|---|
|**Rest API**|Vary*|Any|Free**|Yes|Yes|Limited Yes|
|**FIX**|Up to 300 per second*|Any|Free***|No|Yes|No|
|**ForexConnect API**|2-3 per second|C++, C#, Java, VB, VBA|Free**|Yes|Yes|Limited Yes|
|**Java Trading API**|2-3 per second|Java|Free**|Yes|Yes|Limited Yes|


>*Market dependent. If the market is volatile you may receive more prices per second.

>**Requires a Standard account.

>***An FXCM account with a $5,000 minimum balance required.

### FIX API: detail at <a href="https://github.com/FXCMAPI/FXCM-API-Offerings/tree/master/FXCM-FIX">here</a>
### Java API: detail at <a href="https://github.com/FXCMAPI/FXCM-API-Offerings/tree/master/FXCM-Java">here</a>
### ForexConnect API: detail at <a href="https://github.com/FXCMAPI/FXCM-API-Offerings/tree/master/FXCM-ForexConnect">here</a>

## Real Case Study:

### Rest API:
1. Learn how to run BT backtest on FXCM historical data via RestAPI at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/RestAPI/BT strategy on FXCM data.zip">here</a>. 
What is <a href="http://pmorissette.github.io/bt/">bt?</a> 
2. Learn how to run QSTrader on FXCM data via RestAPI at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/RestAPI/QSTrader on FXCM data.zip">here</a>. 
what is <a href="https://www.quantstart.com/qstrader">QSTrader?</a>
3. Lean how to build/back test 3 strategies "MovingAverageCrossStrategy","BollingerBandStrategy","DonchianChannelStrategy" via FXCM Rest API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/RestAPI/ThreeStrategies.zip">here</a>.
4. Two more strategies "RangeStrategy", "BreakOutStrategy" at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/RestAPI/2StrategiesViaRestAPI.zip">here</a>.
5. Building/back testing RSI strategy via RestAPI at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/RestAPI/RsiStrategy_ResAPI.zip">here</a>.
6. One video demonstrate how to backtest strategies in Visual Studio via FXCM data On QuantConnect LEAN platform at <a href="https://www.youtube.com/watch?v=m6llfznP4d4">here</a>

### Java API:
1. How to build Rsi signal and back testing using FXCM Java API. <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/JavaAPI/FXCM_Java_API_Tutorial_RsiSignal_Strategy.zip" target="_blank"> click here</a>
2. Learn how to build and backtest CCI Oscillator strategy using Java API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/JavaAPI/CCIOscillatorStrategy-2.zip">here</a>.
3. Lean how to build and back test Breakout strategy using Java API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/JavaAPI/BreakOutStrategy_JavaAPI.zip">here</a>. 
4. Lean how to build and back test Range Stochastic Strategy using Java API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/JavaAPI/RangeStochasticStrategy.zip">here</a>. 
5. Lean how to build and back test Mean Reversion Strategy using Java API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/JavaAPI/MeanReversionStrategy.zip">here</a>. 

### ForexConnect API:
1. Learn how to build and backtest Rsi signals using ForexConnect API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/ForexConnectAPI/RsiSignals_via_ForexConnectAPI.zip">here</a>.
2. Learn how to build and backtest CCI Oscillator strategy using ForexConnect API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/ForexConnectAPI/2.1.CCI_via_FC_API.zip">here</a>.
3. Learn how to build and backtest Breakout strategy using ForexConnect API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/ForexConnectAPI/3.1.BreakoutStrategy_via_FC_API.zip">here</a>.
4. Learn how to build and backtest Range Stochastic Strategy using ForexConnect API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/ForexConnectAPI/4.1.StochasticStrategy_via.FC.API.zip">here</a>.
5. Learn how to build and backtest Mean Reversion Strategy using ForexConnect API at <a href="https://apiwiki.fxcorporate.com/api/StrategyRealCaseStudy/ForexConnectAPI/5.1.MeanReverionStrategy_via_FC_API.zip">here</a>.

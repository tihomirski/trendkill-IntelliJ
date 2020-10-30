# ForexConnect API was designed and provided by FXCM. 
This SDK is designed to get trading data, trade, load price histories and subscribe for the most recent prices. 
It is intended to be used by FXCM clients on auto-trading robots and systems, 
chart and market analysis application, custom trading application on FXCM accounts.

Forex Connect supports C++, C#, Java, VB, VBA, Windows, Linux and smart phones. And it is free.

You can use ForexConnect on Trading station account, no extra setup required.

If using O2G2 namespace, keep in mind that it is currently deprecated as it has not been updated since the beginning of 2015. 
It may give the users errors or not be compatible in certain cases.

[**Download ForexConnect SDK**](http://www.fxcodebase.com/wiki/index.php/Download)

[**Online documents: Getting Started**](https://apiwiki.fxcorporate.com/api/Getting%20Started.pdf)
[**Online documents: C++**](http://fxcodebase.com/bin/forexconnect/1.1.2/help/CPlusPlus/web-content-main.html?key=index.html)

examples codes at ForexConnectAPI packages after installed

For any questions please contact api@fxcm.com.


# Classes

[**CO2GDateUtils:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#CO2GDateUtils.html)
The class converts between the OLE Automation date, SYSTEMTIME, and the C time formats.

[**CO2GTransport:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#CO2GTransport.html)
The class is used to create sessions and to configure the transport parameters.

[**IAddRef:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IAddRef.html)
Manages the existence of an object. All objects created by ForexConnect API implement this interface.

[**IO2GAccountRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GAccountRow.html)
The class provides access to account information.

[**IO2GAccountsTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GAccountsTable.html)
The class keeps up-to-date information about accounts in memory.

[**IO2GAccountsTableResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GAccountsTableResponseReader.html)
The class reads a stream of account rows coming from the trading server.

[**IO2GAccountTableRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GAccountTableRow.html)
The class provides access to the account information and calculated fields.

[**IO2GChartSessionStatus:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GChartSessionStatus.html)
Interface provides method signatures to process notifications about chart session status changes and login failures.

[**IO2GClosedTradeRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GClosedTradeRow.html)
The class provides access to information about a position closed during the current trading day.

[**IO2GClosedTradesTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GClosedTradesTable.html)
The class keeps in memory the up-to-date information about positions closed during the current trading day.

[**IO2GClosedTradesTableResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GClosedTradesTableResponseReader.html)
The class reads a stream of closed position rows coming from the trading server.

[**IO2GClosedTradeTableRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GClosedTradeTableRow.html)
The class provides access to the closed position information.

[**IO2GEachRowListener:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GEachRowListener.html)
The interface provides the method signature to process notifications about iteration through rows of a table.

[**IO2GGenericTableResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GGenericTableResponseReader.html)
The class provides methods to read a stream of trading table rows coming from the trading server.

[**IO2GLastOrderUpdateResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GLastOrderUpdateResponseReader.html)
The class reads a response to a request for the current state of an order.

[**IO2GLoginRules:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GLoginRules.html)
Information about the rules used during the login in the currently established session.

[**IO2GMarketDataSnapshotResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GMarketDataSnapshotResponseReader.html)
The class reads a stream of historical prices.

[**IO2GMessageRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GMessageRow.html)
The class provides access to a message which is intended for the user.

[**IO2GMessagesTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GMessagesTable.html)
The class keeps in memory the up-to-date information about dealing desk messages received during the current trading day.

[**IO2GMessagesTableResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GMessagesTableResponseReader.html)
The class reads a stream of message rows coming from the trading server.

[**IO2GMessageTableRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GMessageTableRow.html)
The class provides access to the message information.

[**IO2GOfferRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOfferRow.html)
The class provides access to offer information.

[**IO2GOffersTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOffersTable.html)
The class keeps in memory the up-to-date information about offers.

[**IO2GOffersTableResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOffersTableResponseReader.html)
The class reads a stream of offer rows coming from the trading server.

[**IO2GOfferTableRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOfferTableRow.html)
The class provides access to the offer information and calculated fields.

[**IO2GOrderResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOrderResponseReader.html)
A reader of a response belonging to the CreateOrderResponse type.

[**IO2GOrderRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOrderRow.html)
The class provides access to order information.

[**IO2GOrdersTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOrdersTable.html)
An interface to the Orders table.

[**IO2GOrdersTableResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOrdersTableResponseReader.html)
The class reads a stream of order rows coming from the trading server.

[**IO2GOrderTableRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GOrderTableRow.html)
The class provides access to the order information and calculated fields.

[**IO2GPermissionChecker:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GPermissionChecker.html)
Checks permissions.

[**IO2GRequest:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GRequest.html)
A request to the server.

[**IO2GRequestFactory:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GRequestFactory.html)
A request factory.

[**IO2GResponse:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GResponse.html)
The class contains a response received from the trading server.

[**IO2GResponseListener:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GResponseListener.html)
The interface provides method signatures to process notifications about request completions, request failures and tables updates.

[**IO2GResponseReaderFactory:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GResponseReaderFactory.html)
The class creates readers to process the content of the trading server responses.

[**IO2GRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GRow.html)
The class provides access to abstract row information.

[**IO2GSession:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GSession.html)
A session object.

[**IO2GSessionDescriptor:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GSessionDescriptor.html)
A trading session descriptor.

[**IO2GSessionDescriptorCollection:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GSessionDescriptorCollection.html)
A collection of the trading session descriptors.

[**IO2GSessionStatus:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GSessionStatus.html)
The interface provides method signatures to process notifications about session status changes and login failure.

[**IO2GSummaryRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GSummaryRow.html)
Summary information about a particular traded instrument in a response object.

[**IO2GSummaryTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GSummaryTable.html)
The class keeps in memory the up-to-date summary information per the instrument traded.

[**IO2GSummaryTableRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GSummaryTableRow.html)
The class provides access to the summary information of the instrument traded.

[**IO2GSystemPropertiesReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GSystemPropertiesReader.html)
A reader of the system properties.

[**IO2GTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTable.html)
An abstract interface to a table.

[**IO2GTableColumn:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTableColumn.html)
The class provides access to a trading table column.

[**IO2GTableColumnCollection:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTableColumnCollection.html)
The class provides access to the list of table columns.

[**IO2GTableIterator:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTableIterator.html)
The class iterates through rows of a table.

[**IO2GTableListener:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTableListener.html)
The interface provides method signatures to process notifications about trading tables events: adding/updating/deleting of rows, and changes in a table status.

[**IO2GTableManager:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTableManager.html)
The class creates and maintains trading tables in the ForexConnect memory.

[**IO2GTableManagerListener:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTableManagerListener.html)
The interface provides a method signature to process notifications about table manager status changes.

[**IO2GTablesUpdatesReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTablesUpdatesReader.html)
The class reads a stream of table updates coming from the trading server.

[**IO2GTimeConverter:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTimeConverter.html)
A date/time converter between the time zones.

[**IO2GTimeframe:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTimeframe.html)
A time frame description.

[**IO2GTimeframeCollection:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTimeframeCollection.html)
A collection of the time frames available for the session.

[**IO2GTradeRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTradeRow.html)
The class provides access to open position information.

[**IO2GTradesTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTradesTable.html)
The class keeps in memory the up-to-date information about open positions.

[**IO2GTradesTableResponseReader:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTradesTableResponseReader.html)
The class reads a stream of open position rows coming from the trading server.

[**IO2GTradeTableRow:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTradeTableRow.html)
The class provides access to the open position information and calculated fields.

[**IO2GTradingSettingsProvider:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTradingSettingsProvider.html)
Checks trading settings.

[**IO2GValueMap:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GValueMap.html)
A value map containing order parameters.

[**O2G2Ptr(T):**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2G2Ptr.html)
Auto-release template class


# Enumerations

[**IO2GChartSessionStatus::O2GChartSessionStatus:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GChartSessionStatus.html)
The enum specifies a set of constants representing the chart session status.

[**IO2GSessionStatus::O2GSessionStatus:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GSessionStatus.html)
The enum specifies a set of constants representing the session status.

[**IO2GTableColumn::O2GTableColumnType:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#IO2GTableColumn_O2GTableColumnType.html)
The enum specifies a set of constants representing the data type of a table column.

[**O2GChartSessionMode:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GChartSessionMode.html)
The enum specifies a set of constants representing the chart session modes.

[**O2GMarketStatus:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GMarketStatus.html)
The enum specifies a set of constants representing the market status.

[**O2GPermissionStatus:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GPermissionStatus.html)
The enum specifies a set of constants representing the permission status.

[**O2GPriceUpdateMode:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GPriceUpdateMode.html)
The enum specifies a set of constants representing the price update mode that indicates if a session receives prices or not.

[**O2GReportUrlError:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GReportUrlError.html)
The errors returned by getReportURL.

[**O2GRequestParamsEnum:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GRequestParamsEnum.html)
The request parameters.

[**O2GResponseType:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GResponseType.html)
The enum specifies a set of constants representing the types of the trading server responses.

[**O2GTable:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GTable.html)
The tables.

[**O2GTableManagerMode:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GTableManagerMode.html)
The enum specifies a set of constants representing the table manager mode that indicates if a session uses a table manager or not.

[**O2GTableManagerStatus:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GTableManagerStatus.html)
The enum specifies a set of constants representing the table manager status.

[**O2GTableStatus:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GTableStatus.html)
The enum specifies a set of constants representing the trading table load status.

[**O2GTableUpdateType:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GTableUpdateType.html)
The enum specifies a set of constants representing the type of the trading table update.

[**O2GTimeConverter::TimeZone:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GTimeConverterTimeZone.html)
The enum specifies a set of constants representing the time zone.

[**O2GTimeframeUnit:**](http://fxcodebase.com/bin/forexconnect/1.3.2/help/CPlusPlus/web-content.html#O2GTimeframeUnit.html)
The enum specifies a set of constants representing the unit of measurement of the historical prices time frame.

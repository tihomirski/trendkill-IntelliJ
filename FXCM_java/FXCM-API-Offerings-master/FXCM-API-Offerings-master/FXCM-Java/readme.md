# FXCM Java Trading API

These are examples of the use of the Java API to place market orders on the first account found (JavaFixTrader.java) and to pull historical rates with the Java API (JavaFixHistoryMiner.java).

## Introduction

The FXCM Trading SDK provides clients with a fully functioning programmable API into the FXCM FX trading platform. The APIs main features are streaming executable FX trading prices, the ability to open/close positions and entry orders as well as set/update/delete stops ands limits. The API Object model is based on the FIX specification for FX (http://www.fixprotocol.org) and is very simple and easy to use. Brief overview of core API classes

IGateway: This is the primary interface into the FXCM trading platform. It contains all the entry points into application usability.

FXCMLoginProperties: This class is used in the login method of IGateway and contains the properties necessary to log in.

CollateralReport: represents an FXCM accounts properties at the time the message was generated. When it is a part of a batch responsethe RequestID can be used to match against the RequestID received from the IGateway.

ExecutionReport: This class represents an orders status in the system. When it is a part of a batch response the RequestID can be used to match against the RequestID received from the IGateway.

PositionReport: This class is used to represent a positions status in the FXCM system. When it is a part of a batch response the RequestID can be used to match against the RequestID received from the IGateway.

ClosedPositionReport: This class represents a closed position in the FXCM system. When it is a part of a batch response the RequestID can be used to match against the RequestID received from the IGateway.

OrderSingle: This class is used to send orders into the system.

CollateralInquiryAck: This class is the first leg of a batch response to retrieve accounts.

RequestForPositionsAck: This class is the first leg of a batch response to retrieve open or closed positions.

MessageGenerator: This class is a factory for all order types available in the API

OrderCancelRequest: This class is used to delete stop/limit orders.

OrderCancelReplaceRequest: This class is used to update entry order prices and also to update stop/limit order prices.

IGenericMessageListener: Implementations of this interface are registered with IGateway to receive application messages.

IStatusMessageListener: Implementations of this interface are registered with IGateway to receive application status messages.

## How to access the JAVA JAR files

1) Click on the link below and download the zip file

https://apiwiki.fxcorporate.com/api/java/trading_sdk.zip

2) Extract the fxcm-api folder to a location of your choice

3) Rename fxcm-api.jar and fxmsg.jar to fxcm-api.zip and fxmsg.zip

4) Extract these files to a location of your choice

You now have access to the contents of the JAR files.

## Netbeans Setup

The FXCM-API-Offerings readme page points to **Netbeans** as an IDE to use with the **Java Trading Api**, but the FXCM-Java/Java-API-Example directory only contains a couple of Eclipse related files. This is how you can setup a Netbeans project to use the examples. There are two basic methods. You can either copy the files into a new Java Application project or you can clone FXCM-API-Offerings and tell Netbeans to create a Java Project with Existing Sources. Either way, we will setup a Library to reference the fxcm-api and fxmsg JAR files.

### FXCM Java API Library

1. Download the trading_sdk.zip file listed in the **JAVA JAR files** section above and extract it to the location of your choice on your computer.
1. Choose Libraries from the Netbeans Tools menu.
1. Click the New Library button and give it a name like FXCM API. The type should be Class Libraries. Click OK.
1. With your new library selected, you are going to update the Classpath, Sources, and Javadoc tabs as follows:
 * **Classpath** Click the Add JAR/Folder button and navigate to the trading_sdk/fxcm-api directory you extracted and select both the fxcm-api.jar and fxmsg.jar files.
 * **Sources** Click the Add JAR/Folder button on the Sources tab and navigate to the trading_sdk/fxcm-api/src directory and click Add JAR/Folder.
 * **Javadoc** Click teh Add ZIP/Folder button on the Javadoc tab and navigate to the trading_sdk/fxcm-api/javadoc directory and click Add ZIP/Folder.
1. Your library is now ready to include in your project. Click OK.

### New Java Application

If you don't care about keeping in sync with this project on GitHub, you can create a new Java Application and copy/paste the source code into the project and work from there.

1. File > New Project or New Project button or Ctr+Shift+N
1. Choose the Java category and Java Application and click Next.
1. Give it a name, verify the location, and your choice on using a *Dedicated Folder for Storing Libraries*. You don't need a main class created, so uncheck that.
1. Create a new Java Class. Name it the same as the examples, either JavaFixHistoryMiner or JavaFixTrader. The source doesn't specify a package so either don't specify one or if you use one, like com.fxcm.example, be sure to leave the package declaration at the top of the file when you paste in the contents.
1. View the raw version of the file on GitHub. Select all and copy, then paste into your new Java class in Netbeans, replacing everything except maybe the package declaration.
1. Right-click on your project's Libraries folder and choose Add Library. Find the FXCM API library you created and click Add Library.

### New Java Project with Existing Sources

If you would like to be able to update with the latest from GitHub, or if you want to Fork and track your own changes, possibly contributing back via pull request, then use this method instead of the previous one to setup Netbeans.

1. Clone the FXCMAPI/FXCM-API-Offerings repository or optionally your fork of it at youruser/FXCM-API-Offerings to a location of your choice on your computer.
1. File > New Project or New Project button or Ctr+Shift+N
1. Choose the Java category and Java Project with Existing Sources and click Next.
1. Give it a name, verify the location, and your choice on using a *Dedicated Folder for Storing Libraries*. The default build script name of build.xml is fine.
1. Click Next and click the Add Folder button.
1. Browse to the FXCM-API-Offerings\FXCM-Java\Java-API-Example directory and click Open.
1. Verify the two .java files are selected and finish.
1. Right-click on your project's Libraries folder and choose Add Library. Find the FXCM API library you created and click Add Library.


DDGameAnalytics
===============

OpenFL extension for the GameAnalytics service. <br>
Supported platforms:
- iOS/Android - Native extensions
- Flash uses an AS3toHaxe version of the official GameAnalytics AS3 API. <b>credited to</b> https://github.com/lordkryss/gameanalytics-haxe
- Other platforms should work but not tested. 
Setup
------

1. clone this repository to a directory of your choice
2. ```haxelib dev ddgameanalytics <clone_location>```
3. Android only, add the following to project.xml: <br>
```<setenv name="GameAnalyticsId" value="YOUR-APP-ID" if="android" />```
```<setenv name="GameAnalyticsSecret" value="YOUR-APP-SECRET" if="android" />```

Initialization
---------------
```
import co.doubleduck.DDGameAnalytics;

DDGameAnalytics.init("YOUR-APP-ID", "YOUR-APP-SECRET", "YOUR-APP-BUILD");
```

Sending Events
---------------
```
DDGameAnalytics.designEvent(event, value, area);
DDGameAnalytics.businessEvent(event, currency, amount, area);
```
Missing features soon to come:
------------------------------
1. Business events for iOS.
2. Quality + User events.

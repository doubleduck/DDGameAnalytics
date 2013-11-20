package co.doubleduck.extensions;

import android.os.Bundle;
import com.gameanalytics.android.GameAnalytics;
import com.gameanalytics.*;
import org.haxe.extension.Extension;


public class GameAnalyticsExt extends Extension 
{
        private static String appID = "::ENV_GameAnalyticsId::"; 
        private static String appSecret = "::ENV_GameAnalyticsSecret::"; 
        
        
        @Override public void onCreate (Bundle savedInstanceState)
        {
			    GameAnalytics.setDebugLogLevel(GameAnalytics.VERBOSE);
                GameAnalytics.initialise(Extension.mainActivity, appSecret, appID);
                GameAnalytics.startSession(Extension.mainActivity);
                GameAnalytics.newDesignEvent("Game:Start",0);
        }
        

        @Override
        public void onResume() {
            super.onResume();
            GameAnalytics.startSession(Extension.mainActivity);
        }

        @Override
        public void onPause() {
            super.onPause();
            GameAnalytics.stopSession();
        }

        public static void designEvent(String eventId, float value, String area){
            GameAnalytics.newDesignEvent(eventId, value, area, 0, 0, 0);
        }

        public static void businessEvent(String eventId, String currency, int amount, String area){
            GameAnalytics.newBusinessEvent(eventId, currency, amount, area, 0, 0 , 0);
        }
        
        
        

        
        
        
        
        
}

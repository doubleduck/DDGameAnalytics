package co.doubleduck.extensions;

import android.os.Bundle;
import com.gameanalytics.android.GameAnalytics;
import com.gameanalytics.android.Severity;
import com.gameanalytics.*;
import java.lang.Float;
import org.haxe.extension.Extension;


public class GameAnalyticsExt extends Extension 
{
        private static String appID = "::ENV_GameAnalyticsId::"; 
        private static String appSecret = "::ENV_GameAnalyticsSecret::"; 
        private static int inited = 0;
        
        
        @Override public void onCreate (Bundle savedInstanceState)
        {
			   
        }
        

        @Override
        public void onResume() {
            super.onResume();
            if (inited == 1) {
              GameAnalytics.startSession(Extension.mainActivity);  
            }
            
        }

        @Override
        public void onPause() {
            super.onPause();
            GameAnalytics.stopSession();
        }

        public static void initGA(String appID, String appSecret, String build) {
                GameAnalytics.setDebugLogLevel(GameAnalytics.RELEASE);
                GameAnalytics.initialise(Extension.mainActivity, appSecret, appID, build);
                GameAnalytics.startSession(Extension.mainActivity);
                inited = 1;
        }

        public static void designEvent(String eventId, float value, String area){
            GameAnalytics.newDesignEvent(eventId, value, area, 0f, 0f , 0f);
        }

        public static void businessEvent(String eventId, String currency, int amount, String area){
            GameAnalytics.newBusinessEvent(eventId, currency, amount, area, 0f, 0f , 0f);
        }
		
		public static void errorEvent(String message, String severity, String area){
			Severity sev = null;
			if (severity.equals("debug")) {
				sev = GameAnalytics.DEBUG_SEVERITY;
			}
			else if (severity.equals("critical")) {
				sev = GameAnalytics.CRITICAL_SEVERITY;
			}
			else if (severity.equals("info")) {
				sev = GameAnalytics.INFO_SEVERITY;
			}
			else if (severity.equals("warning")) {
				sev = GameAnalytics.WARNING_SEVERITY;
			}
			else if (severity.equals("error")) {
				sev = GameAnalytics.ERROR_SEVERITY;
			}
            GameAnalytics.newErrorEvent(message, sev, area, 0f, 0f , 0f);
        }
        
        
        

        
        
        
        
        
}

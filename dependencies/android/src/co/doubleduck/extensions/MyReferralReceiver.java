package ::APP_PACKAGE::;

import com.gameanalytics.android.ReferralReceiver;
import com.gameanalytics.android.GameAnalytics;

public class MyReferralReceiver extends ReferralReceiver {

    @Override
    public String getSecretKey() {
        return "::ENV_GameAnalyticsSecret::";
    }

    @Override
    public String getGameKey() {
        return "::ENV_GameAnalyticsId::";
    }

    @Override
    public int getDebugMode() {
        return GameAnalytics.VERBOSE;
    }
}

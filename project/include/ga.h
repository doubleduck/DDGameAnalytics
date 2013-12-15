#ifndef GAMEANALYTICSEXT_H
#define GAMEANALYTICSEXT_H


namespace ddgameanalytics
{
    void gaInit(const char *appId, const char *appSignature, const char *appVersion);
	void gaDesignEvent(const char *eventId, float value, const char *area);
	void gaErrorEvent(const char *message, const char *severity, const char *area);
	void gaBusinessEvent(const char *eventId, const char *currency, int amount, const char *area);
}

#endif
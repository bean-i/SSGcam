package com.example.front;

import android.util.Log;

import io.flutter.plugin.common.EventChannel.EventSink;

public class EventChannelManager {

    private static final String TAG = "VoiceFCMService";
    private static EventChannelManager instance;
    private EventSink eventSink;

    private EventChannelManager() {}

    public static EventChannelManager getInstance() {
        if (instance == null) {
            instance = new EventChannelManager();
        }
        return instance;
    }

    public void setEventSink(EventSink eventSink) {
        this.eventSink = eventSink;
    }

    public void sendEventToFlutter(String event) {
        if (eventSink != null) {
            try {
                eventSink.success(event);
            } catch (Exception e) {
                Log.e(TAG, "Error sending event", e);
            }

        }
    }
}

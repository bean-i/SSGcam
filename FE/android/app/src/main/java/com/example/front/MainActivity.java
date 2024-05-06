package com.example.front;

import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "eventChannel";
    private static final String TAG = "VoiceFCMService";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setStreamHandler(new EventChannel.StreamHandler() {
                @Override
                public void onListen(Object arguments, EventSink events) {
                    EventChannelManager.getInstance().setEventSink(events);
                    Log.d(TAG, "onListen 실행");
                }

                @Override
                public void onCancel(Object arguments) {
                    EventChannelManager.getInstance().setEventSink(null);
                }
            });
    }

}

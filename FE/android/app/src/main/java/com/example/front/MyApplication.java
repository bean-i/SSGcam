package com.example.front;

import android.app.Application;
import android.util.Log;
import com.google.firebase.messaging.FirebaseMessaging;

public class MyApplication extends  Application{
    @Override
    public void onCreate() {
        super.onCreate();
        // 전역 리소스 초기화
        Log.d("MyApplication", "Application started!");
//        String accessToken = "YOUR_ACCESS_TOKEN";
//        Voice.initialize(this, accessToken);

        FirebaseMessaging.getInstance().subscribeToTopic("incoming_calls");


    }
}

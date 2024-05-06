package com.example.front;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;


public class MyFirebaseMessagingService extends FirebaseMessagingService {
    private static final String TAG = "VoiceFCMService";

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {

        Log.d(TAG, "Received onMessageReceived()");
        Log.d(TAG, "Bundle data: " + remoteMessage.getData());
        Log.d(TAG, "From: " + remoteMessage.getFrom());


        // 메인 스레드에서 처리하기 위해 Handler 사용
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                if (remoteMessage.getNotification() != null) {
                    String callStatus = remoteMessage.getData().get("CallStatus");
                    if ("ringing".equals(callStatus)) {
                        Log.d(TAG, "전화옴");
                        EventChannelManager.getInstance().sendEventToFlutter("ringing");
                    }
                }
            }
        });
    }

    // 데이터 형번환
//    private static Map<String, String> formatToMap(Map<String, String> data) {
//        Map<String, String> resultMap = new HashMap<>();
//
//        for (Map.Entry<String, String> entry : data.entrySet()) {
//            String key = entry.getKey();
//            String value = entry.getValue().trim();
//
//            // 값에서 작은따옴표를 제거하고 큰따옴표로 감싸기
//            if (value.startsWith("'") && value.endsWith("'")) {
//                value = "\"" + value.substring(1, value.length() - 1) + "\"";
//            } else {
//                // 값이 작은따옴표로 감싸져 있지 않은 경우도 큰따옴표로 감싸기
//                value = "\"" + value + "\"";
//            }
//
//            // 결과 Map에 키와 값을 추가
//            resultMap.put("\"" + key + "\"", value);
//        }
//
//        return resultMap; // 수정된 Map 반환
//    }


//    @Override
//    public void onNewToken(String token) {
//        super.onNewToken(token);
//        Intent intent = new Intent(Constants.ACTION_FCM_TOKEN);
//        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
//    }

//    private void handleInvite(CallInvite callInvite, int notificationId) {
//        Intent intent = new Intent(this, IncomingCallNotificationService.class);
//        intent.setAction(Constants.ACTION_INCOMING_CALL);
//        intent.putExtra(Constants.INCOMING_CALL_NOTIFICATION_ID, notificationId);
//        intent.putExtra(Constants.INCOMING_CALL_INVITE, callInvite);
//
//        startService(intent);
//    }
//
//    private void handleCanceledCallInvite(CancelledCallInvite cancelledCallInvite) {
//        Intent intent = new Intent(this, IncomingCallNotificationService.class);
//        intent.setAction(Constants.ACTION_CANCEL_CALL);
//        intent.putExtra(Constants.CANCELLED_CALL_INVITE, cancelledCallInvite);
//
//        startService(intent);
//    }


}

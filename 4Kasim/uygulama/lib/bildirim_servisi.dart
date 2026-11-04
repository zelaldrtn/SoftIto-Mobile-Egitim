import 'package:firebase_messaging/firebase_messaging.dart';

//ekran kapalıyken bile bildirim gönderebilmessi içn sınıfın dışında bir pragma olmalı. her zaman en üstte olmalı
//pragma: herşeyden bağımsız bir şekilde arkaplanda çalışan kod bloğu  
//bu bölümde pragma arkadan gelen mesajı yakalar ama biz bu mesajı uygulamaya göstermek için ayrı metot yazmalıyız
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
    print("Arkaplanda bildirim geldi: ${message.notification?.title}");
}

class BildirimServisi{
    final FirebaseMessaging _fcm=FirebaseMessaging.instance;
    Future<void> baslat() async{
        NotificationSettings settings=await _fcm.requestPermission(
            alert: true,
            badge: true,
            sound: true,
        );
        if(settings.authorizationStatus==AuthorizationStatus.authorized){
            print("Kullanıcı bildirim izni verdi");
        }
        final token = await _fcm.getToken();
        print('Cihazın FCM tokenı: $token');

        
    }
}
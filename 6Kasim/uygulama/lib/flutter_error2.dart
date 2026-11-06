import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class HataServisi{
    final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

    Future<void> kullaniciTanit({
        required String uid,
        required String rol,
        required String paket,
    }) async{
        await _crashlytics.setUserIdentifier(uid);
        await _crashlytics.setCustomKey('kullanici_rolu', rol);
        await _crashlytics.setCustomKey('uyelik_tipi', paket);
    }

    void ayakIziBirak(String adim){
        _crashlytics.log('kullanıcı işlemi: $adim');
    }

    Future<void> sessizHataKaydet(dynamic hata, StackTrace stack) async{
        await _crashlytics.recordError(hata,stack,fatal:true);
    }

    ElevatedButton(
        onPressed:(){
            FirebaseCrashlytics.instance.crash();
        },
            child:const Text('Çökme Testi Gönder')
        );
}
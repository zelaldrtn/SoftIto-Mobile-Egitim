import 'package:firebase_crashlytics/firebase_crashlytics.dart';

//bu sınıfı app'teki hataları bulmak ve raporlamak için kurduk.
class CrashlyticsServisi {
    //burası crashlytics'i başlatıyor.
    final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

    //bu future da kullanıcı bilgileriyle crashlytics'i besliyoruz. bu sayede hangi kullanıcı hatayı yapmış,
    //rolü neymiş, hangi platformu kullanıyormuş görebiliyoruz. 
    Future<void> kullaniciTanit({
        required String uid,
        required String rol,
    }) async{
        await _crashlytics.setUserIdentifier(uid);
        await _crashlytics.setCustomKey('rol', rol);
        await _crashlytics.setCustomKey('platform', 'flutter' );
    }

    //bu fonksiyon da hata durumlarında log kaydetmek için kullanılıyor.
    void logEkle(String mesaj){
        _crashlytics.log(mesaj);
    }

    //bu da sessiz hataları kaydetmek için kullanılıyor. yani fatale dönüşmeyen hatalar.
    //fatal: false dediğimz zaman hatayı ön tarafa vermiyor. arka planda tutuyır
    Future<void> sessizHataKaydet(dynamic hata,StackTrace stack) async{
        await _crashlytics.recordError(hata,stack,fatal:false);
    }

    //bu fonksiyon da test amaçlı yazıldı. butona basınca app crash yapacak.
    void kastenCokerme(){
        _crashlytics.crash();
    }
}

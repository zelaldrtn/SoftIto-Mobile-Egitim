import 'package:firebase_analytics/firebase_analytics.dart';

//bu sınıfı neden kurduk?: her yerden firebase analytics import etmeyelim, tek noktadan yönetelim.
class AnalyticsServisi{
    //firebase analytics instance'ına erişim sağlayan _analytics nesnesi 
    final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

    //bu future da parametre olarak gelen ekran ismini firebase analytics e gönderiyoruz.
    //firebase analytics de hangi ekran görüntülenmiş onu kaydediyor.
    Future<void> ekranGoruntulendi(String ekranAdi) async{
        await _analytics.logScreenView(screenName: ekranAdi);
    }

    // bu future da ise parametre olarak gelen olayın adını ve parametrelerini firebase analytics e gönderiyoruz.
    //firebase analytics de hangi olayın ne zaman gerçekleştiğini kaydediyor.
    Future<void> olayGonder({
        required String olayAdi,
        //neden 'Object' yaptık?: firebase analytics 'Map<String, dynamic>' değil, 'Map<String, Object>' kabul ediyor.
        Map<String, Object>? parametreler,
    }) async{
        await _analytics.logEvent(name: olayAdi, parameters: parametreler);
    }

    //burada ise kullanıcı özelliklerinifirebase analytics e gönderiyoruz.
    //firebase analytics de hangi kullanıcının hangi özelliği olduğunu kaydediyor.
    Future<void> kullaniciOzelligiBelirle({
        required String anahtar,
        required String deger,
    }) async {
        await _analytics.setUserProperty(name: anahtar, value: deger);
    }
}
//remote config: uygulmayı güncellemeden tek seferde istediğimiz parametreyi değiştirebiliriz.

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigServisi{
    final FirebaseRemoteConfig _rc=FirebaseRemoteConfig.instance;

    Future<void> baslat() async{
        await _rc.setConfigSettings(
            RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval:Duration.zero,
        ),
    );    
    await _rc.setDefaults({
        'kampanya_aktif': false,
        'kampanya_metni': 'Bugun kampanya var',
        'zorunlu_surum': '1.0.1',
    });

// burada veritabanından değerleri çekeriz, eğer bir hata olursa varsayılan değerleri kullanır
    await _rc.fetchAndActivate();
}
    bool get kampanyaAktifMi => _rc.getBool('kampanya_aktif'); //true gelirse kampanyayı gösterir
    String get kampanyaMetni => _rc.getString('kampanya_metni'); //kampanyanın metni neyse onu getirir
    String get zorunluSurum => _rc.getString('zorunlu_surum'); //uygulaması 1.0.1 değilse güncelle uyarısı gösterir. zorunlu surum.}
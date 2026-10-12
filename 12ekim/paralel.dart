/*
Future<void> fetchDashboardData() async {
  try{
    final result=await Future.wait([  //result olrk bu 3 fonksiyondan gelen verileri çekecek
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ],eagerError: true);

    print("Tüm veriler geldi $result");
  }catch(e){
    print("İsteklerden biri başarısız oldu $e");
  }
}
*/

//Future : Tek bir kere veri çekeceğimiz zaman kullanılır ya hata yada değer dönüp bitirir.
//Stream : Bir boru hattı şeklinde çalışır (pipe), zaman içinde 1 10 100 yada sonsuz sayıda veri akılı sağlanabilir.
//(Borsa fiyatları GPS konum güncelle, Firebase canlı dinleme)

import 'dart:async';

void main(){
  //controller oluşturma
  final controller=StreamController<int>();
  //dinleyici (listesini) bağlama
  final subscription = controller.stream.listen(
    (data) => print("yeni veri: $data"),
    onError: (err) => print("Hata oluştu: $err"),
    onDone: () => print("Yayın Tamamlandı"),
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);


  //broadcast : birden fazla dinleyici
  final broadcastStream=controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("UI Ekranı: $d"));
  broadcastStream.listen((d) => print("Analitik Servis Ekranı: $d"));

  controller.close();
}




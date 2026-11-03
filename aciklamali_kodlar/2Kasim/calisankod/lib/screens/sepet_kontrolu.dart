import 'package:flutter/material.dart';

// sepet durumunu yöneten tekil (singleton) kontrol sınıfı
class SepetKontrolu{
    // uygulamanın her yerinden aynı örneğe erişmek için singleton kalıbı
    static final SepetKontrolu ornek=SepetKontrolu._dahili();
    // gizli kurucu ile dışarıdan yeni nesne oluşturulmasını engelliyoruz
    SepetKontrolu._dahili();

    // urunSayisi değiştiğinde sadece dinleyen widget'ları tetikleyen ValueNotifier
    final ValueNotifier<int> urunSayisi=ValueNotifier<int>(0);

    // sepete ürün ekleyip sayıyı bir artırır
    void sepeteEkle(){
        urunSayisi.value++;
    }

    // sepet sayısını sıfırlar
    void sepetSifirla(){
        urunSayisi.value=0;
    }
}


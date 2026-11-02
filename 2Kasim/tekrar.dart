// Mülakat için önemli: Sealde sınıflar dışardan extend edilmes. switch içinde tüm alt 
//sınıflar tüketilmek zorundadır.

//bu sınıfı yazma amacımız: bir metodun geriye döndüreceği değerleri tek bir noktada tutmak.
//sealed sayesinde aynı kütüphane (library) dışından bu sınıf extend edilemez veya implement edilemez.
sealed class OdemeDurumu {}

//burda sınıfın içinde kullanmıyoruz.
class OdemeBasarili extends OdemeDurumu {
    final ({String referansKodu, double tutar}) veri;
    OdemeBasarili(this.veri);
}

class OdemeBasarisiz extends OdemeDurumu{
    final String hataNedeni;
    OdemeBasarisiz(this.hataNedeni); 
}

//Neden kendi içindeki nesneleri this ile yazıyoruz?: çünkü durum classları. Nesnelerini dışarıdan üretmiyoruz. 

//sözleşme(interface,abstract class) nedir?: uygulamayı çalıştırırken orda yazdığımız verileri kullanma zorunluluğu veriyoruz.

abstract class IBankaServisi{
    Future<OdemeDurumu> odeme({required double miktar});
}

//mixin: bir fonksiyona/classa başka bir fonk./class kullanarak yetenek kazandırıyoruz.
mixin GuvenlikDenetimiMixin{
    bool tokenGecerliMi(String token){
        return token.isNotEmpty && token.length >=32;
    }
}

mixin AuditLogMixin{
    void islemKaydet(String mesaj){
        final zaman = DateTime.now().toIso8601String();
        print('Log - $zaman: $mesaj');
    }
}


//bütün bunları çalıştıracağımız ana classı yazalım

class GarantiBankasiServisi with GuvenlikDenetimiMixin,AuditLogMixin implements IBankaServisi{
    final String apiAnahtari;
    GarantiBankasiServisi({required this.apiAnahtari});

    @override
    Future<OdemeDurumu> odeme({required double miktar}) async {
        if(!tokenGecerliMi(apiAnahtari)){
            islemKaydet('Ödeme Reddedildi. Geçersiz API Anahtari');
            return OdemeBasarisiz('Yetkilendirme hatası: Geçersiz token');
        }

        await Future.delayed(const Duration(milliseconds:1000));

        islemKaydet('$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI');

        return OdemeBasarili((referansKodu:'GRNT-${DateTime.now().millisecondsSinceEpoch}',tutar:miktar));
    }
}

//switch yazma sebebi: else demeden tüm durumları kontrol etmek. 
void odemeSonucunuEkranaBas(OdemeDurumu durum){
    final mesaj = switch (durum){
        OdemeBasarili b => 'Ödeme Başarılı. Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar}₺',
        OdemeBasarisiz h=> 'Ödeme Başarısız. Gerekçe: ${h.hataNedeni}',
    };
    print(mesaj);
}

void main() async{
    final sonuc = GarantiBankasiServisi(apiAnahtari:'kugkugkugkgkugkugkugıkugıugıugıug');
    final durum = await sonuc.odeme(miktar:100);
    odemeSonucunuEkranaBas(durum);
}

import 'package:cloud_firestore/cloud_firestore.dart';

class OgrenciModel{
    final String id;
    final String adSoyad;
    final String projeAdi;
    final int notu;
    final DateTime kayitTarihi;

    const OgrenciModel({
        required this.id,
        required this.adSoyad,
        required this.projeAdi,
        required this.notu,
        required this.kayitTarihi,
    });

    //snapshot: veri çekerken yedeğini almak. dosya bazlı da alınabilir.
    factory OgrenciModel.fromFireStore(DocumentSnapshot doc){
        final veri = doc.data() as Map<String, dynamic>? ?? {};

        //birini doctan diğerini veriden alıyoruz. çünkü id yi sistem otomatik atıyor.
        return OgrenciModel(
            id:doc.id,
            adSoyad: veri['adSoyad'] as String? ?? "İsimsiz Öğrenci Shad",
            projeAdi: veri['projeAdi'] as String? ?? "Henüz proje yok.",
            notu:(veri['notu'] as num?)?.toInt() 0,
            kayitTarihi:
                (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
        ); 
    }
}

//
class FirestoreOgrenciServisi{
    final CollectionReference _ogrencilerKoleksiyonu=FirebaseFirestore.instance.collection('ogrenciler');
    Future<void> ogrenciEkle({
        required String adSoyad,
        required String projeAdi,
        required int notu,
    }) async{
        try{
            await _ogrencilerKoleksiyonu.add({
                'adSoyad':adSoyad,
                'projeAdi':projeAdi,
                'notu':notu,
                'kayitTarihi':FieldValue.serverTimeStamp(),
            });
            print('Öğrenci başarıyla kaydedildi');
        }catch(e){
            print('Öğrenci ekleme başarısız: $e');
            rethrow; //rethrow: hatayı yakaladıktan sonra kullanıcıya göstermek için
        }
    }

    //void yanıtsız kalmadığı sürece bu fonksiyonu her türlü bitirir. await sayesinde de arka planda log tutulur.
    Future<void> ogrenciIdIleKaydet({
        required String tcNo, 
        required String adSoyad,
        required String projeAdi,
    }) async{
        await _ogrencilerKoleksiyonu.doc(tcNo).set({
            'adSoyad': adSoyad,
            'projeAdi': projeAdi,
            'guncellemeTarihi': FieldValue.serverTimestamp(),
        },SetOptions(merge: true)); //merge göndermezsek her seferinde diğer verileri silerdi.
    }

    Future<List<OgrenciModel>> tumOgrencileriGetir() async{
        try{
            final QuerySnapshot snapshot=await _ogrencilerKoleksiyonu.orderBy('notu', descending:true).get();
            return snapshot.docs.map((doc)=>OgrenciModel.fromFireStore(doc)).toList();
        }catch (e){
            print("veri çekme hatası: $e");
            return [];
        }
    }

    Future<void> ogrenciNotuGuncelle(String documanId,int yeniNot)async{
        await _ogrencilerKoleksiyonu.doc(documanId).update({
            'notu':yeniNot,
            'sonDuzenleme':FieldValue.serverTimestamp(),
        });
    }
    Future<void> ogrenciSil(String documanID)async{
        await _ogrencilerKoleksiyonu.doc(documanId).delete();
        print('$documanID referanslı veri tamammen silindi');
    }
}
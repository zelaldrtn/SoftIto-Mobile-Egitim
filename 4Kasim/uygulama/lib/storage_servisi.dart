import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServisi {

    //firebase storage servisini kullanmak için storage nesnesi oluşturduk
    //instance: tek bir defa çalışmasını sağlıyor   
    final FirebaseStorage _storage = FirebaseStorage.instance;

    UploadTask yuklemeBaslat({
        required File dosya,
        required String hedefDizin,
        required String dosyaAdi,
    }){
        final Reference ref = _storage.ref().child('$hedefDizin/$dosyaAdi');
        final metadata=SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'yukleyen': 'Faik fahri',
            },
        );
        return ref.putFile(dosya,metadata);
    }

    task.snapshot.listen((TaskSnapshot snapshot){
        //benm gönderdiğim transferi toplam byte boyutuna bölerek yüzdesini alıyoruz
        final double yuzde= snapshot.bytesTransferred / snapshot.totalBytes;
        print('Yükleniyor %${(yuzde*100).toStringAsFixed(1)}');
    });
    
}
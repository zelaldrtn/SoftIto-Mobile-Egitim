import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../services/mock_product_service.dart';
import '../services/i_product_service.dart';

class UrunListesiEkrani extends StatefulWidget{
    const UrunListesiEkrani({super.key});

    @override
    State<UrunListesiEkrani> createState() =>_UrunListesiEkraniState();

}

class _UrunListesiEkraniState extends State<UrunListesiEkrani>{
    final IProductService _servis = MockProductService();
    bool _yukleniyorMu=true;

    Kategori _seciliKategori=Kategori.hepsi;

    String _aramaKelimesi="";

    List<Urun> _gosterilenUrunler=[];

    @override
    void initState(){
        super.initState();
        _urunleriYukle();
    }


    Future<void> _urunleriYukle() async{
        setState((){
            _yukleniyorMu = true;
        });

        final urunler = await _servis.kategoriyeGoreGetir(_seciliKategori);

        if(mounted){
            setState((){
                _gosterilenUrunler=urunler;
                _yukleniyorMu=false;
            });
        }
    }


    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(
                title: const Text("Mini Mağaza"),
            ),
            body:_yukleniyorMu?const Center(child:CircularProgressIndicator())
            :Center(child:Text('${_gosterilenUrunler.length} Adet Ürün Hazır')),
        );        
    }
}
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../services/mock_product_service.dart';
import '../services/i_product_service.dart';
import '../widgets/urun_karti.dart';

// ürünlerin listelendiği, arama ve filtreleme yapılan ana sayfa
class UrunListesiEkrani extends StatefulWidget{
    const UrunListesiEkrani({super.key});

    @override
    State<UrunListesiEkrani> createState() =>_UrunListesiEkraniState();

}

class _UrunListesiEkraniState extends State<UrunListesiEkrani>{
    // veri çekme servisini arayüzden soyutlamak için arayüz (interface) tipi üzerinden tanımlıyoruz
    final IProductService _servis = MockProductService();
    final TextEditingController _aramaController=TextEditingController();

    // yüklenme animasyonunu kontrol eden bayrak
    bool _yukleniyorMu=true;

    // varsayılan olarak tüm kategoriler seçili başlar
    Kategori _seciliKategori=Kategori.hepsi;

    // ana veri kaynağımız ve filtrelenmiş anlık liste
    List<Urun> _tumUrunler=[];
    List<Urun> _filtrelenmisUrunler=[];

    // ekran ilk açıldığında çalışan yaşam döngüsü metodu
    @override
    void initState(){
        super.initState();
        _urunleriYukle();
    }

    // ekran kapandığında controller'ı bellekten temizliyoruz
    @override
    void dispose(){
        _aramaController.dispose();
        super.dispose();
    }

    // servisten asenkron olarak ürünleri çekip state'e aktaran fonksiyon
    Future<void> _urunleriYukle() async{
        setState((){
            _yukleniyorMu = true;
        });

        final urunler = await _servis.tumUrunleriGetir();
        // mounted: asenkron işlem bittiğinde ekran hâlâ ekranda mı diye kontrol eder
        if(mounted){
            setState((){
                _tumUrunler=urunler;
                _filtrelenmisUrunler=urunler;
                _yukleniyorMu=false;
            });
        }
    }

    // hem arama kutusuna hem de kategori seçimine göre listeyi süzer
    void _filtreyiUygula(){
        final aranan=_aramaController.text.trim().toLowerCase();

        setState((){
            _filtrelenmisUrunler=_tumUrunler.where((urun){
                final kategoriUygunMu=(_seciliKategori==Kategori.hepsi) || (urun.kategori ==_seciliKategori);
                final aramaUygunMu=aranan.isEmpty || urun.baslik.toLowerCase().contains(aranan) || urun.aciklama.toLowerCase().contains(aranan);
                return kategoriUygunMu && aramaUygunMu;
            }).toList();
        });
    }

    // ürünün favori durumunu tersine çevirip listeyi günceller
    void _favoriyiDegistir(Urun hedefUrun){
        setState((){
            final yeniUrun=hedefUrun.copyWith(favoriMi:!hedefUrun.favoriMi);
            final index =_tumUrunler.indexWhere((u)=>u.id==hedefUrun.id);
            if(index != -1){
                _tumUrunler[index]=yeniUrun;
            }
            _filtreyiUygula();
        });
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(
                title:const Text("Mini Mağaza",
                style:TextStyle(
                    fontWeight:FontWeight.bold
                )
                ),
                // başlığı AppBar içinde ortalar
                centerTitle:true,
                actions:[
                    Padding(
                        padding:const EdgeInsets.only(right:16.0),
                        child:Center(
                            // Badge ikon üzerine sayı rozeti ekler (favori sayısı)
                            child:Badge(
                                label:Text(
                                    '${_tumUrunler.where((u)=>u.favoriMi).length}',
                                    style:const TextStyle(
                                        fontWeight:FontWeight.bold
                                    ),
                                ),
                                child:const Icon(Icons.favorite, color:Colors.red),
                            ),
                        ),
                    ),
                ],
            ),
            body:Column(
                children:[
                    // arama kutusu alanı
                    Padding(
                        // sol, üst, sağ, alt için özel padding değerleri
                        padding:const EdgeInsets.fromLTRB(16,8,16,4),
                        child:TextField(
                            controller:_aramaController,
                            // kullanıcı her harf yazdığında filtrelemeyi tetikler
                            onChanged:(_)=>_filtreyiUygula(),
                            decoration:InputDecoration(
                                hintText:"Ürün veya marka ara...", //placeholder
                                prefixIcon:const Icon(Icons.search),
                                // yazı varsa çarpı butonu çıkar, yoksa gizlenir
                                suffixIcon:_aramaController.text.isNotEmpty ? IconButton(
                                    icon:const Icon(Icons.clear),
                                    onPressed:(){
                                        _aramaController.clear();
                                        _filtreyiUygula();
                                    },
                                ): null,
                                filled:true,
                                fillColor:Colors.grey.shade100,
                                border:OutlineInputBorder(
                                    borderRadius:BorderRadius.circular(12),
                                    borderSide:BorderSide.none,
                                ),
                                contentPadding:const EdgeInsets.symmetric(vertical:0),
                            ),
                        ),
                    ),
                    // yatay kaydırılabilir kategori filtre butonları
                    SingleChildScrollView(
                        scrollDirection:Axis.horizontal,
                        padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),
                        child:Row(
                            children:Kategori.values.map((kategori){
                                final seciliMi=_seciliKategori==kategori;
                                return Padding(
                                    padding:const EdgeInsets.symmetric(horizontal:4.0),
                                    // ChoiceChip tekli seçim yapılabilen kategori butonu
                                    child:ChoiceChip(
                                        avatar:Text(kategori.ikon),
                                        label:Text(kategori.baslik),
                                        selected:seciliMi,
                                        onSelected:(secildi){
                                            if(secildi){
                                                setState((){
                                                    _seciliKategori=kategori;
                                                    _filtreyiUygula();
                                                }); 
                                            }
                                        },
                                        ),
                                    );
                                }
                            ).toList(),
                        ),
                    ),
                    // kalan tüm dikey alanı doldurması için Expanded kullanıyoruz
                    Expanded(
                        child: _yukleniyorMu
                            ? const Center(child: CircularProgressIndicator())
                            : _filtrelenmisUrunler.isEmpty
                                ? Center(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Icon(
                                                Icons.search_off_rounded,
                                                size: 64,
                                                color: Colors.grey.shade400,
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                                'Aradığınız kriterlere uygun ürün bulunamadı.',
                                                style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                ),
                                            ),
                                        ],
                                    ),
                                )
                                // filtrelenmiş ürünleri dinamik liste olarak çiziyoruz
                                : ListView.builder(
                                    itemCount: _filtrelenmisUrunler.length,
                                    itemBuilder: (context, index) {
                                        final urun = _filtrelenmisUrunler[index];
                                        return UrunKarti(
                                            urun: urun,
                                            onFavoriTiklandi: () => _favoriyiDegistir(urun),
                                            onDetayTiklandi: () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                        content: Text('${urun.baslik} tıklandı'),
                                                        duration: const Duration(milliseconds: 600),
                                                    ),
                                                );
                                            },
                                        );
                                    },
                                ),
                    ),
                ],
            ),

        );        
    }
}


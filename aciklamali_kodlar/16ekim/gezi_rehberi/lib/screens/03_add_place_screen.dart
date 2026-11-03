import 'package:flutter/material.dart';

// StatefulWidget: form alanlarına girilen verilerle durumu değişebilen ekran
class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  // GlobalKey<FormState>: formu yönetmek ve doğrulama (validation) işlemlerini tetiklemek için kullanılan benzersiz anahtar
  final _formKey = GlobalKey<FormState>();
  // TextEditingController: metin kutularına yazılan değerleri okumak ve sıfırlamak için kullanılır
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();

  String _selectedCategory = 'Doğa';
  final List<String> _categories = ['Doğa', 'Müze', 'Tarihi Yapı', 'Sahil', 'Kültür & Sanat'];

  @override
  // dispose: sayfa kapandığında controller'ları hafızadan temizler (bellek sızıntısını önler)
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  // mekan kaydetme butonuna basılınca çalışan metot
  void _savePlace() {
    // validate(): formdaki tüm kutuların validator kurallarını denetler, hepsi geçerliyse true döner
    if (_formKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar: altta bilgilendirme mesajı (SnackBar) gösterir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} (${_cityController.text}) rotanıza başarıyla eklendi!'),
          backgroundColor: Colors.teal,
        ),
      );
      // form alanlarını ve controller'ları temizleyip başlangıç haline döndürür
      _formKey.currentState!.reset();
      _nameController.clear();
      _cityController.clear();
      _feeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: sayfanın temel yapısını kurar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Mekan Ekle'),
        // centerTitle: başlığı AppBar'ın ortasına hizalar
        centerTitle: true,
      ),
      // SingleChildScrollView: klavye açıldığında formun yukarı kaydırılabilmesini sağlar
      body: SingleChildScrollView(
        // EdgeInsets: sayfa kenarlarından 16 birim boşluk bırakır
        padding: const EdgeInsets.all(16.0),
        // Form: içerisindeki form elemanlarını tek çatı altında yönetip ortak doğrulamayı sağlar
        child: Form(
          key: _formKey,
          // Column: form elemanlarını dikeyde alt alta sıralar
          child: Column(
            // CrossAxisAlignment: yatayda form elemanlarını tüm genişliğe yayar
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextFormField: kullanıcıdan metin girişi almak ve denetlemek için kullanılan form alanı
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Mekan Adı',
                  hintText: 'Örn: Kaputaş Plajı',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                // validator: girilen değeri kontrol eder; geçersizse uyarı metni, sorun yoksa null döner
                validator: (val) => val == null || val.trim().isEmpty ? 'Mekan adı boş bırakılamaz' : null,
              ),
              // SizedBox: araya dikeyde sabit 16 birim boşluk bırakır
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Bulunduğu Şehir',
                  hintText: 'Örn: Antalya',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Şehir bilgisi zorunludur' : null,
              ),
              const SizedBox(height: 16),
              // DropdownButtonFormField: açılır seçim menüsü sunan form bileşeni
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori Seçin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                // map: kategori metin listesini DropdownMenuItem widget listesine dönüştürür
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                // kullanıcı yeni bir kategori seçtiğinde tetiklenir
                onChanged: (val) {
                  // setState: seçilen yeni kategoriyi duruma işleyip ekranı yeniler
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feeController,
                // keyboardType: sayısal klavye açılmasını sağlar
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tahmini Giriş / Masraf (₺)',
                  hintText: '0 yazabilirsiniz',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Masraf tutarı giriniz';
                  // double.tryParse: metni sayıya çevirmeyi dener; başarısız olursa null döner
                  if (double.tryParse(val) == null) return 'Lütfen geçerli bir sayı giriniz';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // ElevatedButton.icon: ikonlu kaydetme butonu
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Rotaya Kaydet', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: _savePlace,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


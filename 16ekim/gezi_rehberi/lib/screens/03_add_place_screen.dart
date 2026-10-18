import 'package:flutter/material.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();

  String _selectedCategory = 'Doğa';
  final List<String> _categories = ['Doğa', 'Müze', 'Tarihi Yapı', 'Sahil', 'Kültür & Sanat'];

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} (${_cityController.text}) rotanıza başarıyla eklendi!'),
          backgroundColor: Colors.teal,
        ),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _cityController.clear();
      _feeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Mekan Ekle'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Mekan Adı',
                  hintText: 'Örn: Kaputaş Plajı',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Mekan adı boş bırakılamaz' : null,
              ),
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
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori Seçin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tahmini Giriş / Masraf (₺)',
                  hintText: '0 yazabilirsiniz',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Masraf tutarı giriniz';
                  if (double.tryParse(val) == null) return 'Lütfen geçerli bir sayı giriniz';
                  return null;
                },
              ),
              const SizedBox(height: 24),
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
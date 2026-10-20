import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../controllers/car_controller.dart';
import '../models/car_model.dart';

/// Araç Ekleme ve Düzenleme Ekranı.
/// Araç sahiplerinin filolarına yeni araç eklemesini veya mevcut araç bilgilerini
/// (fiyat, açıklama, yakıt, vites vb.) güncellemesini sağlar.
class AddEditCarView extends StatefulWidget {
  const AddEditCarView({this.car, super.key});

  /// Düzenlenecek mevcut araç (null ise yeni araç ekleme modundadır).
  final Car? car;

  @override
  State<AddEditCarView> createState() => _AddEditCarViewState();
}

class _AddEditCarViewState extends State<AddEditCarView> {
  // Form alanlarının toplu doğrulanması için kullanılan anahtar.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Metin giriş alanlarının denetleyicileri.
  late final TextEditingController _brandCtrl;
  late final TextEditingController _modelCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _imageCtrl;

  // Klavyede "Sonraki" tuşuna basıldığında odak zincirini yöneten FocusNode'lar.
  // Odaklanmanın kesintisiz akmasını sağlar ve klavye kapanma kasmasını önler.
  final FocusNode _brandFocus = FocusNode();
  final FocusNode _modelFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _imageFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  // Açılır liste (dropdown) seçimleri.
  // Sayfa genelinde setState çağrısı yapmadan yerel olarak tutulur.
  late FuelType _selectedFuel;
  late TransmissionType _selectedTransmission;
  late CarCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    final Car? c = widget.car;
    _brandCtrl = TextEditingController(text: c?.brand ?? '');
    _modelCtrl = TextEditingController(text: c?.modelName ?? '');
    _yearCtrl = TextEditingController(text: c != null ? '${c.year}' : '2023');
    _priceCtrl =
        TextEditingController(text: c != null ? '${c.dailyPrice.toInt()}' : '');
    _descCtrl = TextEditingController(
      text: c?.description ??
          'Bakımları yetkili serviste yapılmış, temiz ve konforlu araç.',
    );
    _imageCtrl = TextEditingController(
      text: c?.imageUrl ??
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80',
    );

    _selectedFuel = c?.fuelType ?? FuelType.benzin;
    _selectedTransmission = c?.transmission ?? TransmissionType.otomatik;
    _selectedCategory = c?.category ?? CarCategory.sedan;
  }

  @override
  void dispose() {
    // Bellek sızıntılarını önlemek için tüm controller ve focus node'lar serbest bırakılır.
    _brandCtrl.dispose();
    _modelCtrl.dispose();
    _yearCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();

    _brandFocus.dispose();
    _modelFocus.dispose();
    _yearFocus.dispose();
    _priceFocus.dispose();
    _imageFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  /// Form alanlarını doğrular, yeni/güncellenmiş Car nesnesini oluşturur
  /// ve CarController üzerinden kaydeder.
  void _onSavePressed() {
    // Tüm alanlar geçerli değilse işlemi durdur.
    if (!_formKey.currentState!.validate()) return;

    final UserProfile? user = AuthController.instance.currentUser;
    final double price = double.tryParse(_priceCtrl.text.trim()) ?? 1500.0;
    final int year = int.tryParse(_yearCtrl.text.trim()) ?? 2023;

    final Car newOrUpdated = Car(
      id: widget.car?.id ?? 'car_${DateTime.now().millisecondsSinceEpoch}',
      brand: _brandCtrl.text.trim(),
      modelName: _modelCtrl.text.trim(),
      year: year,
      dailyPrice: price,
      fuelType: _selectedFuel,
      transmission: _selectedTransmission,
      category: _selectedCategory,
      seats: widget.car?.seats ?? 5,
      imageUrl: _imageCtrl.text.trim(),
      ownerId: widget.car?.ownerId ?? (user?.id ?? 'user_1'),
      ownerName: widget.car?.ownerName ?? (user?.name ?? 'Araç Sahibi'),
      rating: widget.car?.rating ?? 5.0,
      reviewCount: widget.car?.reviewCount ?? 0,
      isAvailable: widget.car?.isAvailable ?? true,
      description: _descCtrl.text.trim(),
    );

    if (widget.car == null) {
      CarController.instance.addCar(newOrUpdated);
    } else {
      CarController.instance.updateCar(newOrUpdated);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.car == null
              ? 'Araç ilanı başarıyla yayınlandı!'
              : 'Araç bilgileri güncellendi.',
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.car != null;
    return PopScope(
      canPop: true,
      child: GestureDetector(
        // Boş alana tıklandığında klavyeyi otomatik kapatır.
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          appBar: AppBar(
            title: Text(isEdit ? 'İlanı Düzenle' : 'Yeni Araç İlanı Ekle'),
            leading: BackButton(
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: _CarFormContent(
                  brandCtrl: _brandCtrl,
                  modelCtrl: _modelCtrl,
                  yearCtrl: _yearCtrl,
                  priceCtrl: _priceCtrl,
                  imageCtrl: _imageCtrl,
                  descCtrl: _descCtrl,
                  brandFocus: _brandFocus,
                  modelFocus: _modelFocus,
                  yearFocus: _yearFocus,
                  priceFocus: _priceFocus,
                  imageFocus: _imageFocus,
                  descFocus: _descFocus,
                  fuel: _selectedFuel,
                  transmission: _selectedTransmission,
                  category: _selectedCategory,
                  onFuelChanged: (FuelType? f) {
                    if (f != null) _selectedFuel = f;
                  },
                  onTransChanged: (TransmissionType? t) {
                    if (t != null) _selectedTransmission = t;
                  },
                  onCatChanged: (CarCategory? c) {
                    if (c != null) _selectedCategory = c;
                  },
                  isEdit: isEdit,
                  onSave: _onSavePressed,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Form alanlarını içeren yapılandırılmış alt widget (build metodu 40 satır kuralı).
class _CarFormContent extends StatelessWidget {
  const _CarFormContent({
    required this.brandCtrl,
    required this.modelCtrl,
    required this.yearCtrl,
    required this.priceCtrl,
    required this.imageCtrl,
    required this.descCtrl,
    required this.brandFocus,
    required this.modelFocus,
    required this.yearFocus,
    required this.priceFocus,
    required this.imageFocus,
    required this.descFocus,
    required this.fuel,
    required this.transmission,
    required this.category,
    required this.onFuelChanged,
    required this.onTransChanged,
    required this.onCatChanged,
    required this.isEdit,
    required this.onSave,
  });

  final TextEditingController brandCtrl;
  final TextEditingController modelCtrl;
  final TextEditingController yearCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController imageCtrl;
  final TextEditingController descCtrl;

  final FocusNode brandFocus;
  final FocusNode modelFocus;
  final FocusNode yearFocus;
  final FocusNode priceFocus;
  final FocusNode imageFocus;
  final FocusNode descFocus;

  final FuelType fuel;
  final TransmissionType transmission;
  final CarCategory category;
  final ValueChanged<FuelType?> onFuelChanged;
  final ValueChanged<TransmissionType?> onTransChanged;
  final ValueChanged<CarCategory?> onCatChanged;
  final bool isEdit;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _BrandModelRow(
          brandCtrl: brandCtrl,
          modelCtrl: modelCtrl,
          brandFocus: brandFocus,
          modelFocus: modelFocus,
          nextFocus: yearFocus,
        ),
        const SizedBox(height: 12),
        _YearPriceRow(
          yearCtrl: yearCtrl,
          priceCtrl: priceCtrl,
          yearFocus: yearFocus,
          priceFocus: priceFocus,
          nextFocus: imageFocus,
        ),
        const SizedBox(height: 12),
        _DropdownRow(
          fuel: fuel,
          transmission: transmission,
          category: category,
          onFuelChanged: onFuelChanged,
          onTransChanged: onTransChanged,
          onCatChanged: onCatChanged,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: imageCtrl,
          focusNode: imageFocus,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.url,
          onFieldSubmitted: (_) => descFocus.requestFocus(),
          decoration: const InputDecoration(labelText: 'Fotoğraf URL'),
          validator: (String? val) =>
              (val == null || val.trim().isEmpty) ? 'URL zorunludur' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: descCtrl,
          focusNode: descFocus,
          maxLines: 3,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(labelText: 'Açıklama'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSave,
          child: Text(isEdit ? 'Değişiklikleri Kaydet' : 'İlanı Yayınla'),
        ),
      ],
    );
  }
}

/// Marka ve Model giriş satırı.
class _BrandModelRow extends StatelessWidget {
  const _BrandModelRow({
    required this.brandCtrl,
    required this.modelCtrl,
    required this.brandFocus,
    required this.modelFocus,
    required this.nextFocus,
  });

  final TextEditingController brandCtrl;
  final TextEditingController modelCtrl;
  final FocusNode brandFocus;
  final FocusNode modelFocus;
  final FocusNode nextFocus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: brandCtrl,
            focusNode: brandFocus,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onFieldSubmitted: (_) => modelFocus.requestFocus(),
            decoration: const InputDecoration(labelText: 'Marka (örn. BMW)'),
            validator: (String? val) =>
                (val == null || val.trim().isEmpty) ? 'Marka zorunludur' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: modelCtrl,
            focusNode: modelFocus,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onFieldSubmitted: (_) => nextFocus.requestFocus(),
            decoration: const InputDecoration(labelText: 'Model (örn. 320i)'),
            validator: (String? val) =>
                (val == null || val.trim().isEmpty) ? 'Model zorunludur' : null,
          ),
        ),
      ],
    );
  }
}

/// Yıl ve Günlük Ücret giriş satırı.
class _YearPriceRow extends StatelessWidget {
  const _YearPriceRow({
    required this.yearCtrl,
    required this.priceCtrl,
    required this.yearFocus,
    required this.priceFocus,
    required this.nextFocus,
  });

  final TextEditingController yearCtrl;
  final TextEditingController priceCtrl;
  final FocusNode yearFocus;
  final FocusNode priceFocus;
  final FocusNode nextFocus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: yearCtrl,
            focusNode: yearFocus,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => priceFocus.requestFocus(),
            decoration: const InputDecoration(labelText: 'Yıl (örn. 2023)'),
            validator: (String? val) =>
                (val == null || val.trim().isEmpty) ? 'Yıl zorunludur' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: priceCtrl,
            focusNode: priceFocus,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => nextFocus.requestFocus(),
            decoration: const InputDecoration(labelText: 'Günlük Ücret (₺)'),
            validator: (String? val) =>
                (val == null || val.trim().isEmpty) ? 'Ücret zorunludur' : null,
          ),
        ),
      ],
    );
  }
}

/// Yakıt, Vites ve Kategori seçim açılır menüleri.
class _DropdownRow extends StatelessWidget {
  const _DropdownRow({
    required this.fuel,
    required this.transmission,
    required this.category,
    required this.onFuelChanged,
    required this.onTransChanged,
    required this.onCatChanged,
  });

  final FuelType fuel;
  final TransmissionType transmission;
  final CarCategory category;
  final ValueChanged<FuelType?> onFuelChanged;
  final ValueChanged<TransmissionType?> onTransChanged;
  final ValueChanged<CarCategory?> onCatChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButtonFormField<CarCategory>(
          initialValue: category == CarCategory.tum ? CarCategory.sedan : category,
          decoration: const InputDecoration(labelText: 'Araç Kategorisi'),
          items: CarCategory.values
              .where((CarCategory c) => c != CarCategory.tum)
              .map((CarCategory c) =>
                  DropdownMenuItem<CarCategory>(value: c, child: Text(c.label)))
              .toList(),
          onChanged: onCatChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField<FuelType>(
                initialValue: fuel,
                decoration: const InputDecoration(labelText: 'Yakıt'),
                items: FuelType.values
                    .map((FuelType f) =>
                        DropdownMenuItem<FuelType>(value: f, child: Text(f.label)))
                    .toList(),
                onChanged: onFuelChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<TransmissionType>(
                initialValue: transmission,
                decoration: const InputDecoration(labelText: 'Vites'),
                items: TransmissionType.values
                    .map((TransmissionType t) =>
                        DropdownMenuItem<TransmissionType>(
                            value: t, child: Text(t.label)))
                    .toList(),
                onChanged: onTransChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

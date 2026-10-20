import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/currency_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../../cars/models/car_model.dart';
import '../controllers/reservation_controller.dart';
import '../models/reservation_model.dart';

/// Kiralama ve Rezervasyon Oluşturma Ekranı.
/// Seçilen araç için tarih aralığı, ehliyet doğrulaması ve toplam tutar hesaplar.
class CreateReservationView extends StatefulWidget {
  const CreateReservationView({required this.car, super.key});

  /// Kiralanacak araç modeli.
  final Car car;

  @override
  State<CreateReservationView> createState() => _CreateReservationViewState();
}

class _CreateReservationViewState extends State<CreateReservationView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Seçilen tarih aralığını yöneten reaktif bildirimci
  late final ValueNotifier<DateTimeRange> _dateRangeNotifier;

  // Ehliyet bilgileri için metin kontrolcüleri
  late final TextEditingController _licenseClassCtrl;
  late final TextEditingController _licenseYearCtrl;

  // Klavye odaklanma yönetimi FocusNode'ları
  late final FocusNode _classFocus;
  late final FocusNode _yearFocus;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();

    // Varsayılan kiralama aralığı: Yarından itibaren 3 gün
    _dateRangeNotifier = ValueNotifier<DateTimeRange>(
      DateTimeRange(
        start: now.add(const Duration(days: 1)),
        end: now.add(const Duration(days: 4)),
      ),
    );

    // Mevcut oturum açmış kullanıcının kayıtlı ehliyet bilgileri doldurulur
    final UserProfile? user = AuthController.instance.currentUser;
    _licenseClassCtrl = TextEditingController(text: user?.licenseClass ?? 'B');
    _licenseYearCtrl =
        TextEditingController(text: '${user?.licenseYear ?? 2020}');

    _classFocus = FocusNode();
    _yearFocus = FocusNode();
  }

  @override
  void dispose() {
    // Bellek temizliği
    _dateRangeNotifier.dispose();
    _licenseClassCtrl.dispose();
    _licenseYearCtrl.dispose();
    _classFocus.dispose();
    _yearFocus.dispose();
    super.dispose();
  }

  /// Tarih aralığı seçici diyalogunu açar ve seçilen günleri günceller.
  Future<void> _pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _dateRangeNotifier.value,
      helpText: 'Kiralama Tarih Aralığı Seçiniz',
      saveText: 'Seç',
    );
    if (picked != null) {
      _dateRangeNotifier.value = picked;
    }
  }

  /// Form alanlarını, ehliyet uygunluğunu ve tarih çakışmasını denetler.
  void _submitReservation() {
    FocusScope.of(context).unfocus(); // Klavyeyi kapat

    if (!_formKey.currentState!.validate()) return;

    final int licenseYear = int.tryParse(_licenseYearCtrl.text.trim()) ?? 2020;
    final String licenseClass = _licenseClassCtrl.text.trim().toUpperCase();

    // 0. Kendi aracını kiralama engeli
    final UserProfile? user = AuthController.instance.currentUser;
    if (user != null &&
        (widget.car.ownerId == user.id ||
            (user.role.isOwner &&
                (widget.car.ownerId == 'user_1' || widget.car.ownerId == user.id)))) {
      _showWarningDialog(
        'Kendi Aracınız',
        'Kendi aracınız için rezervasyon oluşturamazsınız. Araç sahibi olarak ilanınızı düzenleyebilirsiniz.',
      );
      return;
    }

    // 1. Ehliyet sınıfı ve alış yılı tecrübesi kontrolü
    final String? licenseError =
        ReservationController.instance.validateDriverLicense(
      userLicenseClass: licenseClass,
      userLicenseYear: licenseYear,
      car: widget.car,
    );

    if (licenseError != null) {
      _showWarningDialog('Ehliyet Uygun Değil', licenseError);
      return;
    }

    final DateTimeRange range = _dateRangeNotifier.value;

    // 2. Aynı tarih aralığında onaylı rezervasyon çakışması kontrolü
    if (ReservationController.instance.hasDateConflict(
      carId: widget.car.id,
      start: range.start,
      end: range.end,
    )) {
      _showWarningDialog(
        'Tarih Çakışması',
        'Seçtiğiniz tarih aralığında bu araç için onaylanmış bir rezervasyon bulunmaktadır. Lütfen farklı tarihler seçiniz.',
      );
      return;
    }

    // 3. Gün ve toplam tutar hesaplaması
    final (int days, double totalPrice) =
        ReservationController.instance.calculateRentalCost(
      start: range.start,
      end: range.end,
      dailyPrice: widget.car.dailyPrice,
    );

    // 4. Kullanıcı onay diyalogu
    _showConfirmationDialog(days, totalPrice, licenseClass, licenseYear);
  }

  void _showWarningDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Anladım'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    int days,
    double totalPrice,
    String licenseClass,
    int licenseYear,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Rezervasyon Onayı'),
        content: Text(
          '${widget.car.fullName} aracı için $days günlük rezervasyon talebiniz (${totalPrice.toCurrencyString}) araç sahibine iletilecektir. Onaylıyor musunuz?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _finalizeReservation(days, totalPrice, licenseClass, licenseYear);
            },
            child: const Text('Talebi Gönder'),
          ),
        ],
      ),
    );
  }

  /// Rezervasyon kaydını oluşturur ve listeye ekler.
  void _finalizeReservation(
    int days,
    double totalPrice,
    String licenseClass,
    int licenseYear,
  ) {
    final UserProfile? user = AuthController.instance.currentUser;
    final DateTimeRange range = _dateRangeNotifier.value;

    final Reservation newRes = Reservation(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      carId: widget.car.id,
      carBrand: widget.car.brand,
      carModel: widget.car.modelName,
      carImageUrl: widget.car.imageUrl,
      dailyPrice: widget.car.dailyPrice,
      renterId: user?.id ?? 'guest_renter',
      renterName: user?.name ?? 'Misafir Kullanıcı',
      renterPhone: user?.phone ?? '+90 555 000 0000',
      ownerId: widget.car.ownerId,
      ownerName: widget.car.ownerName,
      startDate: range.start,
      endDate: range.end,
      totalDays: days,
      totalPrice: totalPrice,
      licenseClass: licenseClass,
      licenseYear: licenseYear,
      createdAt: DateTime.now(),
    );

    ReservationController.instance.createReservation(newRes);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Rezervasyon talebiniz oluşturuldu! Toplam: ${totalPrice.toCurrencyString}',
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Araç Kirala'),
            leading: BackButton(
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _CarMiniHeader(car: widget.car),
                    const SizedBox(height: 16),
                    _DateSelectionCard(
                      dateRangeNotifier: _dateRangeNotifier,
                      onPickTap: _pickDateRange,
                    ),
                    const SizedBox(height: 16),
                    _LicenseFormCard(
                      classCtrl: _licenseClassCtrl,
                      yearCtrl: _licenseYearCtrl,
                      classFocus: _classFocus,
                      yearFocus: _yearFocus,
                      car: widget.car,
                      onSubmitted: _submitReservation,
                    ),
                    const SizedBox(height: 16),
                    _CostSummaryCard(
                      car: widget.car,
                      dateRangeNotifier: _dateRangeNotifier,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitReservation,
                      child: const Text('Rezervasyon Talebi Oluştur'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Seçili aracın minyatür başlık kartı.
class _CarMiniHeader extends StatelessWidget {
  const _CarMiniHeader({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                car.imageUrl,
                width: 70,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    car.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${car.dailyPrice.toCurrencyString} / gün',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarih aralığı kartı.
class _DateSelectionCard extends StatelessWidget {
  const _DateSelectionCard({
    required this.dateRangeNotifier,
    required this.onPickTap,
  });

  final ValueNotifier<DateTimeRange> dateRangeNotifier;
  final VoidCallback onPickTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Kiralama Tarihleri',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<DateTimeRange>(
              valueListenable: dateRangeNotifier,
              builder: (BuildContext context, DateTimeRange range, _) {
                final int days = range.start.daysBetween(range.end);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${range.start.toFormattedString} - ${range.end.toFormattedString}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '$days Günlük Kiralama',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: onPickTap,
                      icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                      label: const Text('Değiştir'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Ehliyet sınıfı ve tecrübe yılı formu kartı.
class _LicenseFormCard extends StatelessWidget {
  const _LicenseFormCard({
    required this.classCtrl,
    required this.yearCtrl,
    required this.classFocus,
    required this.yearFocus,
    required this.car,
    required this.onSubmitted,
  });

  final TextEditingController classCtrl;
  final TextEditingController yearCtrl;
  final FocusNode classFocus;
  final FocusNode yearFocus;
  final Car car;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Ehliyet Doğrulaması',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Gereken: ${car.licenseClassRequired} (${car.minLicenseYears}+ Yıl)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryYellow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: classCtrl,
                    focusNode: classFocus,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.characters,
                    onFieldSubmitted: (_) => yearFocus.requestFocus(),
                    decoration: const InputDecoration(labelText: 'Ehliyet Sınıfı'),
                    validator: (String? val) =>
                        (val == null || val.trim().isEmpty) ? 'Zorunlu' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: yearCtrl,
                    focusNode: yearFocus,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => onSubmitted(),
                    decoration: const InputDecoration(labelText: 'Alış Yılı'),
                    validator: (String? val) {
                      if (val == null || val.trim().isEmpty) return 'Zorunlu';
                      final int? y = int.tryParse(val);
                      if (y == null || y < 1960 || y > DateTime.now().year) {
                        return 'Geçersiz Yıl';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Canlı gün ve toplam fiyat özet kartı.
class _CostSummaryCard extends StatelessWidget {
  const _CostSummaryCard({
    required this.car,
    required this.dateRangeNotifier,
  });

  final Car car;
  final ValueNotifier<DateTimeRange> dateRangeNotifier;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<DateTimeRange>(
          valueListenable: dateRangeNotifier,
          builder: (BuildContext context, DateTimeRange range, _) {
            final int days = range.start.daysBetween(range.end);
            final double total = days * car.dailyPrice;

            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Günlük Ücret: ${car.dailyPrice.toCurrencyString}'),
                    Text('$days Gün'),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Toplam Tutar:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      total.toCurrencyString,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

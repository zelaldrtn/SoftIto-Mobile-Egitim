import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/currency_extensions.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../controllers/car_controller.dart';
import '../models/car_model.dart';
import '../widgets/car_spec_chip.dart';
import 'add_edit_car_view.dart';
import 'car_detail_view.dart';

/// Araç Sahibi rolündeki kullanıcıların kendi araç ilanlarını listelediği,
/// yeni araç eklediği, düzenlediği veya kaldırdığı yönetim ekranı.
class MyCarsView extends StatelessWidget {
  const MyCarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araçlarım'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AddEditCarView(),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Araç Ekle'),
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: _MyCarsContent(),
      ),
    );
  }
}

/// Giriş yapan araç sahibinin araçlarını filtreleyip listeleyen reaktif içerik.
class _MyCarsContent extends StatelessWidget {
  const _MyCarsContent();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        final String currentUserId = user?.id ?? 'user_1';

        // CarController'daki araç listesini dinleyerek anlık CRUD güncellemelerini yansıtır.
        return ValueListenableBuilder<List<Car>>(
          valueListenable: CarController.instance.carsListenable,
          builder: (BuildContext context, List<Car> allCars, _) {
            // Yalnızca aktif oturumdaki araç sahibine ait ilanları filtrele.
            final List<Car> myCars = allCars
                .where((Car c) =>
                    c.ownerId == currentUserId ||
                    (currentUserId == 'user_1' && c.ownerId == 'user_1'))
                .toList();

            if (myCars.isEmpty) {
              return const _EmptyMyCarsState();
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: myCars.length,
              itemBuilder: (BuildContext context, int index) {
                return _OwnerCarCard(car: myCars[index]);
              },
            );
          },
        );
      },
    );
  }
}

/// Araç sahibine özel tasarlanmış, silme ve düzenleme aksiyonlarını içeren araç kartı.
class _OwnerCarCard extends StatelessWidget {
  const _OwnerCarCard({required this.car});

  final Car car;

  /// İlanı kaldırmadan önce kullanıcıdan onay isteyen güvenlik diyaloğu.
  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('İlanı Kaldır'),
        content: Text(
          '${car.fullName} aracına ait ilanı sistemden silmek istediğinize emin misiniz?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              CarController.instance.deleteCar(car.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${car.fullName} ilanı kaldırıldı.'),
                  backgroundColor: AppColors.warningOrange,
                ),
              );
            },
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _CardImageWithStatus(car: car),
          _CardBody(car: car),
          const Divider(height: 1),
          _CardActions(
            car: car,
            onDelete: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }
}

/// Araç fotoğrafı ve üzerinde 'Yayında' durum rozeti.
class _CardImageWithStatus extends StatelessWidget {
  const _CardImageWithStatus({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => CarDetailView(car: car),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              car.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: Icon(Icons.directions_car, size: 48),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Yayında',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Araç adı, günlük ücret ve teknik özellik çipleri (Yıl, Yakıt, Vites).
class _CardBody extends StatelessWidget {
  const _CardBody({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => CarDetailView(car: car),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    car.fullName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${car.dailyPrice.toCurrencyString} / gün',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: <Widget>[
                CarSpecChip(
                  icon: Icons.calendar_month_rounded,
                  label: '${car.year}',
                ),
                CarSpecChip(
                  icon: Icons.local_gas_station_rounded,
                  label: car.fuelType.label,
                ),
                CarSpecChip(
                  icon: Icons.settings_suggest_rounded,
                  label: car.transmission.label,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// İlanı Düzenle ve İlanı Kaldır butonları (Sol-Sağ dengeli yerleşim).
class _CardActions extends StatelessWidget {
  const _CardActions({required this.car, required this.onDelete});

  final Car car;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.errorRed),
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: const Text('İlanı Kaldır'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => AddEditCarView(car: car),
                ),
              );
            },
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: const Text('Düzenle'),
          ),
        ],
      ),
    );
  }
}

/// Henüz araç ilanı eklenmemişse gösterilen boş durum mesajı ve ekleme butonu.
class _EmptyMyCarsState extends StatelessWidget {
  const _EmptyMyCarsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.no_crash_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Henüz kayıtlı bir araç ilanınız yok.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aracınızı sisteme ekleyerek hemen kiraya vermeye başlayabilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AddEditCarView(),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('İlk Aracını Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}

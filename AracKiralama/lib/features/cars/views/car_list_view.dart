import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../controllers/car_controller.dart';
import '../models/car_model.dart';
import '../widgets/car_card.dart';
import '../widgets/car_category_selector.dart';
import '../widgets/car_filter_sheet.dart';
import '../widgets/car_search_bar.dart';
import 'add_edit_car_view.dart';
import 'car_detail_view.dart';

/// Ana Sayfa ve Araç Listeleme Ekranı.
/// Arama çubuğu, kategori çipleri, fiyat filtresi ve araç kartlarını bir araya getirir.
class CarListView extends StatelessWidget {
  const CarListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _CarListAppBar(),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              SizedBox(height: 8),
              _TopControls(),
              SizedBox(height: 12),
              _CategorySection(),
              SizedBox(height: 12),
              Expanded(child: _CarListContent()),
            ],
          ),
        ),
      ),
      floatingActionButton: const _AddCarFab(),
    );
  }
}

/// Logo, başlık, tema değiştirme ve kullanıcı rol rozetini içeren üst çubuk.
class _CarListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CarListAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Araç Kiralama',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      actions: <Widget>[
        const _ThemeSwitchButton(),
        const _UserRoleBadge(),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// AppBar üzerindeki hızlı tema değiştirme butonu (Aydınlık / Karanlık).
class _ThemeSwitchButton extends StatelessWidget {
  const _ThemeSwitchButton();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (BuildContext context, ThemeMode mode, _) {
        final bool isDark = mode == ThemeMode.dark;
        return IconButton(
          tooltip: isDark ? 'Aydınlık Moda Geç' : 'Karanlık Moda Geç',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? AppColors.primaryYellow : AppColors.deepNavy,
          ),
          onPressed: ThemeController.instance.toggleTheme,
        );
      },
    );
  }
}

/// Aktif kullanıcının rolünü (Araç Sahibi / Kiralayan) gösteren rozet.
class _UserRoleBadge extends StatelessWidget {
  const _UserRoleBadge();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        final bool isOwner = user?.role.isOwner ?? false;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Chip(
            avatar: Icon(
              isOwner ? Icons.vpn_key_rounded : Icons.person_rounded,
              size: 14,
            ),
            label: Text(
              isOwner ? 'Araç Sahibi' : 'Kiralayan',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
        );
      },
    );
  }
}

/// Arama çubuğu ve filtreleme modal açma butonu.
class _TopControls extends StatelessWidget {
  const _TopControls();

  @override
  Widget build(BuildContext context) {
    return CarSearchBar(
      onChanged: (String val) {
        CarController.instance.searchQueryNotifier.value = val;
      },
      onFilterTap: () => CarFilterSheet.show(context),
    );
  }
}

/// Kategori yatay kaydırma çipleri (Tümü, Sedan, SUV, Spor vb.).
class _CategorySection extends StatelessWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context) {
    return CarCategorySelector(
      selectedCategoryNotifier: CarController.instance.selectedCategoryNotifier,
    );
  }
}

/// Filtrelenmiş araç listesini reaktif olarak dinleyen ve listeleyen gövde.
class _CarListContent extends StatelessWidget {
  const _CarListContent();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Car>>(
      valueListenable: CarController.instance.filteredCarsNotifier,
      builder: (BuildContext context, List<Car> cars, _) {
        if (cars.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Kriterlerinize uygun araç bulunamadı.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: cars.length,
          itemBuilder: (BuildContext context, int index) {
            final Car car = cars[index];
            return CarCard(
              car: car,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => CarDetailView(car: car),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Yalnızca Araç Sahibi rolündeyken gösterilen yüzen 'İlan Ekle' aksiyon butonu.
class _AddCarFab extends StatelessWidget {
  const _AddCarFab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        if (user?.role != UserRole.aracSahibi) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const AddEditCarView(),
              ),
            );
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('İlan Ekle'),
        );
      },
    );
  }
}

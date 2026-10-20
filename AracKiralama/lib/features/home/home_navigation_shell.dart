import 'package:flutter/material.dart';
import '../auth/controllers/auth_controller.dart';
import '../auth/models/user_model.dart';
import '../cars/views/car_list_view.dart';
import '../cars/views/my_cars_view.dart';
import '../profile/views/profile_view.dart';
import '../reservations/views/incoming_requests_view.dart';
import '../reservations/views/renter_reservations_view.dart';

/// Kullanıcı rolüne (Araç Sahibi veya Kiralayan) göre dinamik olarak alt menüyü
/// ve sayfaları yapılandıran ana gezinme kabuğu (Shell).
/// `IndexedStack` kullanarak sekmeler arası geçişlerde ekran durumlarını korur.
class HomeNavigationShell extends StatefulWidget {
  const HomeNavigationShell({super.key});

  @override
  State<HomeNavigationShell> createState() => _HomeNavigationShellState();
}

class _HomeNavigationShellState extends State<HomeNavigationShell> {
  // Seçili sekmenin indeksini tutan reaktif bildirimci.
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Aktif kullanıcının rolünü dinler; rol değiştiğinde menü ve sayfaları anında günceller.
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        final bool isOwner = user?.role == UserRole.aracSahibi;
        final List<Widget> pages = isOwner ? _ownerPages : _renterPages;
        final List<NavigationDestination> destinations =
            isOwner ? _ownerDestinations : _renterDestinations;

        return _NavigationScaffold(
          currentIndexNotifier: _currentIndexNotifier,
          pages: pages,
          destinations: destinations,
        );
      },
    );
  }

  /// Araç sahibi rolüne ait ekranlar: İlanlarım, Gelen Talepler ve Profil.
  static const List<Widget> _ownerPages = <Widget>[
    MyCarsView(),
    IncomingRequestsView(),
    ProfileView(),
  ];

  /// Kiralayan rolüne ait ekranlar: Araç Kataloğu, Rezervasyonlarım ve Profil.
  static const List<Widget> _renterPages = <Widget>[
    CarListView(),
    RenterReservationsView(),
    ProfileView(),
  ];

  /// Araç sahibi için Material Design 3 gezinme hedefleri.
  static const List<NavigationDestination> _ownerDestinations =
      <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.garage_outlined),
      selectedIcon: Icon(Icons.garage_rounded),
      label: 'Araçlarım',
    ),
    NavigationDestination(
      icon: Icon(Icons.inbox_outlined),
      selectedIcon: Icon(Icons.inbox_rounded),
      label: 'Gelen Talepler',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profil',
    ),
  ];

  /// Kiralayan için Material Design 3 gezinme hedefleri.
  static const List<NavigationDestination> _renterDestinations =
      <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.directions_car_outlined),
      selectedIcon: Icon(Icons.directions_car_filled_rounded),
      label: 'Araçlar',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month_rounded),
      label: 'Rezervasyonlarım',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profil',
    ),
  ];
}

/// Sayfa yığını ve alt gezinme çubuğunu oluşturan yardımcı widget (build $\le$ 40 satır).
class _NavigationScaffold extends StatelessWidget {
  const _NavigationScaffold({
    required this.currentIndexNotifier,
    required this.pages,
    required this.destinations,
  });

  final ValueNotifier<int> currentIndexNotifier;
  final List<Widget> pages;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndexNotifier,
      builder: (BuildContext context, int index, _) {
        // Rol değişiminde indeks taşmasını önlemek için güvenli indeks hesabı.
        final int safeIndex = index < pages.length ? index : 0;
        return Scaffold(
          body: IndexedStack(
            index: safeIndex,
            children: pages,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: safeIndex,
            onDestinationSelected: (int newIndex) {
              currentIndexNotifier.value = newIndex;
            },
            destinations: destinations,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'today_screen.dart';
import 'calendar_screen.dart';
import 'room_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';

// alt menü ile sekmeler arası geçişi yöneten ana ekran
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // o an aktif olan alt menü sekmesinin indeksi
  int _currentIndex = 0;

  // alt menüdeki sekmelere karşılık gelen sayfalar listesi
  final List<Widget> _screens = const [
    TodayScreen(),
    CalendarScreen(),
    RoomScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold temel ekran yapısını kurar
    return Scaffold(
      // IndexedStack sayfaları yok etmeden arka planda durumlarını koruyarak üst üste tutar, sadece aktif olanı gösterir
      body: IndexedStack(
        // gösterilecek sayfanın indeksi
        index: _currentIndex,
        // yığında tutulacak sayfalar
        children: _screens,
      ),
      // kendi hazırladığımız alt gezinme çubuğu
      bottomNavigationBar: DoItBottomNavBar(
        currentIndex: _currentIndex,
        // kullanıcı yeni bir sekmeye bastığında indeksi güncelleyip ekranı yeniliyoruz
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


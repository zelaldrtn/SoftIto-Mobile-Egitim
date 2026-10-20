import 'package:flutter/material.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../controllers/reservation_controller.dart';
import '../models/reservation_model.dart';
import '../widgets/reservation_card.dart';

/// Araç Kiralayan için 'Rezervasyonlarım' Ekranı.
/// Kullanıcının oluşturduğu tüm kiralama taleplerini, onay/red durumlarını ve
/// rezervasyon detaylarını listeler.
class RenterReservationsView extends StatelessWidget {
  const RenterReservationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezervasyonlarım'),
      ),
      body: const SafeArea(
        child: _RenterReservationsContent(),
      ),
    );
  }
}

/// Giriş yapan kiralayanın rezervasyonlarını listeleyen reaktif widget.
class _RenterReservationsContent extends StatelessWidget {
  const _RenterReservationsContent();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        final String userId = user?.id ?? 'user_1';

        // ReservationController üzerindeki değişiklikleri reaktif olarak dinler.
        return ValueListenableBuilder<List<Reservation>>(
          valueListenable:
              ReservationController.instance.reservationsListenable,
          builder: (BuildContext context, List<Reservation> all, _) {
            // Yalnızca aktif oturumdaki kiralayanın kendi taleplerini filtrele.
            final List<Reservation> myRentals = all
                .where((Reservation r) =>
                    r.renterId == userId ||
                    (userId == 'user_1' && r.renterId == 'user_1'))
                .toList();

            if (myRentals.isEmpty) {
              return const _EmptyRenterReservations();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myRentals.length,
              itemBuilder: (BuildContext context, int index) {
                return ReservationCard(
                  reservation: myRentals[index],
                  isOwnerView: false,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Kullanıcının henüz herhangi bir araç kiralamadığı durumda gösterilen yönlendirici ekran.
class _EmptyRenterReservations extends StatelessWidget {
  const _EmptyRenterReservations();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.calendar_month_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Henüz bir rezervasyonunuz yok',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Araçlar sekmesinden beğendiğiniz bir aracı seçip hemen rezervasyon talebi oluşturabilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../controllers/reservation_controller.dart';
import '../models/reservation_model.dart';
import '../widgets/reservation_card.dart';

/// Araç Sahibi için 'Gelen Rezervasyon Talepleri' Ekranı.
/// Kiracılardan gelen onay bekleyen veya geçmiş kiralama taleplerini listeler,
/// araç sahibinin tek dokunuşla onaylamasını veya reddetmesini sağlar.
class IncomingRequestsView extends StatelessWidget {
  const IncomingRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelen Talepler'),
      ),
      body: const SafeArea(
        child: _IncomingRequestsList(),
      ),
    );
  }
}

/// Giriş yapan araç sahibine ait gelen talepleri ReservationController'dan dinleyerek filtreleyen liste.
class _IncomingRequestsList extends StatelessWidget {
  const _IncomingRequestsList();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: AuthController.instance.currentUserListenable,
      builder: (BuildContext context, UserProfile? user, _) {
        final String userId = user?.id ?? 'user_1';

        return ValueListenableBuilder<List<Reservation>>(
          valueListenable:
              ReservationController.instance.reservationsListenable,
          builder: (BuildContext context, List<Reservation> all, _) {
            // Araç sahibinin ID'sine gelen talepleri filtrele
            final List<Reservation> ownerRequests = all
                .where((Reservation r) =>
                    r.ownerId == userId ||
                    (userId == 'user_1' && r.ownerId == 'user_1'))
                .toList();

            if (ownerRequests.isEmpty) {
              return const _EmptyIncomingRequests();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ownerRequests.length,
              itemBuilder: (BuildContext context, int index) {
                return ReservationCard(
                  reservation: ownerRequests[index],
                  isOwnerView: true,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Henüz gelen bir talep olmadığında gösterilen boş durum widget'ı.
class _EmptyIncomingRequests extends StatelessWidget {
  const _EmptyIncomingRequests();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.inbox_rounded, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Gelen Rezervasyon Talebi Yok',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'İlanlarınız kiralandığında gelen kiralama talepleri burada listelenecektir.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

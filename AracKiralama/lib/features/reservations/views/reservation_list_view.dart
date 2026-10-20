import 'package:flutter/material.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import '../controllers/reservation_controller.dart';
import '../models/reservation_model.dart';
import '../widgets/reservation_card.dart';

/// Rezervasyonlarım Ekranı.
class ReservationListView extends StatelessWidget {
  const ReservationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rezervasyonlar'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Kiraladıklarım'),
              Tab(text: 'Gelen Talepler'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            _RenterReservationsTab(),
            _OwnerReservationsTab(),
          ],
        ),
      ),
    );
  }
}

class _RenterReservationsTab extends StatelessWidget {
  const _RenterReservationsTab();

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
            final List<Reservation> list = all
                .where((Reservation r) => r.renterId == userId || r.renterId == 'user_1')
                .toList();

            if (list.isEmpty) {
              return const _EmptyReservationState(
                message: 'Henüz bir araç kiralama rezervasyonunuz yok.',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ReservationCard(
                  reservation: list[index],
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

class _OwnerReservationsTab extends StatelessWidget {
  const _OwnerReservationsTab();

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
            final List<Reservation> list = all
                .where((Reservation r) => r.ownerId == userId || r.ownerId == 'user_1')
                .toList();

            if (list.isEmpty) {
              return const _EmptyReservationState(
                message: 'Henüz araçlarınıza gelen bir rezervasyon talebi yok.',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return ReservationCard(
                  reservation: list[index],
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

class _EmptyReservationState extends StatelessWidget {
  const _EmptyReservationState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.event_busy_rounded, size: 54, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

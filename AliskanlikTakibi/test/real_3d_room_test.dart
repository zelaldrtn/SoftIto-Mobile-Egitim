import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ditredi/ditredi.dart';
import 'package:aliskanlik_takibi/services/storage_service.dart';
import 'package:aliskanlik_takibi/services/habit_provider.dart';
import 'package:aliskanlik_takibi/screens/room_screen.dart';
import 'package:aliskanlik_takibi/widgets/real_3d_room_view.dart';
import 'package:aliskanlik_takibi/widgets/isometric_room_view.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await initializeDateFormatting('tr_TR', null);
  });

  testWidgets('Real3DRoomView renders 3D room, camera controls and reacts to interaction', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Real3DRoomView(
            isDark: false,
            isNightMode: false,
          ),
        ),
      ),
    );

    // Verify 3D canvas and draggable wrapper
    expect(find.byType(DiTreDi), findsOneWidget);
    expect(find.byType(DiTreDiDraggable), findsOneWidget);

    // Verify Camera HUD buttons by icons
    expect(find.byIcon(Icons.restart_alt_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_in_ar_rounded), findsOneWidget);
    expect(find.byIcon(Icons.layers_outlined), findsOneWidget);
    expect(find.byIcon(Icons.crop_portrait_rounded), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);

    // Tap camera presets
    await tester.tap(find.byIcon(Icons.layers_outlined));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.crop_portrait_rounded));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.restart_alt_rounded));
    await tester.pump();

    // Tap zoom buttons
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();

    // Verify badge
    expect(find.text('3D Temel Render: Zemin, Duvarlar & Çalışma Masası'), findsOneWidget);

    // Verify gesture hint badge and close it
    expect(find.byIcon(Icons.threed_rotation_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(find.byIcon(Icons.close_rounded), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('RoomScreen allows switching seamlessly between 3D Gerçek Oda and 2D İzometrik', (WidgetTester tester) async {
    final storageService = await StorageService.init();
    final provider = HabitProvider(storageService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const MaterialApp(
          home: RoomScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // By default 3D Gerçek Oda is active
    expect(find.text('3D Gerçek Oda'), findsOneWidget);
    expect(find.text('2D İzometrik'), findsOneWidget);
    expect(find.byType(Real3DRoomView), findsOneWidget);
    expect(find.byType(IsometricRoomView), findsNothing);

    // Switch to 2D İzometrik
    await tester.tap(find.text('2D İzometrik'));
    await tester.pumpAndSettle();

    expect(find.byType(IsometricRoomView), findsOneWidget);
    expect(find.byType(Real3DRoomView), findsNothing);

    // Switch back to 3D Gerçek Oda
    await tester.tap(find.text('3D Gerçek Oda'));
    await tester.pumpAndSettle();

    expect(find.byType(Real3DRoomView), findsOneWidget);
    expect(find.byType(IsometricRoomView), findsNothing);

    expect(tester.takeException(), isNull);
  });
}

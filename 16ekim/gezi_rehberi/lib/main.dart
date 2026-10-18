import 'package:flutter/material.dart';
import 'screens/01_discover_screen.dart';
import 'screens/02_places_list_screen.dart';
import 'screens/03_add_place_screen.dart';

void main() {
  runApp(const GeziRehberiApp());
}

class GeziRehberiApp extends StatelessWidget {
  const GeziRehberiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gezi Rehberi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gezi Rehberi & Rotalar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMenuButton(
                context,
                title: '1. Keşfet Paneli (Layout & Kartlar)',
                icon: Icons.explore_outlined,
                target: const DiscoverScreen(),
              ),
              const SizedBox(height: 18),
              _buildMenuButton(
                context,
                title: '2. Gezilecek Mekanlar (List & Model)',
                icon: Icons.map_outlined,
                target: const PlacesListScreen(),
              ),
              const SizedBox(height: 18),
              _buildMenuButton(
                context,
                title: '3. Yeni Mekan Ekle (Form & Validation)',
                icon: Icons.add_location_alt_outlined,
                target: const AddPlaceScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required Widget target}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Text(title, style: const TextStyle(fontSize: 15)),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => target));
      },
    );
  }
}
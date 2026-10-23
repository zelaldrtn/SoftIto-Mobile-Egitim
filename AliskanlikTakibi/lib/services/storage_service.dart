import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../models/room_item.dart';
import '../models/badge_item.dart';
import '../models/user_profile.dart';

class StorageService {
  static const String _keyHabits = 'doit_habits_v1';
  static const String _keyLogs = 'doit_logs_v1';
  static const String _keyRoomItems = 'doit_room_items_v1';
  static const String _keyPoints = 'doit_points_balance_v1';
  static const String _keyBadges = 'doit_badges_v1';
  static const String _keyProfile = 'doit_profile_v1';
  static const String _keyInitialized = 'doit_initialized_v1';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = StorageService(prefs);
    if (!prefs.containsKey(_keyInitialized)) {
      await service._seedInitialData();
      await prefs.setBool(_keyInitialized, true);
    }
    return service;
  }

  // Habits
  List<Habit> loadHabits() {
    final jsonStr = _prefs.getString(_keyHabits);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => Habit.fromMap(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final jsonStr = jsonEncode(habits.map((e) => e.toMap()).toList());
    await _prefs.setString(_keyHabits, jsonStr);
  }

  // Logs
  List<HabitLog> loadLogs() {
    final jsonStr = _prefs.getString(_keyLogs);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => HabitLog.fromMap(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLogs(List<HabitLog> logs) async {
    final jsonStr = jsonEncode(logs.map((e) => e.toMap()).toList());
    await _prefs.setString(_keyLogs, jsonStr);
  }

  // Room Items
  List<RoomItem> loadRoomItems() {
    final jsonStr = _prefs.getString(_keyRoomItems);
    if (jsonStr == null || jsonStr.isEmpty) return defaultRoomItems();
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => RoomItem.fromMap(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return defaultRoomItems();
    }
  }

  Future<void> saveRoomItems(List<RoomItem> items) async {
    final jsonStr = jsonEncode(items.map((e) => e.toMap()).toList());
    await _prefs.setString(_keyRoomItems, jsonStr);
  }

  // Points
  int loadPoints() {
    return _prefs.getInt(_keyPoints) ?? 0;
  }

  Future<void> savePoints(int points) async {
    await _prefs.setInt(_keyPoints, points);
  }

  // Badges
  List<BadgeItem> loadBadges() {
    final jsonStr = _prefs.getString(_keyBadges);
    if (jsonStr == null || jsonStr.isEmpty) return defaultBadges();
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((e) => BadgeItem.fromMap(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return defaultBadges();
    }
  }

  Future<void> saveBadges(List<BadgeItem> badges) async {
    final jsonStr = jsonEncode(badges.map((e) => e.toMap()).toList());
    await _prefs.setString(_keyBadges, jsonStr);
  }

  // User Profile
  UserProfile loadProfile() {
    final jsonStr = _prefs.getString(_keyProfile);
    if (jsonStr == null || jsonStr.isEmpty) return const UserProfile();
    try {
      return UserProfile.fromMap(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return const UserProfile();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_keyProfile, jsonEncode(profile.toMap()));
  }

  // Default Seed Data
  Future<void> _seedInitialData() async {
    // 3 clean starter habits
    final starterHabits = [
      Habit(
        id: 'habit_1',
        name: 'Günde 2 Litre Su İç',
        goal: '2 Litre',
        category: HabitCategory.saglik,
        iconCodePoint: Icons.water_drop_rounded.codePoint,
        frequencyType: HabitFrequencyType.everyDay,
        difficulty: HabitDifficulty.veryEasy,
      ),
      Habit(
        id: 'habit_2',
        name: '20 Sayfa Kitap Oku',
        goal: '20 Sayfa',
        category: HabitCategory.ogrenme,
        iconCodePoint: Icons.menu_book_rounded.codePoint,
        frequencyType: HabitFrequencyType.everyDay,
        difficulty: HabitDifficulty.easy,
      ),
      Habit(
        id: 'habit_3',
        name: 'Sabah Yürüyüşü / Egzersiz',
        goal: '30 Dakika',
        category: HabitCategory.spor,
        iconCodePoint: Icons.directions_walk_rounded.codePoint,
        frequencyType: HabitFrequencyType.weekdays,
        selectedDays: [1, 2, 3, 4, 5],
        difficulty: HabitDifficulty.medium,
      ),
    ];

    await saveHabits(starterHabits);
    await saveRoomItems(defaultRoomItems());
    await saveBadges(defaultBadges());
    await savePoints(25); // Welcome bonus points to explore room items
    await saveProfile(const UserProfile());
  }

  static List<RoomItem> defaultRoomItems() {
    return [
      // Masa & Çalışma
      RoomItem(
        id: 'desk_basic',
        name: 'Sade Ahşap Masa',
        description: 'Sıcak tonlarda ferah bir çalışma masası.',
        slotType: RoomSlotType.desk,
        iconCodePoint: Icons.desk_rounded.codePoint,
        price: 30,
        isOwned: true,
        isPlaced: true,
      ),
      RoomItem(
        id: 'desk_executive',
        name: 'Modern Meşe Çalışma İstasyonu',
        description: 'Geniş yüzeyiyle derin odaklanma sağlar.',
        slotType: RoomSlotType.desk,
        iconCodePoint: Icons.table_restaurant_rounded.codePoint,
        price: 80,
      ),

      // Bitki
      RoomItem(
        id: 'plant_succulent',
        name: 'Sukulent Saksısı',
        description: 'Küçük ama yeşil bir canlılık esintisi.',
        slotType: RoomSlotType.plant,
        iconCodePoint: Icons.eco_rounded.codePoint,
        price: 20,
        isOwned: true,
        isPlaced: true,
      ),
      RoomItem(
        id: 'plant_monstera',
        name: 'Büyük Deve Tabanı',
        description: 'Odanın havasını tazeleyen tropikal yeşillik.',
        slotType: RoomSlotType.plant,
        iconCodePoint: Icons.yard_rounded.codePoint,
        price: 50,
      ),
      RoomItem(
        id: 'plant_bonsai_milestone',
        name: 'Kadim Bonsai Ağacı',
        description: '7 günlük kesintisiz disiplinin yeşil ödülü.',
        slotType: RoomSlotType.plant,
        iconCodePoint: Icons.park_rounded.codePoint,
        price: 0,
        streakRequirement: 7,
      ),

      // Kitaplık
      RoomItem(
        id: 'bookshelf_minimal',
        name: 'Minimalist Duvar Rafı',
        description: 'En sevilen kitaplar için şık bir alan.',
        slotType: RoomSlotType.bookshelf,
        iconCodePoint: Icons.shelves.codePoint,
        price: 45,
      ),
      RoomItem(
        id: 'bookshelf_library',
        name: 'Geniş Ahşap Kütüphane',
        description: 'Bilgelik ve alışkanlık dolu raflar.',
        slotType: RoomSlotType.bookshelf,
        iconCodePoint: Icons.local_library_rounded.codePoint,
        price: 110,
      ),

      // Halı
      RoomItem(
        id: 'rug_boho',
        name: 'Adaçayı Yeşili Geometrik Halı',
        description: 'Odaya yumuşak ve dengeli bir hava katar.',
        slotType: RoomSlotType.rug,
        iconCodePoint: Icons.crop_landscape_rounded.codePoint,
        price: 35,
        isOwned: true,
        isPlaced: true,
      ),
      RoomItem(
        id: 'rug_sand',
        name: 'Kum Dokulu İskandinav Halısı',
        description: 'Ayakları dinlendiren sıcak doku.',
        slotType: RoomSlotType.rug,
        iconCodePoint: Icons.layers_rounded.codePoint,
        price: 60,
      ),

      // Duvar Dekoru
      RoomItem(
        id: 'art_nature',
        name: 'Minimal Doğa Tablosu',
        description: 'Dinginlik veren soyut orman resmi.',
        slotType: RoomSlotType.wallArt,
        iconCodePoint: Icons.landscape_rounded.codePoint,
        price: 40,
      ),
      RoomItem(
        id: 'art_clock',
        name: 'Sessiz Ahşap Duvar Saati',
        description: 'Zamanın değerini fısıldayan şık tasarım.',
        slotType: RoomSlotType.wallArt,
        iconCodePoint: Icons.access_time_filled_rounded.codePoint,
        price: 55,
      ),

      // Aydınlatma
      RoomItem(
        id: 'lamp_warm',
        name: 'Sıcak Işık Lambaderi',
        description: 'Akşam okumaları için huzurlu bir ışıltı.',
        slotType: RoomSlotType.lamp,
        iconCodePoint: Icons.lightbulb_outline_rounded.codePoint,
        price: 50,
      ),

      // Koltuk
      RoomItem(
        id: 'chair_cozy',
        name: 'Rahat Okuma Koltuğu',
        description: 'Düşüncelere dalıp dinlenmek için ideal.',
        slotType: RoomSlotType.chair,
        iconCodePoint: Icons.chair_rounded.codePoint,
        price: 90,
      ),

      // Özel Streak & Başarı Ödülleri (streakRequirement > 0)
      RoomItem(
        id: 'trophy_streak_14',
        name: '14 Gün Streak Rozet Heykeli',
        description: '14 günlük demir gibi irade sembolü.',
        slotType: RoomSlotType.trophy,
        iconCodePoint: Icons.military_tech_rounded.codePoint,
        price: 0,
        streakRequirement: 14,
      ),
      RoomItem(
        id: 'trophy_streak_30',
        name: 'Altın DO IT Efsane Kupası',
        description: '30 günlük istikrarın parlayan zirvesi.',
        slotType: RoomSlotType.trophy,
        iconCodePoint: Icons.emoji_events_rounded.codePoint,
        price: 0,
        streakRequirement: 30,
      ),
    ];
  }

  static List<BadgeItem> defaultBadges() {
    return [
      BadgeItem(
        id: 'badge_first_habit',
        title: 'İlk Adım',
        description: 'İlk alışkanlığını tanımlayarak yola çıktın.',
        iconCodePoint: Icons.flag_rounded.codePoint,
      ),
      BadgeItem(
        id: 'badge_first_done',
        title: 'Başlangıç Ateşi',
        description: 'İlk alışkanlığını başarıyla tamamladın.',
        iconCodePoint: Icons.local_fire_department_rounded.codePoint,
        requiredTotalCompletions: 1,
      ),
      BadgeItem(
        id: 'badge_streak_3',
        title: '3 Günlük Kıvılcım',
        description: '3 gün boyunca zinciri hiç kırmadın.',
        iconCodePoint: Icons.bolt_rounded.codePoint,
        requiredStreak: 3,
      ),
      BadgeItem(
        id: 'badge_streak_7',
        title: '7 Günlük Zincir',
        description: 'Tam 1 hafta boyunca kararlılıkla devam ettin.',
        iconCodePoint: Icons.link_rounded.codePoint,
        requiredStreak: 7,
      ),
      BadgeItem(
        id: 'badge_streak_14',
        title: '14 Günlük Alışkanlık Ustası',
        description: '2 hafta kesintisiz istikrar yakaladın.',
        iconCodePoint: Icons.shield_rounded.codePoint,
        requiredStreak: 14,
      ),
      BadgeItem(
        id: 'badge_streak_30',
        title: '30 Günlük DO IT Efsanesi',
        description: '30 gün kesintisiz alışkanlık sürdürerek alışkanlığı hayatının parçası yaptın.',
        iconCodePoint: Icons.auto_awesome_rounded.codePoint,
        requiredStreak: 30,
      ),
      BadgeItem(
        id: 'badge_points_50',
        title: '50 Puan Kulübü',
        description: 'Topladığın puanlarla 50 barajını aştın.',
        iconCodePoint: Icons.stars_rounded.codePoint,
        requiredPoints: 50,
      ),
      BadgeItem(
        id: 'badge_points_200',
        title: 'Puan Zengini',
        description: 'Toplam 200 puan toplayarak büyük bir hazineye ulaştın.',
        iconCodePoint: Icons.diamond_rounded.codePoint,
        requiredPoints: 200,
      ),
      BadgeItem(
        id: 'badge_room_decorator',
        title: 'Oda Tasarımcısı',
        description: 'Odan için en az 4 eşya sahibi oldun.',
        iconCodePoint: Icons.home_rounded.codePoint,
        requiredRoomItems: 4,
      ),
    ];
  }
}

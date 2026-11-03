import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../models/room_item.dart';
import '../models/badge_item.dart';
import '../models/user_profile.dart';

// yerel cihaz hafızasına (SharedPreferences) verileri kaydeden ve okuyan servis
class StorageService {
  // SharedPreferences anahtarları
  static const String _keyHabits = 'doit_habits_v1';
  static const String _keyLogs = 'doit_logs_v1';
  static const String _keyRoomItems = 'doit_room_items_v1';
  static const String _keyPoints = 'doit_points_balance_v1';
  static const String _keyBadges = 'doit_badges_v1';
  static const String _keyProfile = 'doit_profile_v1';
  static const String _keyInitialized = 'doit_initialized_v1';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // servisi asenkron olarak ayağa kaldıran statik fabrika metodu
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = StorageService(prefs);
    // ilk açılışta varsayılan örnek verileri (seed) dolduruyoruz
    if (!prefs.containsKey(_keyInitialized)) {
      await service._seedInitialData();
      await prefs.setBool(_keyInitialized, true);
    }
    return service;
  }

  // kayıtlı alışkanlıkları okur
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

  // alışkanlıklar listesini JSON string olarak kaydeder
  Future<void> saveHabits(List<Habit> habits) async {
    final jsonStr = jsonEncode(habits.map((e) => e.toMap()).toList());
    await _prefs.setString(_keyHabits, jsonStr);
  }

  // tamamlanma günlüklerini okur
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

  // katalog ile yerel kaydı birleştirip oda eşyalarını getirir
  List<RoomItem> loadRoomItems() {
    final catalog = defaultRoomItems();
    final jsonStr = _prefs.getString(_keyRoomItems);
    if (jsonStr == null || jsonStr.isEmpty) return catalog;

    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      final savedItems = list.map((e) => RoomItem.fromMap(e as Map<String, dynamic>)).toList();

      final Map<String, RoomItem> itemMap = {};
      // katalogdaki varsayılan eşyaları ekliyoruz
      for (final catItem in catalog) {
        itemMap[catItem.id] = catItem;
      }

      // kullanıcının kaydettiği konum ve sahiplik durumlarını üzerine yazıyoruz
      for (final saved in savedItems) {
        if (itemMap.containsKey(saved.id)) {
          final cat = itemMap[saved.id]!;
          final posX = (saved.positionX == 0.0 && saved.positionZ == 0.0 && (cat.positionX != 0.0 || cat.positionZ != 0.0))
              ? cat.positionX
              : saved.positionX;
          final posZ = (saved.positionX == 0.0 && saved.positionZ == 0.0 && (cat.positionX != 0.0 || cat.positionZ != 0.0))
              ? cat.positionZ
              : saved.positionZ;

          itemMap[saved.id] = cat.copyWith(
            isOwned: saved.isOwned,
            isPlaced: saved.isPlaced,
            positionX: posX,
            positionZ: posZ,
            rotationY: saved.rotationY,
          );
        } else {
          itemMap[saved.id] = saved;
        }
      }

      return itemMap.values.toList();
    } catch (_) {
      return catalog;
    }
  }

  Future<void> saveRoomItems(List<RoomItem> items) async {
    final jsonStr = jsonEncode(items.map((e) => e.toMap()).toList());
    await _prefs.setString(_keyRoomItems, jsonStr);
  }

  // puan bakiyesini okur
  int loadPoints() {
    return _prefs.getInt(_keyPoints) ?? 0;
  }

  Future<void> savePoints(int points) async {
    await _prefs.setInt(_keyPoints, points);
  }

  // rozetleri okur
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

  // kullanıcı profilini okur
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

  // uygulama ilk kurulduğunda çalışan başlangıç verisi üreticisi
  Future<void> _seedInitialData() async {
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
    await savePoints(25); // ilk açılış hoş geldin bonusu
    await saveProfile(const UserProfile());
  }

  // varsayılan oda mobilya kataloğu
  static List<RoomItem> defaultRoomItems() {
    return [
      // 1. Masa & Çalışma
      RoomItem(
        id: 'desk_basic',
        name: 'Sade Ahşap Çalışma Masası',
        description: 'Sıcak ahşap tabla, sağlam metal ayaklar ve laptop.',
        slotType: RoomSlotType.desk,
        iconCodePoint: Icons.desk_rounded.codePoint,
        price: 30,
        isOwned: true,
        isPlaced: true,
        positionX: -1.6,
        positionZ: 1.8,
        rotationY: 0,
      ),
      RoomItem(
        id: 'desk_executive',
        name: 'Geniş Yönetici Masası',
        description: 'Koyu meşe kaplama, geniş çalışma alanı.',
        slotType: RoomSlotType.desk,
        iconCodePoint: Icons.table_restaurant_rounded.codePoint,
        price: 80,
        positionX: -1.6,
        positionZ: 1.8,
        rotationY: 0,
      ),

      // 2. Sandalye
      RoomItem(
        id: 'chair_ergonomic',
        name: 'Ergonomik Çalışma Sandalyesi',
        description: 'Sırt destekli ve döner tabanlı konforlu sandalye.',
        slotType: RoomSlotType.chair,
        iconCodePoint: Icons.chair_alt_rounded.codePoint,
        price: 35,
        isOwned: true,
        isPlaced: true,
        positionX: -1.6,
        positionZ: 0.6,
        rotationY: 0,
      ),
      RoomItem(
        id: 'chair_wooden',
        name: 'İskandinav Ahşap Sandalye',
        description: 'Minimalist ahşap dikişli tasarım.',
        slotType: RoomSlotType.chair,
        iconCodePoint: Icons.chair_rounded.codePoint,
        price: 50,
        positionX: -1.6,
        positionZ: 0.6,
        rotationY: 0,
      ),

      // 3. Koltuk & Dinlenme
      RoomItem(
        id: 'sofa_cozy',
        name: 'Adaçayı Dinlenme Koltuğu',
        description: 'Yumuşak kumaş döşeme ve ahşap ayaklı berjer.',
        slotType: RoomSlotType.sofa,
        iconCodePoint: Icons.weekend_rounded.codePoint,
        price: 75,
        positionX: 1.6,
        positionZ: -1.2,
        rotationY: -45,
      ),
      RoomItem(
        id: 'sofa_modern',
        name: 'Modern Geniş Kanepe',
        description: 'İki kişilik ferah ve şık oturma ünitesi.',
        slotType: RoomSlotType.sofa,
        iconCodePoint: Icons.chair_rounded.codePoint,
        price: 120,
        positionX: 1.4,
        positionZ: -1.4,
        rotationY: 0,
      ),

      // 4. Yatak
      RoomItem(
        id: 'bed_modern',
        name: 'Konforlu Karyola & Yatak',
        description: 'Yumuşak adaçayı nevresimli, kabarık yastıklı yatak.',
        slotType: RoomSlotType.bed,
        iconCodePoint: Icons.bed_rounded.codePoint,
        price: 95,
        positionX: 1.8,
        positionZ: 1.6,
        rotationY: 0,
      ),
      RoomItem(
        id: 'bed_minimal',
        name: 'Japon Tarzı Alçak Yatak',
        description: 'Huzurlu ve minimalist uyku köşesi.',
        slotType: RoomSlotType.bed,
        iconCodePoint: Icons.single_bed_rounded.codePoint,
        price: 130,
        positionX: 1.8,
        positionZ: 1.6,
        rotationY: 0,
      ),

      // 5. Gardırop & Dolap
      RoomItem(
        id: 'wardrobe_wood',
        name: 'Çift Kapaklı Ahşap Dolap',
        description: 'Geniş hacimli, modern metal kulplu gardırop.',
        slotType: RoomSlotType.wardrobe,
        iconCodePoint: Icons.door_sliding_rounded.codePoint,
        price: 85,
        positionX: 2.4,
        positionZ: -0.4,
        rotationY: -90,
      ),

      // 6. Kitaplık & Raf
      RoomItem(
        id: 'bookshelf_minimal',
        name: 'Minimalist Duvar Rafı',
        description: 'En sevilen kitaplar için şık bir alan.',
        slotType: RoomSlotType.bookshelf,
        iconCodePoint: Icons.shelves.codePoint,
        price: 45,
        positionX: -2.8,
        positionZ: -1.2,
        rotationY: 90,
      ),
      RoomItem(
        id: 'bookshelf_library',
        name: 'Geniş Ahşap Kütüphane',
        description: 'Renkli 3D kitaplarla dolu 3 katlı kütüphane.',
        slotType: RoomSlotType.bookshelf,
        iconCodePoint: Icons.local_library_rounded.codePoint,
        price: 110,
        positionX: -2.8,
        positionZ: -1.5,
        rotationY: 90,
      ),

      // 7. Zemin & Halı
      RoomItem(
        id: 'rug_boho',
        name: 'Adaçayı Yeşili Geometrik Halı',
        description: 'Odaya yumuşak ve dengeli bir hava katar.',
        slotType: RoomSlotType.rug,
        iconCodePoint: Icons.crop_landscape_rounded.codePoint,
        price: 35,
        isOwned: true,
        isPlaced: true,
        positionX: 0.0,
        positionZ: -0.4,
        rotationY: 0,
      ),
      RoomItem(
        id: 'rug_sand',
        name: 'Kum Dokulu İskandinav Halısı',
        description: 'Ayakları dinlendiren sıcak doku.',
        slotType: RoomSlotType.rug,
        iconCodePoint: Icons.layers_rounded.codePoint,
        price: 60,
        positionX: 0.0,
        positionZ: -0.4,
        rotationY: 0,
      ),

      // 8. Bitki Köşesi
      RoomItem(
        id: 'plant_succulent',
        name: 'Sukulent & Seramik Saksı',
        description: 'Küçük ama yeşil bir canlılık esintisi.',
        slotType: RoomSlotType.plant,
        iconCodePoint: Icons.eco_rounded.codePoint,
        price: 20,
        isOwned: true,
        isPlaced: true,
        positionX: 2.4,
        positionZ: 2.4,
        rotationY: 0,
      ),
      RoomItem(
        id: 'plant_monstera',
        name: 'Büyük Deve Tabanı',
        description: 'Odanın havasını tazeleyen tropikal yeşillik.',
        slotType: RoomSlotType.plant,
        iconCodePoint: Icons.yard_rounded.codePoint,
        price: 50,
        positionX: 2.2,
        positionZ: 2.2,
        rotationY: 0,
      ),
      RoomItem(
        id: 'plant_bonsai_milestone',
        name: 'Kadim Bonsai Ağacı',
        description: '7 günlük kesintisiz disiplinin yeşil ödülü.',
        slotType: RoomSlotType.plant,
        iconCodePoint: Icons.park_rounded.codePoint,
        price: 0,
        streakRequirement: 7,
        positionX: 2.2,
        positionZ: 2.2,
        rotationY: 0,
      ),

      // 9. Aydınlatma
      RoomItem(
        id: 'lamp_warm',
        name: 'Sıcak Işık Lambaderi',
        description: 'Akşam okumaları için huzurlu bir ışıltı saçan lambader.',
        slotType: RoomSlotType.lamp,
        iconCodePoint: Icons.lightbulb_outline_rounded.codePoint,
        price: 50,
        positionX: -2.6,
        positionZ: 2.4,
        rotationY: 0,
      ),

      // 10. Duvar Dekoru
      RoomItem(
        id: 'art_nature',
        name: 'Minimal Doğa Tablosu',
        description: 'Dinginlik veren soyut orman resmi.',
        slotType: RoomSlotType.wallArt,
        iconCodePoint: Icons.landscape_rounded.codePoint,
        price: 40,
        positionX: -3.8,
        positionZ: 0.0,
        rotationY: 90,
      ),
      RoomItem(
        id: 'art_clock',
        name: 'Sessiz Ahşap Duvar Saati',
        description: 'Zamanın değerini fısıldayan şık tasarım.',
        slotType: RoomSlotType.wallArt,
        iconCodePoint: Icons.access_time_filled_rounded.codePoint,
        price: 55,
        positionX: -3.8,
        positionZ: -1.5,
        rotationY: 90,
      ),

      // 11. Özel Streak & Başarı Ödülleri
      RoomItem(
        id: 'trophy_streak_14',
        name: '14 Gün Streak Rozet Heykeli',
        description: '14 günlük demir gibi irade sembolü.',
        slotType: RoomSlotType.trophy,
        iconCodePoint: Icons.military_tech_rounded.codePoint,
        price: 0,
        streakRequirement: 14,
        positionX: 0.8,
        positionZ: 2.6,
        rotationY: 0,
      ),
      RoomItem(
        id: 'trophy_streak_30',
        name: 'Altın DO IT Efsane Kupası',
        description: '30 günlük istikrarın parlayan zirvesi.',
        slotType: RoomSlotType.trophy,
        iconCodePoint: Icons.emoji_events_rounded.codePoint,
        price: 0,
        streakRequirement: 30,
        positionX: 0.8,
        positionZ: 2.6,
        rotationY: 0,
      ),
    ];
  }

  // varsayılan rozet tanımları
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


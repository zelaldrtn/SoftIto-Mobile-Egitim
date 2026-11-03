import 'package:flutter/material.dart';

// 3D/İzometrik sanal odadaki mobilya ve dekorasyon yuvası türleri
enum RoomSlotType {
  desk('Çalışma Masası', Icons.desk_rounded),
  chair('Sandalye', Icons.chair_alt_rounded),
  sofa('Koltuk & Dinlenme', Icons.chair_rounded),
  bed('Yatak', Icons.bed_rounded),
  wardrobe('Gardırop & Dolap', Icons.door_sliding_rounded),
  bookshelf('Kitaplık & Raf', Icons.shelves),
  rug('Zemin & Halı', Icons.crop_landscape_rounded),
  plant('Bitki Köşesi', Icons.eco_rounded),
  lamp('Aydınlatma', Icons.lightbulb_outline_rounded),
  wallArt('Duvar Dekoru', Icons.brush_rounded),
  trophy('Başarı Alanı', Icons.emoji_events_rounded);

  final String label;
  final IconData defaultIcon;
  const RoomSlotType(this.label, this.defaultIcon);
}

// oda mağazasında satılan ve odaya yerleştirilebilen eşya modeli
class RoomItem {
  final String id;
  final String name;
  final String description;
  final RoomSlotType slotType;
  final int iconCodePoint;
  final int price; // puan cinsinden fiyatı
  final int streakRequirement; // zincir kilit şartı (0 ise mağazada direkt alınabilir)
  final bool isOwned; // satın alındı mı
  final bool isPlaced; // odaya yerleştirildi mi
  final double positionX; // 3D dünyada X zemin konumu (-3.2 ile 3.2 arası)
  final double positionZ; // 3D dünyada Z zemin konumu (-3.2 ile 3.2 arası)
  final double rotationY; // 0, 90, 180, 270 derece dönüş açısı

  const RoomItem({
    required this.id,
    required this.name,
    required this.description,
    required this.slotType,
    required this.iconCodePoint,
    required this.price,
    this.streakRequirement = 0,
    this.isOwned = false,
    this.isPlaced = false,
    this.positionX = 0.0,
    this.positionZ = 0.0,
    this.rotationY = 0.0,
  });

  // eşya konumunu veya sahiplik durumunu güncelleyip yeni nesne döndürür
  RoomItem copyWith({
    String? id,
    String? name,
    String? description,
    RoomSlotType? slotType,
    int? iconCodePoint,
    int? price,
    int? streakRequirement,
    bool? isOwned,
    bool? isPlaced,
    double? positionX,
    double? positionZ,
    double? rotationY,
  }) {
    return RoomItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      slotType: slotType ?? this.slotType,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      price: price ?? this.price,
      streakRequirement: streakRequirement ?? this.streakRequirement,
      isOwned: isOwned ?? this.isOwned,
      isPlaced: isPlaced ?? this.isPlaced,
      positionX: positionX ?? this.positionX,
      positionZ: positionZ ?? this.positionZ,
      rotationY: rotationY ?? this.rotationY,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'slotType': slotType.name,
      'iconCodePoint': iconCodePoint,
      'price': price,
      'streakRequirement': streakRequirement,
      'isOwned': isOwned,
      'isPlaced': isPlaced,
      'positionX': positionX,
      'positionZ': positionZ,
      'rotationY': rotationY,
    };
  }

  factory RoomItem.fromMap(Map<String, dynamic> map) {
    RoomSlotType slot = RoomSlotType.desk;
    try {
      slot = RoomSlotType.values.firstWhere((e) => e.name == map['slotType']);
    } catch (_) {}

    return RoomItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: (map['description'] as String?) ?? '',
      slotType: slot,
      iconCodePoint: (map['iconCodePoint'] as int?) ?? Icons.star_rounded.codePoint,
      price: (map['price'] as int?) ?? 0,
      streakRequirement: (map['streakRequirement'] as int?) ?? 0,
      isOwned: (map['isOwned'] as bool?) ?? false,
      isPlaced: (map['isPlaced'] as bool?) ?? false,
      positionX: (map['positionX'] as num?)?.toDouble() ?? 0.0,
      positionZ: (map['positionZ'] as num?)?.toDouble() ?? 0.0,
      rotationY: (map['rotationY'] as num?)?.toDouble() ?? 0.0,
    );
  }
}


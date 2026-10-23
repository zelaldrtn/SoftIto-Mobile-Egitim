import 'package:flutter/material.dart';

enum RoomSlotType {
  desk('Çalışma Masası', Icons.desk_rounded),
  plant('Bitki Köşesi', Icons.eco_rounded),
  bookshelf('Kitaplık & Raf', Icons.shelves),
  rug('Zemin & Halı', Icons.crop_landscape_rounded),
  wallArt('Duvar Dekoru', Icons.brush_rounded),
  lamp('Aydınlatma', Icons.lightbulb_outline_rounded),
  chair('Oturma Alanı', Icons.chair_rounded),
  trophy('Başarı Alanı', Icons.emoji_events_rounded);

  final String label;
  final IconData defaultIcon;
  const RoomSlotType(this.label, this.defaultIcon);
}

class RoomItem {
  final String id;
  final String name;
  final String description;
  final RoomSlotType slotType;
  final int iconCodePoint;
  final int price; // In DO IT points
  final int streakRequirement; // 0 for regular store item; >0 for milestone unlock
  final bool isOwned;
  final bool isPlaced;

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
  });

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
    );
  }
}

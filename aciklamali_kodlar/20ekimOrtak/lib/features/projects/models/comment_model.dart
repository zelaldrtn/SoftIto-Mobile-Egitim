/// Projelere yapılan yorum ve soru-cevap model sınıfı.
// projelere bırakılan yorumları ve beğeni durumlarını temsil eden model
class CommentModel {
  final String id;
  final String authorName;
  final String authorTitle;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final bool isLiked;

  // const constructor: derleme anında değişmez yorum nesneleri üretmeyi sağlar
  const CommentModel({
    required this.id,
    required this.authorName,
    required this.authorTitle,
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.isLiked = false,
  });

  // copyWith: yorum beğenildiğinde mevcut nesneyi bozmadan kopyasını üretir
  CommentModel copyWith({
    String? id,
    String? authorName,
    String? authorTitle,
    String? content,
    DateTime? createdAt,
    int? likesCount,
    bool? isLiked,
  }) {
    return CommentModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorTitle: authorTitle ?? this.authorTitle,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}


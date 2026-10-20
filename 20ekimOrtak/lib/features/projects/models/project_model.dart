import 'comment_model.dart';

/// Girişimci proje veri modeli.
class ProjectModel {
  final String id;
  final String title;
  final String tagline;
  final String description;
  final String creatorName;
  final String creatorRole;
  final String category;
  final String imageUrl;
  final String? videoUrl;
  final double targetFunding;
  final double currentFunding;
  final int supportersCount;
  final int likesCount;
  final bool isLiked;
  final bool isSaved;
  final List<String> tags;
  final DateTime createdAt;
  final List<CommentModel> comments;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.creatorName,
    required this.creatorRole,
    required this.category,
    required this.imageUrl,
    this.videoUrl,
    required this.targetFunding,
    required this.currentFunding,
    required this.supportersCount,
    this.likesCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.tags,
    required this.createdAt,
    this.comments = const <CommentModel>[],
  });

  /// Fonlama tamamlanma yüzdesi (0.0 - 1.0 aralığı)
  double get fundingRatio {
    if (targetFunding <= 0) return 0.0;
    final double ratio = currentFunding / targetFunding;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  /// Fonlama yüzdesi tam sayı formatında
  int get fundingPercentage {
    if (targetFunding <= 0) return 0;
    return ((currentFunding / targetFunding) * 100).round();
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? tagline,
    String? description,
    String? creatorName,
    String? creatorRole,
    String? category,
    String? imageUrl,
    String? videoUrl,
    double? targetFunding,
    double? currentFunding,
    int? supportersCount,
    int? likesCount,
    bool? isLiked,
    bool? isSaved,
    List<String>? tags,
    DateTime? createdAt,
    List<CommentModel>? comments,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      creatorName: creatorName ?? this.creatorName,
      creatorRole: creatorRole ?? this.creatorRole,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      targetFunding: targetFunding ?? this.targetFunding,
      currentFunding: currentFunding ?? this.currentFunding,
      supportersCount: supportersCount ?? this.supportersCount,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }
}

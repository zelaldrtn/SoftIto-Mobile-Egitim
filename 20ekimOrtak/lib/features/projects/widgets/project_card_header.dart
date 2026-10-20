import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';
import '../models/project_model.dart';

/// Proje kartı görsel başlık ve kaydet butonu bileşeni.
class ProjectCardHeader extends StatelessWidget {
  final ProjectModel project;

  const ProjectCardHeader({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              project.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _FallbackBanner(project: project),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: _CategoryBadge(category: project.category),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: _SaveButton(project: project),
        ),
      ],
    );
  }
}

class _FallbackBanner extends StatelessWidget {
  final ProjectModel project;
  const _FallbackBanner({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF1E3A8A), Color(0xFF0D9488)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.rocket_launch_rounded, size: 44, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              project.title.split(':').first,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(180),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final ProjectModel project;
  const _SaveButton({required this.project});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.black.withAlpha(150),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: Icon(
          project.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          color: project.isSaved ? const Color(0xFFFACC15) : Colors.white,
        ),
        onPressed: () => ProjectsController.instance.toggleSave(project.id),
      ),
    );
  }
}

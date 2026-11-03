import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';
import '../models/project_model.dart';
import 'support_dialog.dart';

// proje kartı alt etkileşim ve aksiyon çubuğu
class ProjectCardFooter extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onOpenComments;

  const ProjectCardFooter({
    super.key,
    required this.project,
    required this.onOpenComments,
  });

  @override
  Widget build(BuildContext context) {
    // beğeni/yorum butonları ile Destek Ol butonunu iki uca dağıtıyoruz
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // beğeni ve yorum butonlarını solda yan yana grupluyoruz
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                // beğenilmişse dolu kırmızı kalp, değilse içi boş kalp gösteriyoruz
                project.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: project.isLiked ? Colors.red : null,
              ),
              onPressed: () => ProjectsController.instance.toggleLike(project.id),
            ),
            Text(
              '${project.likesCount}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.mode_comment_outlined),
              // yorumlar tıklandığında dışarıdan aktarılan callback tetiklenir
              onPressed: onOpenComments,
            ),
            Text(
              '${project.comments.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        // sağ köşedeki destek butonu
        ElevatedButton.icon(
          onPressed: () => SupportDialog.show(context, project),
          icon: const Icon(Icons.handshake_rounded, size: 18),
          label: const Text('Destek Ol'),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';
import '../models/comment_model.dart';
import '../models/project_model.dart';
import '../widgets/funding_progress_bar.dart';
import '../widgets/support_dialog.dart';

/// Girişim projesi detay ve topluluk tartışma ekranı.
class ProjectDetailView extends StatelessWidget {
  final String projectId;

  const ProjectDetailView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProjectModel>>(
      valueListenable: ProjectsController.instance.projectsNotifier,
      builder: (BuildContext context, List<ProjectModel> projects, _) {
        final ProjectModel? project = projects
            .where((ProjectModel p) => p.id == projectId)
            .firstOrNull;

        if (project == null) {
          return const Scaffold(
            body: Center(child: Text('Proje bulunamadı.')),
          );
        }

        return Scaffold(
          appBar: _DetailAppBar(project: project),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: <Widget>[
              _DetailMediaHeader(project: project),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _DetailTitleSection(project: project),
                    const SizedBox(height: 16),
                    _DetailFundingCard(project: project),
                    const SizedBox(height: 16),
                    _DetailCreatorCard(project: project),
                    const SizedBox(height: 16),
                    _DetailDescription(project: project),
                    const SizedBox(height: 24),
                    _DetailDiscussionSection(project: project),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _DetailBottomBar(project: project),
        );
      },
    );
  }
}

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ProjectModel project;
  const _DetailAppBar({required this.project});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        project.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            project.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: project.isSaved ? const Color(0xFFFACC15) : null,
          ),
          onPressed: () => ProjectsController.instance.toggleSave(project.id),
        ),
      ],
    );
  }
}

class _DetailMediaHeader extends StatelessWidget {
  final ProjectModel project;
  const _DetailMediaHeader({required this.project});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            project.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF1E3A8A), Color(0xFF0D9488)],
                ),
              ),
              child: const Center(
                child: Icon(Icons.rocket_launch_rounded, size: 54, color: Colors.white),
              ),
            ),
          ),
        ),
        if (project.videoUrl != null)
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Tanıtım Videosu', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DetailTitleSection extends StatelessWidget {
  final ProjectModel project;
  const _DetailTitleSection({required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                project.category,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${project.supportersCount} Destekçi',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          project.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          project.tagline,
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ],
    );
  }
}

class _DetailFundingCard extends StatelessWidget {
  final ProjectModel project;
  const _DetailFundingCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            FundingProgressBar(
              current: project.currentFunding,
              target: project.targetFunding,
              ratio: project.fundingRatio,
              percentage: project.fundingPercentage,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Hedef: ₺${project.targetFunding.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  'Kalan: ₺${(project.targetFunding - project.currentFunding).clamp(0, double.infinity).toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailCreatorCard extends StatelessWidget {
  final ProjectModel project;
  const _DetailCreatorCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            project.creatorName.characters.first,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(project.creatorName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(project.creatorRole),
        trailing: const Icon(Icons.verified_user_rounded, color: Colors.blue, size: 20),
      ),
    );
  }
}

class _DetailDescription extends StatelessWidget {
  final ProjectModel project;
  const _DetailDescription({required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Proje Hikayesi ve Detaylar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          project.description,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: project.tags.map((String tag) {
            return Chip(label: Text('#$tag'));
          }).toList(),
        ),
      ],
    );
  }
}

class _DetailDiscussionSection extends StatefulWidget {
  final ProjectModel project;
  const _DetailDiscussionSection({required this.project});

  @override
  State<_DetailDiscussionSection> createState() => _DetailDiscussionSectionState();
}

class _DetailDiscussionSectionState extends State<_DetailDiscussionSection> {
  final TextEditingController _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Girişimciyle Konuşun (${widget.project.comments.length} Yorum)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _CommentInputBar(
          controller: _commentCtrl,
          onSend: _sendComment,
        ),
        const SizedBox(height: 16),
        ...widget.project.comments.map(
          (CommentModel c) => _CommentCard(comment: c),
        ),
      ],
    );
  }

  void _sendComment() {
    ProjectsController.instance.addComment(
      widget.project.id,
      'Ziyaretçi',
      _commentCtrl.text,
    );
    _commentCtrl.clear();
  }
}

class _CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _CommentInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Bir soru sorun veya destek mesajı yazın...',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.send_rounded),
          onPressed: onSend,
        ),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  final CommentModel comment;
  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(comment.authorName.characters.first),
        ),
        title: Text(
          comment.authorName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(comment.content),
      ),
    );
  }
}

class _DetailBottomBar extends StatelessWidget {
  final ProjectModel project;
  const _DetailBottomBar({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline)),
      ),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                project.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: project.isLiked ? Colors.red : null,
              ),
              onPressed: () => ProjectsController.instance.toggleLike(project.id),
            ),
            Text('${project.likesCount}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => SupportDialog.show(context, project),
                icon: const Icon(Icons.handshake_rounded),
                label: const Text('Bu Girişime Destek Ol'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

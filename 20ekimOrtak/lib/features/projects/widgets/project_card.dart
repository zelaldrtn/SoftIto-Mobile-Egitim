import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../views/project_detail_view.dart';
import 'funding_progress_bar.dart';
import 'project_card_footer.dart';
import 'project_card_header.dart';

/// Girişimci projesini özetleyen ve etkileşim sağlayan ana kart bileşeni.
class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProjectCardHeader(project: project),
            _ProjectCardBody(
              project: project,
              onOpenComments: () => _navigateToDetail(context),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProjectDetailView(projectId: project.id),
      ),
    );
  }
}

class _ProjectCardBody extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onOpenComments;

  const _ProjectCardBody({
    required this.project,
    required this.onOpenComments,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            project.title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            project.tagline,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
            ),
          ),
          const SizedBox(height: 12),
          FundingProgressBar(
            current: project.currentFunding,
            target: project.targetFunding,
            ratio: project.fundingRatio,
            percentage: project.fundingPercentage,
          ),
          const SizedBox(height: 8),
          ProjectCardFooter(
            project: project,
            onOpenComments: onOpenComments,
          ),
        ],
      ),
    );
  }
}

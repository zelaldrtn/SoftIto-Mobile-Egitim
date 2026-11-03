import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../views/project_detail_view.dart';
import 'funding_progress_bar.dart';
import 'project_card_footer.dart';
import 'project_card_header.dart';

// girişimci projesini özetleyen ve etkileşim sağlayan ana kart bileşeni
class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // Card widget'ı gölgeli ve yuvarlak hatlı bir kart zemini oluşturur
    return Card(
      // margin kartın dışındaki boşluktur: yatayda 16, dikeyde 8 birim
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // alt widget'ların kart köşelerinden taşmasını engeller ve yuvarlar
      clipBehavior: Clip.antiAlias,
      // InkWell karta tıklandığında dalgalanma efekti (ripple) verir
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: Column(
          // kart içindeki içerikleri sola hizalıyoruz
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

  // proje detay ekranına geçiş yapar
  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProjectDetailView(projectId: project.id),
      ),
    );
  }
}

// kartın başlık, açıklama ve fonlama çubuğunu tutan gövde kısmı
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
      // her taraftan 14 birim iç boşluk bırakıyoruz
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
            // açıklama en fazla 2 satır gösterilsin
            maxLines: 2,
            // sığmayan kısmı üç nokta (...) ile keser
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


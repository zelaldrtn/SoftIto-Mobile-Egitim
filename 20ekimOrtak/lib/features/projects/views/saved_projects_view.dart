import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';
import '../models/project_model.dart';
import '../widgets/project_card.dart';

/// Kullanıcının kaydettiği girişim projelerini listeleyen ekran.
class SavedProjectsView extends StatelessWidget {
  const SavedProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaydedilen Girişimler'),
      ),
      body: ValueListenableBuilder<List<ProjectModel>>(
        valueListenable: ProjectsController.instance.projectsNotifier,
        builder: (BuildContext context, List<ProjectModel> projects, _) {
          final List<ProjectModel> savedList =
              projects.where((ProjectModel p) => p.isSaved).toList();

          if (savedList.isEmpty) {
            return const _EmptySavedState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: savedList.length,
            itemBuilder: (BuildContext context, int index) {
              return ProjectCard(project: savedList[index]);
            },
          );
        },
      ),
    );
  }
}

class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.bookmark_border_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz kaydedilmiş girişim yok',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'İlgilendiğiniz projeleri yer imlerine ekleyerek\nburadan kolayca takip edebilirsiniz.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

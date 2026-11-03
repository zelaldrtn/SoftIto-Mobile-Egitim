import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';
import '../models/project_model.dart';
import '../widgets/project_card.dart';

// kullanıcının kaydettiği girişim projelerini listeleyen ekran
class SavedProjectsView extends StatelessWidget {
  const SavedProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold ekranın temel iskeletini (appBar, body vb.) oluşturur
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaydedilen Girişimler'),
      ),
      // ValueListenableBuilder ile projeler listesi değiştikçe sadece bu bölümü yeniden çizdiriyoruz
      body: ValueListenableBuilder<List<ProjectModel>>(
        valueListenable: ProjectsController.instance.projectsNotifier,
        builder: (BuildContext context, List<ProjectModel> projects, _) {
          // sadece isSaved true olan projeleri filtreleyip yeni bir listeye alıyoruz
          final List<ProjectModel> savedList =
              projects.where((ProjectModel p) => p.isSaved).toList();

          // henüz kaydedilmiş proje yoksa özel boş durum ekranını gösteriyoruz
          if (savedList.isEmpty) {
            return const _EmptySavedState();
          }

          // liste uzunluğuna göre kaydırılabilir dinamik liste oluşturuyoruz
          return ListView.builder(
            // symmetric ile sadece dikeyde (üstten ve alttan) 8 birim boşluk bırakıyoruz
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

// kayıtlı proje olmadığında gösterilen bilgilendirici widget
class _EmptySavedState extends StatelessWidget {
  const _EmptySavedState();

  @override
  Widget build(BuildContext context) {
    // Center içeriği hem yatay hem dikey olarak tam ortaya hizalar
    return Center(
      child: Column(
        // elemanları dikey ana eksende ortalıyoruz
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.bookmark_border_rounded,
            size: 64,
            // temanın ana hat (outline) rengini alıyoruz
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


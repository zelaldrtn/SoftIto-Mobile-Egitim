import 'package:flutter/material.dart';
import '../../auth/widgets/user_profile_button.dart';
import '../controllers/projects_controller.dart';
import '../models/project_model.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/project_card.dart';
import '../widgets/sort_filter_menu.dart';
import '../widgets/theme_toggle_button.dart';
import 'create_project_view.dart';
import 'saved_projects_view.dart';

/// Destek Bul ana vitrin ve sosyal akış ekranı.
// StatelessWidget: girişim projelerini arama, kategori ve listeleme şeklinde sunan ana sayfa
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: sayfanın temel yapısını (appBar, body, floatingActionButton) kurar
    return Scaffold(
      appBar: const _HomeAppBar(),
      body: const Column(
        children: <Widget>[
          _SearchBar(),
          // SizedBox: araya dikeyde 8 birim boşluk bırakır
          SizedBox(height: 8),
          CategoryFilterChips(),
          SizedBox(height: 4),
          _ProjectListHeader(),
          // Expanded: proje listesinin sayfanın kalan tüm dikey alanını kaplamasını sağlar
          Expanded(child: _ProjectListView()),
        ],
      ),
      // FloatingActionButton.extended: yeni proje paylaşma ekranını açan genişletilmiş yüzen aksiyon butonu
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateProject(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Proje Paylaş'),
      ),
    );
  }

  // yeni proje ekleme sayfasına geçişi sağlayan yönlendirme metodu
  void _openCreateProject(BuildContext context) {
    // Navigator.push: kullanıcıyı CreateProjectView ekranına taşır
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CreateProjectView()),
    );
  }
}

// PreferredSizeWidget: AppBar'ın standart yükseklik (kToolbarHeight) almasını sağlayan arayüz
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          // ClipRRect: köşe yuvarlatılmış logo alanı
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.rocket_launch_rounded),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Destek Bul',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      actions: <Widget>[
        const ThemeToggleButton(),
        const UserProfileButton(),
        IconButton(
          tooltip: 'Kaydedilen Projeler',
          icon: const Icon(Icons.bookmarks_outlined),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SavedProjectsView(),
              ),
            );
          },
        ),
      ],
    );
  }
}

// arama kutusunu barındıran yardımcı widget
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      // EdgeInsets: kutunun kenarlarından boşluk bırakır
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Girişim veya teknoloji ara...',
          prefixIcon: const Icon(Icons.search_rounded),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        // arama kutusuna yazı yazıldıkça filtrelemeyi tetikler
        onChanged: ProjectsController.instance.setSearchQuery,
      ),
    );
  }
}

// bulunan girişim sayısını ve sıralama menüsünü gösteren başlık satırı
class _ProjectListHeader extends StatelessWidget {
  const _ProjectListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // ValueListenableBuilder: filtrelenmiş liste değiştikçe sayı metnini günceller
          ValueListenableBuilder<List<ProjectModel>>(
            valueListenable:
                ProjectsController.instance.filteredProjectsNotifier,
            builder: (BuildContext context, List<ProjectModel> list, _) {
              return Text(
                '${list.length} Girişim Bulundu',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              );
            },
          ),
          const SortFilterMenu(),
        ],
      ),
    );
  }
}

// projeleri dikey akış halinde listeleyen bileşen
class _ProjectListView extends StatelessWidget {
  const _ProjectListView();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProjectModel>>(
      valueListenable: ProjectsController.instance.filteredProjectsNotifier,
      builder: (BuildContext context, List<ProjectModel> projects, _) {
        if (projects.isEmpty) {
          return const Center(
            child: Text(
              'Aramanıza uygun girişim bulunamadı.',
              style: TextStyle(fontSize: 15),
            ),
          );
        }
        // ListView.builder: sadece ekranda görünen proje kartlarını belleğe alarak performanslı listeler
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: projects.length,
          itemBuilder: (BuildContext context, int index) {
            return ProjectCard(project: projects[index]);
          },
        );
      },
    );
  }
}


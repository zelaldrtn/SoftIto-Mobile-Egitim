import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';
import '../models/project_model.dart';

// proje kartı görsel başlık ve kaydet butonu bileşeni
class ProjectCardHeader extends StatelessWidget {
  final ProjectModel project;

  const ProjectCardHeader({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // Stack widget'ları üst üste bindirmek (katmanlamak) için kullanılır
    return Stack(
      children: <Widget>[
        // görselin sadece üst köşelerini yuvarlatıyoruz
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            // 16:9 standart geniş ekran en-boy oranını korur
            aspectRatio: 16 / 9,
            child: Image.network(
              project.imageUrl,
              // resmi belirlenen alana en-boy oranını koruyarak sığdırır ve kırpar
              fit: BoxFit.cover,
              // resim yüklenemezse veya URL geçersizse alternatif görsel gösterir
              errorBuilder: (_, _, _) => _FallbackBanner(project: project),
            ),
          ),
        ),
        // sol üst köşeye kategori etiketini sabitliyoruz
        Positioned(
          top: 12,
          left: 12,
          child: _CategoryBadge(category: project.category),
        ),
        // sağ üst köşeye yer imi / kaydetme butonunu sabitliyoruz
        Positioned(
          top: 10,
          right: 10,
          child: _SaveButton(project: project),
        ),
      ],
    );
  }
}

// resim yüklenemediğinde arka planda şık bir degrade (gradient) gösteren kutu
class _FallbackBanner extends StatelessWidget {
  final ProjectModel project;
  const _FallbackBanner({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // iki renk arasında geçişli arka plan
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
              // başlığın iki nokta öncesindeki ilk kelimesini alıyoruz
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

// görsel üzerinde kategoriyi gösteren yarı saydam yuvarlak rozet
class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        // yarı saydam siyah arka plan ile resim üzerinde okunurluğu artırıyoruz
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

// projeyi kaydetme veya favorilerden çıkarma butonu
class _SaveButton extends StatelessWidget {
  final ProjectModel project;
  const _SaveButton({required this.project});

  @override
  Widget build(BuildContext context) {
    // CircleAvatar dairesel bir buton arka planı sağlar
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.black.withAlpha(150),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: Icon(
          // kaydedildiyse sarı dolu ikon, değilse beyaz boş ikon
          project.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          color: project.isSaved ? const Color(0xFFFACC15) : Colors.white,
        ),
        onPressed: () => ProjectsController.instance.toggleSave(project.id),
      ),
    );
  }
}


import 'package:flutter/foundation.dart';
import '../models/comment_model.dart';
import '../models/project_model.dart';

/// Girişim projelerinin iş mantığı ve durum yönetimini sağlayan Controller.
/// Dart & Flutter yerel reaktif ValueNotifier yapısını kullanır.
class ProjectsController {
  ProjectsController._();
  static final ProjectsController instance = ProjectsController._();

  /// Tüm projelerin listesi
  final ValueNotifier<List<ProjectModel>> projectsNotifier =
      ValueNotifier<List<ProjectModel>>(<ProjectModel>[]);

  /// Seçili kategori filtresi
  final ValueNotifier<String> selectedCategoryNotifier =
      ValueNotifier<String>('Tümü');

  /// Dinamik kategoriler listesi (Kullanıcı kendi belirlediği kategoriyi ekleyebilir)
  final ValueNotifier<List<String>> categoriesNotifier =
      ValueNotifier<List<String>>(<String>[
    'Tümü',
    'Yeşil Enerji',
    'Sağlık',
    'Eğitim',
    'Fintek',
    'Teknoloji',
  ]);

  /// Seçili sıralama filtresi ('Popüler', 'Yeni Eklenen', 'En Çok Desteklenen')
  final ValueNotifier<String> selectedSortNotifier =
      ValueNotifier<String>('Popüler');

  /// Arama sorgusu
  final ValueNotifier<String> searchQueryNotifier = ValueNotifier<String>('');

  /// Filtrelenmiş ve sıralanmış projeleri tutan notifier
  final ValueNotifier<List<ProjectModel>> filteredProjectsNotifier =
      ValueNotifier<List<ProjectModel>>(<ProjectModel>[]);

  /// Başlangıç verilerini yükle
  void initialize() {
    if (projectsNotifier.value.isNotEmpty) return;

    final List<ProjectModel> initialProjects = <ProjectModel>[
      ProjectModel(
        id: 'p1',
        title: 'SolarDrone: Güneş Enerjili Otonom Tarım Dronu',
        tagline:
            'Güneş enerjisiyle kesintisiz uçarak tarım arazilerini analiz eden otonom drone sistemi.',
        description:
            'SolarDrone, hafif gövde üstü esnek fotovoltaik panelleri ile havada şarj olabilen, multispektral kameraları sayesinde tarım alanlarında bitki sağlığını, su stresini ve gübre ihtiyacını yapay zeka ile tespit eden yerli bir tarım teknolojisi projesidir.',
        creatorName: 'Emre Çelik & Selin Kaya',
        creatorRole: 'Havacılık & Yazılım Mühendisleri',
        category: 'Yeşil Enerji',
        imageUrl:
            'https://images.unsplash.com/photo-1527977966376-1c8408f9f108?w=800&auto=format&fit=crop&q=80',
        videoUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
        targetFunding: 250000.0,
        currentFunding: 187500.0,
        supportersCount: 142,
        likesCount: 389,
        isLiked: false,
        isSaved: true,
        tags: const <String>['Otonom', 'Güneş Enerjisi', 'TarımTek', 'Yapay Zekâ'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        comments: <CommentModel>[
          CommentModel(
            id: 'c1',
            authorName: 'Dr. Mehmet Aksoy',
            authorTitle: 'Ziraat Mühendisi',
            content:
                'Özellikle su stresini erken tespit etme kabiliyeti kuraklık döneminde devrim yaratabilir. Tebrikler!',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
            likesCount: 18,
          ),
          CommentModel(
            id: 'c2',
            authorName: 'Zeynep Yılmaz',
            authorTitle: 'Melek Yatırımcı',
            content:
                'Gövde rüzgar dayanıklılık testleri hangi rüzgar hızına kadar başarıyla tamamlandı?',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            likesCount: 6,
          ),
        ],
      ),
      ProjectModel(
        id: 'p2',
        title: 'BiyoPaket: %100 Deniz Yosunundan Çözünür Ambalaj',
        tagline:
            'Plastiğe son! Doğada 4 haftada tamamen çözünen ve deniz canlılarına besin olan biyolojik ambalaj.',
        description:
            'BiyoPaket, kıyı ekosistemlerinden sürdürülebilir yöntemle toplanan deniz yosunlarından üretilen biyo-polimer ambalaj çözümüdür. Gıda güvenliğine %100 uygun olup sıcak suda dahi toksik kalıntı bırakmaz.',
        creatorName: 'Derya Şahin',
        creatorRole: 'Biyomühendis & Kurucu',
        category: 'Yeşil Enerji',
        imageUrl:
            'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&auto=format&fit=crop&q=80',
        targetFunding: 180000.0,
        currentFunding: 162000.0,
        supportersCount: 230,
        likesCount: 512,
        isLiked: true,
        isSaved: false,
        tags: const <String>['Sıfır Atık', 'Biyoteknoloji', 'Sürdürülebilirlik'],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        comments: <CommentModel>[
          CommentModel(
            id: 'c3',
            authorName: 'Barış Koç',
            authorTitle: 'Endüstriyel Tasarımcı',
            content: 'Örnek numuneleri restoran paket servislerinde denemek isteriz.',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
            likesCount: 12,
          ),
        ],
      ),
      ProjectModel(
        id: 'p3',
        title: 'AkıllıTeşhis: Taşınabilir Retinopati Erken Tanı Kiti',
        tagline:
            'Akıllı telefon aparatıyla göz dibi fotoğrafı çekip saniyeler içinde diyabetik retinopatiyi tarayan yapay zeka.',
        description:
            'Sağlık ocaklarında ve kırsal alanlarda uzman hekim eksikliğini gidermek amacıyla geliştirilmiş kompakt optik aparat ve derin öğrenme modelimiz ile erken evre görme kaybı önleniyor.',
        creatorName: 'Dr. Caner Öztürk & Ali Demir',
        creatorRole: 'Göz Hastalıkları Uzmanı & AI Araştırmacısı',
        category: 'Sağlık',
        imageUrl:
            'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&auto=format&fit=crop&q=80',
        targetFunding: 400000.0,
        currentFunding: 320000.0,
        supportersCount: 310,
        likesCount: 740,
        isLiked: false,
        isSaved: true,
        tags: const <String>['SağlıkTek', 'Yapay Zekâ', 'Mobil Tanı', 'Derin Öğrenme'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        comments: <CommentModel>[
          CommentModel(
            id: 'c4',
            authorName: 'Prof. Dr. Aslı Kurt',
            authorTitle: 'Nöroloji',
            content: 'Klinik doğruluk test oranları %98 üzerinde ise Sağlık Bakanlığı onay sürecine girebilir.',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            likesCount: 24,
          ),
        ],
      ),
      ProjectModel(
        id: 'p4',
        title: 'KodÇocuk: Blokzincir & AR Tabanlı Eğitici Kodlama Kiti',
        tagline:
            '7-14 yaş grubu çocukların fiziksel bloklarla algoritma kurup artırılmış gerçeklikle canlandırdığı eğitim platformu.',
        description:
            'Çocuklar ekran bağımlısı olmadan elle tutulur mantık bloklarını birleştirir; tablet kamerasıyla baktıklarında kendi yazdıkları karakterlerin uzay görevlerini 3D AR dünyasında tamamladığını görür.',
        creatorName: 'Burcu Yurtseven',
        creatorRole: 'Eğitim Teknoloğu',
        category: 'Eğitim',
        imageUrl:
            'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800&auto=format&fit=crop&q=80',
        targetFunding: 120000.0,
        currentFunding: 95000.0,
        supportersCount: 185,
        likesCount: 295,
        isLiked: false,
        isSaved: false,
        tags: const <String>['EdTech', 'AR', 'Çocuk Kodlama', 'STEM'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        comments: const <CommentModel>[],
      ),
      ProjectModel(
        id: 'p5',
        title: 'FinRotam: KOBİ’ler İçin Nakit Akışı Tahminleme Robotu',
        tagline:
            'Açık bankacılık entegrasyonu ile küçük işletmelerin 90 günlük nakit akışını tahminleyen yapay zeka CFO.',
        description:
            'Tüm banka hesaplarını, fatura ve çek hareketlerini tek ekranda toplayan FinRotam, gelir-gider dengesini analiz ederek olası nakit darboğazlarını haftalar öncesinden haber verir.',
        creatorName: 'Kaan Erdem & Mert Ak',
        creatorRole: 'Finans Analisti & Fullstack Geliştirici',
        category: 'Fintek',
        imageUrl:
            'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&auto=format&fit=crop&q=80',
        targetFunding: 300000.0,
        currentFunding: 110000.0,
        supportersCount: 88,
        likesCount: 178,
        isLiked: false,
        isSaved: false,
        tags: const <String>['Fintek', 'Açık Bankacılık', 'KOBİ', 'Yapay Zekâ'],
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
        comments: const <CommentModel>[],
      ),
    ];

    projectsNotifier.value = initialProjects;
    _updateFilteredProjects();
  }

  /// Kategori seçimini güncelle
  void setCategory(String category) {
    selectedCategoryNotifier.value = category;
    _updateFilteredProjects();
  }

  /// Sıralama tercihini güncelle
  void setSort(String sort) {
    selectedSortNotifier.value = sort;
    _updateFilteredProjects();
  }

  /// Arama sorgusunu güncelle
  void setSearchQuery(String query) {
    searchQueryNotifier.value = query;
    _updateFilteredProjects();
  }

  /// Beğeni durumunu değiştir
  void toggleLike(String projectId) {
    final List<ProjectModel> currentList = projectsNotifier.value;
    final List<ProjectModel> updatedList = currentList.map((ProjectModel project) {
      if (project.id == projectId) {
        final bool newIsLiked = !project.isLiked;
        final int newCount =
            newIsLiked ? project.likesCount + 1 : project.likesCount - 1;
        return project.copyWith(
          isLiked: newIsLiked,
          likesCount: newCount < 0 ? 0 : newCount,
        );
      }
      return project;
    }).toList();

    projectsNotifier.value = updatedList;
    _updateFilteredProjects();
  }

  /// Kaydetme / Favori durumunu değiştir
  void toggleSave(String projectId) {
    final List<ProjectModel> currentList = projectsNotifier.value;
    final List<ProjectModel> updatedList = currentList.map((ProjectModel project) {
      if (project.id == projectId) {
        return project.copyWith(isSaved: !project.isSaved);
      }
      return project;
    }).toList();

    projectsNotifier.value = updatedList;
    _updateFilteredProjects();
  }

  /// Projeye destek / bağış ekle
  void addSupport(String projectId, double amount) {
    final List<ProjectModel> currentList = projectsNotifier.value;
    final List<ProjectModel> updatedList = currentList.map((ProjectModel project) {
      if (project.id == projectId) {
        return project.copyWith(
          currentFunding: project.currentFunding + amount,
          supportersCount: project.supportersCount + 1,
        );
      }
      return project;
    }).toList();

    projectsNotifier.value = updatedList;
    _updateFilteredProjects();
  }

  /// Projeye yeni yorum ekle
  void addComment(String projectId, String authorName, String content) {
    if (content.trim().isEmpty) return;

    final CommentModel newComment = CommentModel(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName.isEmpty ? 'Girişimci Destekçisi' : authorName,
      authorTitle: 'Topluluk Üyesi',
      content: content.trim(),
      createdAt: DateTime.now(),
    );

    final List<ProjectModel> currentList = projectsNotifier.value;
    final List<ProjectModel> updatedList = currentList.map((ProjectModel project) {
      if (project.id == projectId) {
        return project.copyWith(
          comments: <CommentModel>[newComment, ...project.comments],
        );
      }
      return project;
    }).toList();

    projectsNotifier.value = updatedList;
    _updateFilteredProjects();
  }

  /// Yeni kategori ekle (Kullanıcı tarafından belirlenen özel kategori)
  void addCategory(String category) {
    final String trimmed = category.trim();
    if (trimmed.isEmpty) return;

    final List<String> current = categoriesNotifier.value;
    final bool alreadyExists = current.any(
      (String c) => c.toLowerCase() == trimmed.toLowerCase(),
    );

    if (!alreadyExists) {
      categoriesNotifier.value = <String>[...current, trimmed];
    }
  }

  /// Yeni proje oluştur ve ekle
  void addNewProject(ProjectModel newProject) {
    addCategory(newProject.category);
    projectsNotifier.value = <ProjectModel>[newProject, ...projectsNotifier.value];
    _updateFilteredProjects();
  }

  /// Filtre ve sıralama kurallarını uygula
  void _updateFilteredProjects() {
    final String category = selectedCategoryNotifier.value;
    final String query = searchQueryNotifier.value.toLowerCase().trim();
    final String sort = selectedSortNotifier.value;

    List<ProjectModel> filtered = projectsNotifier.value.where((ProjectModel p) {
      final bool matchesCategory =
          category == 'Tümü' || p.category.toLowerCase() == category.toLowerCase();
      final bool matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query) ||
          p.creatorName.toLowerCase().contains(query) ||
          p.tags.any((String tag) => tag.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();

    // Sıralama
    if (sort == 'Popüler') {
      filtered.sort((ProjectModel a, ProjectModel b) =>
          b.likesCount.compareTo(a.likesCount));
    } else if (sort == 'Yeni Eklenen') {
      filtered.sort((ProjectModel a, ProjectModel b) =>
          b.createdAt.compareTo(a.createdAt));
    } else if (sort == 'En Çok Desteklenen') {
      filtered.sort((ProjectModel a, ProjectModel b) =>
          b.supportersCount.compareTo(a.supportersCount));
    }

    filteredProjectsNotifier.value = filtered;
  }
}

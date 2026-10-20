import 'package:flutter/material.dart';
import '../controllers/projects_controller.dart';
import '../models/project_model.dart';

/// Yeni bir girişim projesi ve tanıtım videosu/görseli paylaşma formu ekranı.
/// Kullanıcının kendi belirlediği kategoriyi girebilmesine tam destek verir.
class CreateProjectView extends StatefulWidget {
  const CreateProjectView({super.key});

  @override
  State<CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<CreateProjectView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _taglineCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _targetCtrl = TextEditingController();
  final TextEditingController _imageCtrl = TextEditingController();
  final TextEditingController _videoCtrl = TextEditingController();
  final TextEditingController _creatorCtrl = TextEditingController();
  final TextEditingController _tagsCtrl = TextEditingController();
  final TextEditingController _customCategoryCtrl = TextEditingController();

  String _selectedCategory = 'Yeşil Enerji';
  bool _isCustomCategory = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    _descCtrl.dispose();
    _targetCtrl.dispose();
    _imageCtrl.dispose();
    _videoCtrl.dispose();
    _creatorCtrl.dispose();
    _tagsCtrl.dispose();
    _customCategoryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Girişim Paylaş')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _BasicInfoSection(
              titleCtrl: _titleCtrl,
              taglineCtrl: _taglineCtrl,
              creatorCtrl: _creatorCtrl,
            ),
            const SizedBox(height: 16),
            _CategoryAndFundingSection(
              selectedCategory: _selectedCategory,
              isCustomCategory: _isCustomCategory,
              customCategoryCtrl: _customCategoryCtrl,
              onCategoryChanged: _onCategoryChanged,
              targetCtrl: _targetCtrl,
            ),
            const SizedBox(height: 16),
            _MediaAndTagsSection(
              imageCtrl: _imageCtrl,
              videoCtrl: _videoCtrl,
              tagsCtrl: _tagsCtrl,
              descCtrl: _descCtrl,
            ),
            const SizedBox(height: 24),
            _SubmitButton(onPressed: _submit),
          ],
        ),
      ),
    );
  }

  void _onCategoryChanged(String val) {
    setState(() {
      _selectedCategory = val;
      _isCustomCategory = val == '__CUSTOM__';
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final String finalCategory = _isCustomCategory
        ? _customCategoryCtrl.text.trim()
        : _selectedCategory;

    final double target = double.tryParse(_targetCtrl.text.trim()) ?? 100000.0;
    final String image = _imageCtrl.text.trim().isNotEmpty
        ? _imageCtrl.text.trim()
        : 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800&auto=format&fit=crop&q=80';

    final List<String> tags = _tagsCtrl.text
        .split(',')
        .map((String e) => e.trim())
        .where((String e) => e.isNotEmpty)
        .toList();

    final ProjectModel newProject = ProjectModel(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      tagline: _taglineCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      creatorName: _creatorCtrl.text.trim().isEmpty ? 'Girişimci Kurucu' : _creatorCtrl.text.trim(),
      creatorRole: 'Kurucu Ortak',
      category: finalCategory,
      imageUrl: image,
      videoUrl: _videoCtrl.text.trim().isNotEmpty ? _videoCtrl.text.trim() : null,
      targetFunding: target,
      currentFunding: 0.0,
      supportersCount: 0,
      tags: tags.isEmpty ? <String>['YeniGirişim', 'İnovasyon'] : tags,
      createdAt: DateTime.now(),
    );

    ProjectsController.instance.addNewProject(newProject);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$finalCategory" kategorisindeki girişiminiz paylaşıldı! 🚀'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _BasicInfoSection extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController taglineCtrl;
  final TextEditingController creatorCtrl;

  const _BasicInfoSection({
    required this.titleCtrl,
    required this.taglineCtrl,
    required this.creatorCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Girişim / Proje Adı *'),
          validator: (String? v) =>
              (v == null || v.trim().isEmpty) ? 'Lütfen proje adını girin' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: taglineCtrl,
          decoration: const InputDecoration(labelText: 'Kısa Slogan / Özet *'),
          validator: (String? v) =>
              (v == null || v.trim().isEmpty) ? 'Lütfen kısa slogan girin' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: creatorCtrl,
          decoration: const InputDecoration(labelText: 'Kurucu / Takım Adı *'),
          validator: (String? v) =>
              (v == null || v.trim().isEmpty) ? 'Lütfen kurucu adını girin' : null,
        ),
      ],
    );
  }
}

class _CategoryAndFundingSection extends StatelessWidget {
  final String selectedCategory;
  final bool isCustomCategory;
  final TextEditingController customCategoryCtrl;
  final ValueChanged<String> onCategoryChanged;
  final TextEditingController targetCtrl;

  const _CategoryAndFundingSection({
    required this.selectedCategory,
    required this.isCustomCategory,
    required this.customCategoryCtrl,
    required this.onCategoryChanged,
    required this.targetCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> available = ProjectsController.instance.categoriesNotifier.value
        .where((String c) => c != 'Tümü')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          decoration: const InputDecoration(labelText: 'Kategori Seçimi'),
          items: <DropdownMenuItem<String>>[
            ...available.map((String c) => DropdownMenuItem<String>(value: c, child: Text(c))),
            const DropdownMenuItem<String>(
              value: '__CUSTOM__',
              child: Text('+ Kendi Kategorini Belirle / Yaz...'),
            ),
          ],
          onChanged: (String? v) {
            if (v != null) onCategoryChanged(v);
          },
        ),
        if (isCustomCategory) ...<Widget>[
          const SizedBox(height: 12),
          TextFormField(
            controller: customCategoryCtrl,
            decoration: const InputDecoration(
              labelText: 'Kendi Belirlediğiniz Kategori *',
              hintText: 'Örn: Biyoteknoloji, Yapay Zekâ, Uzay...',
            ),
            validator: (String? v) =>
                (v == null || v.trim().isEmpty) ? 'Lütfen kategori adını yazın' : null,
          ),
        ],
        const SizedBox(height: 12),
        TextFormField(
          controller: targetCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Hedef Fon (₺) *'),
          validator: (String? v) =>
              (v == null || v.trim().isEmpty) ? 'Lütfen hedef fon miktarını girin' : null,
        ),
      ],
    );
  }
}

class _MediaAndTagsSection extends StatelessWidget {
  final TextEditingController imageCtrl;
  final TextEditingController videoCtrl;
  final TextEditingController tagsCtrl;
  final TextEditingController descCtrl;

  const _MediaAndTagsSection({
    required this.imageCtrl,
    required this.videoCtrl,
    required this.tagsCtrl,
    required this.descCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: imageCtrl,
          decoration: const InputDecoration(labelText: 'Kapak Görseli URL'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: videoCtrl,
          decoration: const InputDecoration(labelText: 'Tanıtım Videosu Linki (Opsiyonel)'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: tagsCtrl,
          decoration: const InputDecoration(labelText: 'Etiketler (Virgülle ayırın)'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: descCtrl,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Detaylı Proje Hikayesi *'),
          validator: (String? v) =>
              (v == null || v.trim().isEmpty) ? 'Lütfen proje hikayesini yazın' : null,
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.rocket_launch_rounded),
        label: const Text('Girişimi Yayınla & Destek Topla'),
      ),
    );
  }
}

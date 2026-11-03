import 'package:flutter/material.dart';
import '../../calendar/widgets/selected_day_preview_widget.dart';
import '../../mood/controllers/mood_controller.dart';
import '../../mood/widgets/mood_selector_widget.dart';
import '../controllers/diary_controller.dart';
import '../models/diary_entry.dart';

/// Günlük yazma ve düzenleme ekranı.
// StatefulWidget: metin girişi, ruh hâli seçimi ve kayıt durumlarını yöneten düzenleme sayfası
class DiaryEditorPage extends StatefulWidget {
  final DateTime date;
  final DiaryController diaryController;

  const DiaryEditorPage({
    super.key,
    required this.date,
    required this.diaryController,
  });

  @override
  State<DiaryEditorPage> createState() => _DiaryEditorPageState();
}

class _DiaryEditorPageState extends State<DiaryEditorPage> {
  // late: controller'ların initState içinde başlatılacağını belirtir
  late final TextEditingController _textController;
  late final MoodController _moodController;
  DiaryEntry? _existingEntry;

  @override
  // initState: sayfaya girildiğinde o tarihe ait var olan kaydı okuyup kutuya doldurur
  void initState() {
    super.initState();
    _existingEntry = widget.diaryController.getEntry(widget.date);
    _textController = TextEditingController(text: _existingEntry?.content ?? '');
    _moodController = MoodController(_existingEntry?.moodEmoji);
  }

  @override
  // dispose: sayfa kapandığında controller kaynaklarını serbest bırakır (bellek sızıntısını önler)
  void dispose() {
    _textController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  // günlüğü doğrulayıp kaydeden metot
  void _save() {
    final text = _textController.text;
    if (text.trim().isEmpty) {
      // ScaffoldMessenger: boş metin girildiğinde kullanıcıya uyarı çubuğu gösterir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Günlük metni boş bırakılamaz. Lütfen bir şeyler yazın.'),
          backgroundColor: Colors.redAccent,
          // SnackBarBehavior.floating: bildirimi alta yapıştırmayıp havada tutar
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    widget.diaryController.saveEntry(
      date: widget.date,
      content: text,
      moodEmoji: _moodController.selectedMood,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Günlüğünüz başarıyla kaydedildi ✨'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigator.pop: kayıt sonrası önceki takvim ekranına döner
    Navigator.of(context).pop();
  }

  // günlüğü silmeden önce kullanıcıdan onay isteyen asenkron diyalog metodu
  Future<void> _confirmDelete() async {
    // showDialog: ekrana onay açılır penceresi getirir
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Günlüğü Sil'),
        content: const Text('Bu tarihe ait günlüğü silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    // mounted: diyalog kapandıktan sonra widget'ın hâlâ ekranda olup olmadığını kontrol eder (hata önler)
    if (confirmed == true && mounted) {
      widget.diaryController.deleteEntry(widget.date);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = SelectedDayPreviewWidget.formatDate(widget.date);

    // Scaffold: sayfanın temel iskeletini oluşturur
    return Scaffold(
      appBar: AppBar(
        // var olan kayıt varsa düzenleme, yoksa yeni günlük başlığı koyar
        title: Text(_existingEntry != null ? 'Günlüğü Düzenle' : 'Yeni Günlük'),
        actions: [
          if (_existingEntry != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Günlüğü Sil',
              onPressed: _confirmDelete,
            ),
        ],
      ),
      // SafeArea: çentik ve alt navigasyon alanlarının formla çakışmasını engeller
      body: SafeArea(
        // SingleChildScrollView: klavye açıldığında formun yukarı kaydırılabilmesini sağlar
        child: SingleChildScrollView(
          // EdgeInsets.all: tüm kenarlardan 20 birim boşluk bırakır
          padding: const EdgeInsets.all(20),
          // Column: tarih rozeti, ruh hâli seçimi ve metin kutusunu dikeyde dizer
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateBadge(formattedDate: formattedDate),
              // SizedBox: araya dikeyde 20 birim sabit boşluk bırakır
              const SizedBox(height: 20),
              _MoodSection(moodController: _moodController),
              const SizedBox(height: 20),
              _EditorField(controller: _textController),
              const SizedBox(height: 24),
              _SaveButton(onSave: _save),
            ],
          ),
        ),
      ),
    );
  }
}

// günün tarihini şık bir kutu içinde gösteren rozet widget'ı
class _DateBadge extends StatelessWidget {
  final String formattedDate;

  const _DateBadge({required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          // Expanded: metnin kutunun kalan tüm genişliğini doldurmasını sağlar
          Expanded(
            child: Text(
              formattedDate,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ruh hâli seçim başlığı ve emojilerini toplayan yardımcı widget
class _MoodSection extends StatelessWidget {
  final MoodController moodController;

  const _MoodSection({required this.moodController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bugün nasıl hissediyorsun? (İsteğe bağlı)',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        MoodSelectorWidget(moodController: moodController),
      ],
    );
  }
}

// günlük metninin yazıldığı çok satırlı metin kutusu
class _EditorField extends StatelessWidget {
  final TextEditingController controller;

  const _EditorField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // maxLines ve minLines: kutunun çok satırlı günlük formatında geniş durmasını sağlar
      maxLines: 12,
      minLines: 8,
      // textCapitalization: her cümlenin ilk harfini otomatik büyük başlatır
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        hintText: 'Sevgili Günlük, bugün...',
        // alignLabelWithHint: çok satırlı girişlerde ipucu metnini en üste hizalar
        alignLabelWithHint: true,
      ),
    );
  }
}

// günlüğü kaydeden geniş buton
class _SaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const _SaveButton({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onSave,
        icon: const Icon(Icons.check_circle_outline, size: 22),
        label: const Text('Günlüğü Kaydet', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}


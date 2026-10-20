import 'package:flutter/material.dart';
import '../../calendar/widgets/selected_day_preview_widget.dart';
import '../../mood/controllers/mood_controller.dart';
import '../../mood/widgets/mood_selector_widget.dart';
import '../controllers/diary_controller.dart';
import '../models/diary_entry.dart';

/// Günlük yazma ve düzenleme ekranı.
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
  late final TextEditingController _textController;
  late final MoodController _moodController;
  DiaryEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    _existingEntry = widget.diaryController.getEntry(widget.date);
    _textController = TextEditingController(text: _existingEntry?.content ?? '');
    _moodController = MoodController(_existingEntry?.moodEmoji);
  }

  @override
  void dispose() {
    _textController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  void _save() {
    final text = _textController.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Günlük metni boş bırakılamaz. Lütfen bir şeyler yazın.'),
          backgroundColor: Colors.redAccent,
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

    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
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

    if (confirmed == true && mounted) {
      widget.diaryController.deleteEntry(widget.date);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = SelectedDayPreviewWidget.formatDate(widget.date);

    return Scaffold(
      appBar: AppBar(
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateBadge(formattedDate: formattedDate),
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

class _EditorField extends StatelessWidget {
  final TextEditingController controller;

  const _EditorField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 12,
      minLines: 8,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        hintText: 'Sevgili Günlük, bugün...',
        alignLabelWithHint: true,
      ),
    );
  }
}

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

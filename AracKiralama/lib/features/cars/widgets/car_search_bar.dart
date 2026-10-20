import 'dart:async';
import 'package:flutter/material.dart';

/// Araç arama çubuğu ve filtre tetikleme butonu.
/// Her tuş vuruşunda listenin anında yeniden çizilerek klavyede kasma yapmasını
/// önlemek amacıyla 250ms debounce (gecikmeli tetikleme) mekanizması içerir.
class CarSearchBar extends StatefulWidget {
  const CarSearchBar({
    required this.onChanged,
    required this.onFilterTap,
    super.key,
  });

  /// Arama sorgusu değiştiğinde debounce sonrası tetiklenen geri çağırım.
  final ValueChanged<String> onChanged;

  /// Filtre penceresini açan buton tıklaması.
  final VoidCallback onFilterTap;

  @override
  State<CarSearchBar> createState() => _CarSearchBarState();
}

class _CarSearchBarState extends State<CarSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Klavyeden girilen her harfte gereksiz hesaplama ve liste çizimini önlemek için
  /// 250 milisaniyelik zamanlayıcı kullanır.
  void _onTextChange(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      widget.onChanged(value);
    });
  }

  void _clearSearch() {
    _controller.clear();
    _debounceTimer?.cancel();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            onChanged: (String val) {
              _onTextChange(val);
              setState(() {}); // Temizle ikonunun görünürlüğünü güncelle
            },
            onTapOutside: (_) => _focusNode.unfocus(),
            decoration: InputDecoration(
              hintText: 'Marka veya model ara (örn. BMW, Tesla)',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: _clearSearch,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: widget.onFilterTap,
          icon: const Icon(Icons.tune_rounded),
          tooltip: 'Filtreler',
        ),
      ],
    );
  }
}

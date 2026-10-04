import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onFilterTap,
    this.hasActiveFilters = false,
    this.controller,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;
      if (hasText != _showClear) {
        setState(() => _showClear = hasText);
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14, right: 8),
            child: Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                filled: false,
              ),
            ),
          ),
          if (_showClear)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
              onPressed: () {
                _controller.clear();
                widget.onChanged('');
              },
            ),
          if (widget.onFilterTap != null) ...[
            Container(
              height: 24,
              width: 1,
              color: AppColors.border,
            ),
            IconButton(
              icon: Icon(
                widget.hasActiveFilters
                    ? Icons.filter_alt_rounded
                    : Icons.filter_alt_outlined,
                color: widget.hasActiveFilters
                    ? AppColors.emergencyRed
                    : AppColors.textSecondary,
                size: 20,
              ),
              onPressed: widget.onFilterTap,
            ),
          ],
        ],
      ),
    );
  }
}

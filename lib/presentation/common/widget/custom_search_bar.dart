import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/theme/noodle_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    this.onClear,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _showClear = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_updateClearButton);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButton);
    super.dispose();
  }

  void _updateClearButton() {
    final shouldShow = widget.controller.text.isNotEmpty;
    if (_showClear != shouldShow) {
      setState(() {
        _showClear = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: NoodleColors.neutral300,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NoodleColors.neutral500),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: NoodleColors.neutral800),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child:
                _showClear && widget.onClear != null
                    ? IconButton(
                      key: const Key('clear_button'),
                      onPressed: widget.onClear,
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: NoodleColors.neutral100,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: NoodleColors.neutral600,
                        shape: const CircleBorder(),
                      ),
                    )
                    : const SizedBox.shrink(key: Key('empty_clear')),
          ),
        ],
      ),
    );
  }
}
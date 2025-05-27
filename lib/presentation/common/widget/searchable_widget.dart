import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/widget/custom_search_bar.dart';

class SearchableWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearch;
  final Widget child;

  const SearchableWidget({
    super.key,
    required this.hintText,
    required this.onSearch,
    required this.child,
  });

  @override
  State<SearchableWidget> createState() => _SearchableWidgetState();
}

class _SearchableWidgetState extends State<SearchableWidget> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onSearch(value.trim());
  }

  void _onClear() {
    _searchController.clear();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSearchBar(
          hintText: widget.hintText,
          controller: _searchController,
          onChanged: _onChanged,
          onClear: _onClear,
        ),
        const SizedBox(height: 12),
        Expanded(child: widget.child),
      ],
    );
  }
}
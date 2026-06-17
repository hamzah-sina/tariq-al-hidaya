import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/models.dart';
import '../../../services/app_data.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedCategory = 'الكل';

  List<String> get _categories =>
      ['الكل', ...{...AppData.library.map((l) => l.category)}];

  List<LibraryItem> get _filtered => _selectedCategory == 'الكل'
      ? AppData.library
      : AppData.library.where((l) => l.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المكتبة')),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(AppColors.primaryLight)
                          : const Color(AppColors.surface),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(AppColors.primaryLight)
                            : const Color(AppColors.textHint),
                      ),
                    ),
                    child: Center(
                      child: Text(cat,
                          style: TextStyle(
                            fontSize: 13,
                            color: selected ? Colors.white : const Color(AppColors.textSecondary),
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _LibraryCard(item: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryCard extends StatelessWidget {
  final LibraryItem item;
  const _LibraryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(AppColors.primaryLight).withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(AppColors.surfaceLight),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(item.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          textDirection: TextDirection.rtl),
                      Text(item.author,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(AppColors.gold))),
                    ],
                  ),
                ),
                _TypeBadge(type: item.type),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(item.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                textDirection: TextDirection.rtl),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(AppColors.primaryLight).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(item.category,
                  style: const TextStyle(
                    fontSize: 11, color: Color(AppColors.primaryLight))),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final LibraryType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (type) {
      LibraryType.book => ('كتاب', const Color(AppColors.primaryLight)),
      LibraryType.article => ('مقالة', const Color(AppColors.gold)),
      LibraryType.video => ('فيديو', Colors.red),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
    );
  }
}

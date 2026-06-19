import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/hadith_models.dart';
import '../../../services/hadith_service.dart';

class HadithBookScreen extends StatefulWidget {
  final HadithBook book;
  const HadithBookScreen({super.key, required this.book});
  @override
  State<HadithBookScreen> createState() => _HadithBookScreenState();
}

class _HadithBookScreenState extends State<HadithBookScreen> {
  late Future<List<HadithItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = HadithService.loadBook(widget.book.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.titleArabic)),
      body: FutureBuilder<List<HadithItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final hadiths = snapshot.data!;
          if (hadiths.isEmpty) {
            return const Center(child: Text('لا توجد أحاديث في هذا الكتاب'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: hadiths.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final h = hadiths[i];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(AppColors.surface),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(AppColors.primaryLight).withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(AppColors.gold).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('حديث ${h.hadithNumber}',
                              style: const TextStyle(
                                  fontSize: 11, color: Color(AppColors.gold))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SelectableText(h.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.9),
                        textDirection: TextDirection.rtl),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

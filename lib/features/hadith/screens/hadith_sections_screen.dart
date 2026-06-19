import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/hadith_models.dart';
import '../../../services/hadith_service.dart';
import 'hadith_book_screen.dart';
import 'hadith_search_screen.dart';

class HadithSectionsScreen extends StatefulWidget {
  const HadithSectionsScreen({super.key});
  @override
  State<HadithSectionsScreen> createState() => _HadithSectionsScreenState();
}

class _HadithSectionsScreenState extends State<HadithSectionsScreen> {
  late Future<List<HadithBook>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = HadithService.loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صحيح مسلم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HadithSearchScreen())),
          ),
        ],
      ),
      body: FutureBuilder<List<HadithBook>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final books = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final book = books[i];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => HadithBookScreen(book: book))),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(AppColors.surface),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(AppColors.primaryLight).withOpacity(0.12)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: const Color(AppColors.primaryLight).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('${book.index}',
                              style: const TextStyle(
                                  color: Color(AppColors.primaryLight),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(book.titleArabic,
                            style: Theme.of(context).textTheme.titleMedium,
                            textDirection: TextDirection.rtl),
                      ),
                      const Icon(Icons.chevron_left, color: Color(AppColors.textHint)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

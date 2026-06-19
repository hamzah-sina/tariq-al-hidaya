import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hadith_models.dart';

class HadithService {
  static List<HadithItem>? _all;

  static Future<List<HadithItem>> loadAll() async {
    if (_all != null) return _all!;
    final raw = await rootBundle.loadString('assets/data/sahih_muslim.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final list = (data['hadiths'] as List)
        .map((h) => HadithItem.fromJson(h as Map<String, dynamic>))
        .where((h) => h.text.isNotEmpty)
        .toList();
    _all = list;
    return list;
  }

  static Future<List<HadithBook>> loadBooks() async {
    final all = await loadAll();
    final indices = {for (final h in all) h.bookIndex};
    final books = indices.map((i) => HadithBook(
          index: i,
          titleArabic: hadithBookTitlesArabic[i] ?? 'كتاب رقم $i',
        )).toList();
    books.sort((a, b) => a.index.compareTo(b.index));
    return books;
  }

  static Future<List<HadithItem>> loadBook(int bookIndex) async {
    final all = await loadAll();
    return all.where((h) => h.bookIndex == bookIndex).toList();
  }

  static Future<List<HadithItem>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final all = await loadAll();
    return all.where((h) => h.text.contains(query)).take(100).toList();
  }
}

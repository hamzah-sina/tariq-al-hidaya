import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/hadith_models.dart';
import '../../../services/hadith_service.dart';

class HadithSearchScreen extends StatefulWidget {
  const HadithSearchScreen({super.key});
  @override
  State<HadithSearchScreen> createState() => _HadithSearchScreenState();
}

class _HadithSearchScreenState extends State<HadithSearchScreen> {
  final _controller = TextEditingController();
  List<HadithItem> _results = [];
  bool _loading = false;

  Future<void> _search(String q) async {
    setState(() => _loading = true);
    final results = await HadithService.search(q);
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'بحث في صحيح مسلم...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onSubmitted: _search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _search(_controller.text),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? Center(
                  child: Text(
                    _controller.text.isEmpty ? 'اكتب كلمة للبحث' : 'لا نتائج',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final h = _results[i];
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
                          Text('حديث ${h.hadithNumber}',
                              style: const TextStyle(fontSize: 11, color: Color(AppColors.gold))),
                          const SizedBox(height: 8),
                          Text(h.text,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8),
                              textDirection: TextDirection.rtl),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

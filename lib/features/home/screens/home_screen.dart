import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers.dart';
import '../../../services/app_data.dart';
import '../../streak/widgets/streak_circle.dart';
import '../../emergency/screens/emergency_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakProvider);
    final quote = AppData.quotes[DateTime.now().day % AppData.quotes.length];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getGreeting(), style: Theme.of(context).textTheme.bodyMedium),
                    Text('طريق الهداية',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(AppColors.primaryLight),
                        )),
                  ],
                ),
                const Text('☪️', style: TextStyle(fontSize: 28)),
              ],
            ),
            const SizedBox(height: 24),

            streakAsync.when(
              data: (streak) => StreakCircle(streak: streak),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EmergencyScreen())),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(AppColors.danger).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(AppColors.danger).withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Text('🆘', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تحتاج مساعدة الآن؟',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('زر الطوارئ — اضغط الآن',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(AppColors.surface),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(AppColors.gold).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text('✨', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text('آية اليوم',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(AppColors.gold))),
                  ]),
                  const SizedBox(height: 12),
                  Text(quote.text,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.8),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl),
                  if (quote.source != null && quote.source!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('— ${quote.source}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(AppColors.gold).withOpacity(0.7))),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text('إجراء سريع',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(AppColors.textSecondary))),
            const SizedBox(height: 12),
            Row(
              children: [
                _QuickAction(emoji: '📿', label: 'ذكر', onTap: () => _showDhikr(context)),
                const SizedBox(width: 12),
                _QuickAction(
                    emoji: '🌬️',
                    label: 'تنفس',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const EmergencyScreen()))),
                const SizedBox(width: 12),
                _QuickAction(emoji: '💪', label: 'تمرين', onTap: () => _showExercise(context)),
                const SizedBox(width: 12),
                _QuickAction(emoji: '📖', label: 'قرآن', onTap: () => _showQuranTip(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح النور 🌅';
    if (hour < 17) return 'طاب نهارك ☀️';
    if (hour < 20) return 'مساء الخير 🌆';
    return 'مساء النور 🌙';
  }

  void _showDhikr(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(AppColors.surface),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const _DhikrSheet(),
    );
  }

  void _showExercise(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(AppColors.surface),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _InfoSheet(title: '💪 تمرين فوري', items: const [
        '20 ضغطة على الأرض',
        '30 قرفصاء',
        'امشِ في الغرفة 5 دقائق',
        'اخرج من البيت الآن',
      ]),
    );
  }

  void _showQuranTip(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(AppColors.surface),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _InfoSheet(title: '📖 افتح القرآن', items: const [
        'سورة الكهف — نور على نور',
        'سورة يوسف — قصة العفة',
        'سورة الفلق والناس — حصن من الشيطان',
        'آية الكرسي — 3 مرات',
      ]),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.emoji, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(AppColors.surface),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(AppColors.primaryLight).withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DhikrSheet extends StatefulWidget {
  const _DhikrSheet();
  @override
  State<_DhikrSheet> createState() => _DhikrSheetState();
}

class _DhikrSheetState extends State<_DhikrSheet> {
  int _count = 0;
  int _target = 33;
  String _dhikr = 'سُبْحَانَ اللَّهِ';

  final _dhikrList = const [
    ('سُبْحَانَ اللَّهِ', 33),
    ('الْحَمْدُ لِلَّهِ', 33),
    ('اللَّهُ أَكْبَرُ', 34),
    ('أَسْتَغْفِرُ اللَّهَ', 100),
    ('لَا إِلَٰهَ إِلَّا اللَّهُ', 100),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('📿 الذكر الفوري',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(AppColors.gold))),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: _dhikrList.map((d) {
              final selected = d.$1 == _dhikr;
              return GestureDetector(
                onTap: () => setState(() {
                  _dhikr = d.$1;
                  _target = d.$2;
                  _count = 0;
                }),
                child: Chip(
                  label: Text(d.$1, style: const TextStyle(fontSize: 12)),
                  backgroundColor: selected
                      ? const Color(AppColors.primaryLight)
                      : const Color(AppColors.surfaceLight),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => setState(() { if (_count < _target) _count++; }),
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(AppColors.primaryLight).withOpacity(0.15),
                border: Border.all(color: const Color(AppColors.primaryLight), width: 3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$_count',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: const Color(AppColors.primaryLight), fontSize: 48)),
                  Text('/ $_target', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(_dhikr,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(AppColors.gold)),
              textAlign: TextAlign.center),
          if (_count >= _target) ...[
            const SizedBox(height: 16),
            const Text('✅ أحسنت! انتهيت', style: TextStyle(color: Colors.green, fontSize: 18)),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _InfoSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  const _InfoSheet({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(AppColors.primaryLight))),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Color(AppColors.primaryLight), size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyLarge)),
              ],
            ),
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

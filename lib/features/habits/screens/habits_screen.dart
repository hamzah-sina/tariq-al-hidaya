import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers.dart';
import '../../../models/habit_models.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  static const _allKeys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha', 'quran', 'dhikr'];
  static const _labels = {
    'fajr': 'الفجر', 'dhuhr': 'الظهر', 'asr': 'العصر',
    'maghrib': 'المغرب', 'isha': 'العشاء',
    'quran': '📖 القرآن', 'dhikr': '📿 الذكر',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(habitsHistoryProvider);
    final streaksAsync = ref.watch(habitStreaksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('العادات الإيجابية')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('السلاسل الحالية',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(AppColors.textSecondary))),
          const SizedBox(height: 10),
          streaksAsync.when(
            data: (streaks) => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _allKeys.map((k) {
                final days = streaks[k] ?? 0;
                return Container(
                  width: (MediaQuery.of(context).size.width - 16 * 2 - 10) / 2,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(AppColors.surface),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(AppColors.primaryLight).withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_labels[k]!,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Text('$days',
                          style: const TextStyle(
                              color: Color(AppColors.gold),
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Text('يوم', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                );
              }).toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 28),
          Text('آخر ٣٥ يوماً',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(AppColors.textSecondary))),
          const SizedBox(height: 10),

          historyAsync.when(
            data: (history) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(AppColors.surface),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  // Header row with habit initials
                  Row(
                    children: [
                      const SizedBox(width: 60),
                      ..._allKeys.map((k) => Expanded(
                            child: Center(
                              child: Text(
                                k == 'quran' ? '📖' : k == 'dhikr' ? '📿' : _labels[k]![0],
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ...history.reversed.take(10).map((day) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                day.dateKey.substring(5),
                                style: const TextStyle(fontSize: 11,
                                    color: Color(AppColors.textHint)),
                              ),
                            ),
                            ..._allKeys.map((k) {
                              final done = k == 'quran'
                                  ? day.quran
                                  : k == 'dhikr'
                                      ? day.dhikr
                                      : (day.prayers[k] ?? false);
                              return Expanded(
                                child: Center(
                                  child: Container(
                                    width: 18, height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: done
                                          ? const Color(AppColors.primaryLight)
                                          : const Color(AppColors.surfaceLight),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

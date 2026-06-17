import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers.dart';
import '../../../models/models.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final triggerStats = ref.watch(triggerStatsProvider);
    final last30 = ref.watch(last30DaysProvider);
    final streakAsync = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إحصائياتي')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          streakAsync.when(
            data: (streak) => Row(
              children: [
                _SummaryCard(
                    value: '${streak.currentStreak}',
                    label: 'اليوم الحالي',
                    emoji: '🔥',
                    color: const Color(AppColors.primaryLight)),
                const SizedBox(width: 12),
                _SummaryCard(
                    value: '${streak.bestStreak}',
                    label: 'أفضل سجل',
                    emoji: '🏆',
                    color: const Color(AppColors.gold)),
                const SizedBox(width: 12),
                _SummaryCard(
                    value: '${streak.relapses.length}',
                    label: 'الانتكاسات',
                    emoji: '📊',
                    color: Colors.blueGrey),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          Text('الـ٣٠ يوم الماضية',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(AppColors.textSecondary))),
          const SizedBox(height: 12),
          last30.when(
            data: (days) => _CalendarGrid(days: days),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          Text('أسباب الانتكاسات',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(AppColors.textSecondary))),
          const SizedBox(height: 12),
          triggerStats.when(
            data: (stats) => stats.isEmpty ? const _EmptyStats() : _TriggerBars(stats: stats),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value, label, emoji;
  final Color color;
  const _SummaryCard({required this.value, required this.label, required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(AppColors.surface),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color, fontSize: 28)),
            Text(label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final List<int> days;
  const _CalendarGrid({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Legend(color: const Color(AppColors.primaryLight), label: 'يوم نظيف'),
              const SizedBox(width: 16),
              _Legend(color: const Color(AppColors.danger), label: 'انتكاسة'),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(30, (i) {
              final isClean = days[29 - i] == 1;
              return Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: isClean
                      ? const Color(AppColors.primaryLight).withOpacity(0.8)
                      : const Color(AppColors.danger).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(isClean ? '✓' : '✗',
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14, height: 14,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
      ],
    );
  }
}

class _TriggerBars extends StatelessWidget {
  final Map<String, int> stats;
  const _TriggerBars({required this.stats});

  @override
  Widget build(BuildContext context) {
    final sorted = stats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total = stats.values.fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: sorted.map((entry) {
          final trigger = TriggerCategory.defaults.firstWhere(
            (t) => t.id == entry.key,
            orElse: () => const TriggerCategory(id: '', name: 'أخرى', emoji: '❓'),
          );
          final percentage = entry.value / total;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${trigger.emoji} ${trigger.name}',
                        style: Theme.of(context).textTheme.bodyLarge),
                    Text('${entry.value}x (${(percentage * 100).round()}%)',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: const Color(AppColors.surfaceLight),
                  color: const Color(AppColors.primaryLight),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyStats extends StatelessWidget {
  const _EmptyStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('📊', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text('لا يوجد بيانات بعد', style: Theme.of(context).textTheme.titleMedium),
          Text('ستظهر الإحصائيات بعد تسجيل أول انتكاسة',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers.dart';
import '../../../models/models.dart';
import '../widgets/streak_circle.dart';

class StreakScreen extends ConsumerWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقدمي'),
        actions: [
          TextButton.icon(
            onPressed: () => _showRelapseDialog(context, ref),
            icon: const Icon(Icons.refresh, color: Color(AppColors.danger), size: 18),
            label: const Text('تسجيل انتكاسة', style: TextStyle(color: Color(AppColors.danger))),
          ),
        ],
      ),
      body: streakAsync.when(
        data: (streak) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            StreakCircle(streak: streak),
            const SizedBox(height: 24),
            if (streak.relapses.isNotEmpty) ...[
              Text('سجل الانتكاسات',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(AppColors.textSecondary))),
              const SizedBox(height: 12),
              ...streak.relapses.reversed.take(10).map((r) => _RelapseCard(relapse: r)),
            ] else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(AppColors.surface),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(AppColors.primaryLight).withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    const Text('🌟', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text('لم تُسجّل أي انتكاسة',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(AppColors.primaryLight))),
                    const SizedBox(height: 4),
                    Text('استمر على هذا النهج', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
      ),
    );
  }

  Future<void> _showRelapseDialog(BuildContext context, WidgetRef ref) async {
    String? selectedTrigger;
    final noteController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: const Color(AppColors.surface),
          title: const Text('تسجيل انتكاسة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ما الذي أشعل الإغراء؟', style: TextStyle(color: Colors.grey[400])),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: TriggerCategory.defaults.map((t) {
                  final selected = t.id == selectedTrigger;
                  return GestureDetector(
                    onTap: () => setState(() => selectedTrigger = t.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(AppColors.primaryLight)
                            : const Color(AppColors.surfaceLight),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${t.emoji} ${t.name}', style: const TextStyle(fontSize: 13)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                textDirection: TextDirection.rtl,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'ملاحظة (اختياري)...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(AppColors.danger)),
              onPressed: () async {
                Navigator.pop(ctx);
                await ref.read(streakProvider.notifier).recordRelapse(
                  selectedTrigger,
                  noteController.text.trim().isEmpty ? null : noteController.text,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ تم التسجيل — كل نهاية هي بداية جديدة')),
                  );
                }
              },
              child: const Text('تأكيد التسجيل'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelapseCard extends StatelessWidget {
  final RelapseRecord relapse;
  const _RelapseCard({required this.relapse});

  @override
  Widget build(BuildContext context) {
    final trigger = relapse.trigger != null
        ? TriggerCategory.defaults.firstWhere(
            (t) => t.id == relapse.trigger,
            orElse: () => const TriggerCategory(id: '', name: 'أخرى', emoji: '❓'),
          )
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(AppColors.danger).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(AppColors.danger).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(trigger?.emoji ?? '📅', style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trigger?.name ?? 'انتكاسة', style: Theme.of(context).textTheme.titleMedium),
                Text('كان السجل: ${relapse.streakBeforeRelapse} يوم • ${_formatDate(relapse.date)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
                if (relapse.note != null)
                  Text(relapse.note!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

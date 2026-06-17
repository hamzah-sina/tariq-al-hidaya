import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/models.dart';

class StreakCircle extends StatelessWidget {
  final StreakData streak;
  const StreakCircle({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final days = streak.currentStreak;
    final best = streak.bestStreak;
    final progress = best > 0 ? (days / best).clamp(0.0, 1.0) : 1.0;

    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 12,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                    const Color(AppColors.primaryLight).withOpacity(0.1),
                  ),
                ),
              ),
              // Progress circle
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation(
                    Color(AppColors.primaryLight),
                  ),
                ),
              ),
              // Inner content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$days',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: const Color(AppColors.primaryLight),
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.streakDays,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatBadge(
              label: 'أفضل سجل',
              value: '$best يوم',
              emoji: '🏆',
            ),
            const SizedBox(width: 16),
            _StatBadge(
              label: 'إجمالي المحاولات',
              value: '${streak.relapses.length}',
              emoji: '📊',
            ),
          ],
        ),
        const SizedBox(height: 12),
        _MilestoneRow(days: days),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(AppColors.primaryLight).withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Text('$emoji ${value}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(AppColors.gold),
              )),
          Text(label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11,
              )),
        ],
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  final int days;
  const _MilestoneRow({required this.days});

  static const milestones = [
    (1, '⭐', 'يوم واحد'),
    (7, '🌿', 'أسبوع'),
    (30, '🌙', 'شهر'),
    (90, '💎', '٣ أشهر'),
    (365, '👑', 'سنة'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: milestones.map((m) {
          final reached = days >= m.$1;
          return Column(
            children: [
              Text(
                m.$2,
                style: TextStyle(
                  fontSize: 22,
                  color: reached ? null : const Color(AppColors.textHint),
                ),
              ),
              Text(
                m.$3,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 10,
                  color: reached
                      ? const Color(AppColors.gold)
                      : const Color(AppColors.textHint),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

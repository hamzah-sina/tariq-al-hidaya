import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers.dart';
import '../../../services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifAsync = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: '🌿 عن التطبيق',
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('☪️', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('طريق الهداية',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(AppColors.primaryLight))),
                  const SizedBox(height: 8),
                  Text(
                    'كل يوم تصمد فيه هو خطوة نحو النقاء.\nاللهم أعنّا على ذكرك وشكرك وحسن عبادتك.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text('الإصدار ١.٠.٠',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(AppColors.textHint))),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _Section(
            title: '🔔 الإشعارات',
            child: notifAsync.when(
              data: (time) => Column(
                children: [
                  ListTile(
                    title: const Text('وقت التذكير اليومي'),
                    subtitle: Text(
                      '${time[0].toString().padLeft(2, '0')}:${time[1].toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Color(AppColors.primaryLight),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.access_time, color: Color(AppColors.primaryLight)),
                    onTap: () => _pickTime(context, ref, time),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('إرسال تذكير اختباري'),
                    trailing: const Icon(Icons.send, size: 18, color: Color(AppColors.textSecondary)),
                    onTap: () {
                      NotificationService.sendEmergencyNotification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إرسال الإشعار'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const SizedBox.shrink(),
            ),
          ),

          const SizedBox(height: 16),

          _Section(
            title: '💡 نصائح للنجاح',
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  _Tip(emoji: '🌙', text: 'ضع هاتفك خارج غرفة النوم ليلاً'),
                  _Tip(emoji: '🔒', text: 'فعّل فلاتر المحتوى على متصفحك'),
                  _Tip(emoji: '👥', text: 'أخبر شخصاً تثق به ليحاسبك'),
                  _Tip(emoji: '📖', text: 'اقرأ كتاباً قبل النوم بدل التصفح'),
                  _Tip(emoji: '🏃', text: 'مارس الرياضة يومياً'),
                  _Tip(emoji: '🤲', text: 'أكثر من الدعاء خاصةً في السحر'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref, List<int> currentTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentTime[0], minute: currentTime[1]),
    );
    if (picked != null) {
      await ref.read(notificationProvider.notifier).updateTime(picked.hour, picked.minute);
    }
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(AppColors.primaryLight))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(AppColors.surface),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(AppColors.primaryLight).withOpacity(0.12)),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _Tip extends StatelessWidget {
  final String emoji;
  final String text;
  const _Tip({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: TextDirection.rtl),
          ),
        ],
      ),
    );
  }
}

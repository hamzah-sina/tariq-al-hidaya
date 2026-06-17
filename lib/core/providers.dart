import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/data_service.dart';
import '../services/notification_service.dart';

final dataServiceProvider = Provider<DataService>((ref) => DataService());

// ─── Streak Provider ──────────────────────────────────────────────────────────

final streakProvider = AsyncNotifierProvider<StreakNotifier, StreakData>(
  StreakNotifier.new,
);

class StreakNotifier extends AsyncNotifier<StreakData> {
  @override
  Future<StreakData> build() async {
    return ref.read(dataServiceProvider).getStreak();
  }

  Future<void> recordRelapse(String? trigger, String? note) async {
    state = const AsyncLoading();
    final service = ref.read(dataServiceProvider);
    final updated = await service.recordRelapse(trigger, note);
    state = AsyncData(updated);
  }

  Future<void> refresh() async {
    state = AsyncData(await ref.read(dataServiceProvider).getStreak());
  }
}

// ─── Notification Provider ─────────────────────────────────────────────────────

final notificationProvider = AsyncNotifierProvider<NotificationNotifier, List<int>>(
  NotificationNotifier.new,
);

class NotificationNotifier extends AsyncNotifier<List<int>> {
  @override
  Future<List<int>> build() async {
    return ref.read(dataServiceProvider).getNotifTime();
  }

  Future<void> updateTime(int hour, int minute) async {
    final service = ref.read(dataServiceProvider);
    await service.setNotifTime(hour, minute);
    await NotificationService.scheduleDailyReminder(hour, minute);
    state = AsyncData([hour, minute]);
  }
}

// ─── Stats Provider ───────────────────────────────────────────────────────────

final triggerStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  ref.watch(streakProvider);
  return ref.read(dataServiceProvider).getTriggerStats();
});

final last30DaysProvider = FutureProvider<List<int>>((ref) async {
  ref.watch(streakProvider);
  return ref.read(dataServiceProvider).getLast30DaysStreak();
});

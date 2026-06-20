import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../models/habit_models.dart';
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

// ─── Positive Habits Provider ──────────────────────────────────────────────────

final todayHabitsProvider = AsyncNotifierProvider<TodayHabitsNotifier, DailyHabits>(
  TodayHabitsNotifier.new,
);

class TodayHabitsNotifier extends AsyncNotifier<DailyHabits> {
  @override
  Future<DailyHabits> build() async {
    return ref.read(dataServiceProvider).getHabitsFor(DateTime.now());
  }

  Future<void> togglePrayer(String key) async {
    final service = ref.read(dataServiceProvider);
    final updated = await service.togglePrayer(DateTime.now(), key);
    state = AsyncData(updated);
  }

  Future<void> toggleQuran() async {
    final service = ref.read(dataServiceProvider);
    final updated = await service.toggleQuran(DateTime.now());
    state = AsyncData(updated);
  }

  Future<void> toggleDhikr() async {
    final service = ref.read(dataServiceProvider);
    final updated = await service.toggleDhikr(DateTime.now());
    state = AsyncData(updated);
  }
}

final habitsHistoryProvider = FutureProvider<List<DailyHabits>>((ref) async {
  ref.watch(todayHabitsProvider);
  return ref.read(dataServiceProvider).getHabitsHistory(35);
});

final habitStreaksProvider = FutureProvider<Map<String, int>>((ref) async {
  ref.watch(todayHabitsProvider);
  final service = ref.read(dataServiceProvider);
  final keys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha', 'quran', 'dhikr'];
  final Map<String, int> result = {};
  for (final k in keys) {
    result[k] = await service.getHabitStreak(k);
  }
  return result;
});

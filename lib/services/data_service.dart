import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class DataService {
  static const _streakKey = 'streak_data';
  static const _notifTimeKey = 'notif_time';

  // ─── Streak ──────────────────────────────────────────────────────────────────

  Future<StreakData> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_streakKey);
    if (json == null) return StreakData.initial();
    return StreakData.fromJson(jsonDecode(json));
  }

  Future<void> saveStreak(StreakData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_streakKey, jsonEncode(data.toJson()));
  }

  Future<StreakData> recordRelapse(String? trigger, String? note) async {
    final current = await getStreak();
    final newRelapse = RelapseRecord(
      date: DateTime.now(),
      trigger: trigger,
      note: note,
      streakBeforeRelapse: current.currentStreak,
    );
    final newBest = current.currentStreak > current.bestStreak
        ? current.currentStreak
        : current.bestStreak;
    final updated = StreakData(
      startDate: DateTime.now(),
      bestStreak: newBest,
      relapses: [...current.relapses, newRelapse],
    );
    await saveStreak(updated);
    return updated;
  }

  // ─── Notification Time ───────────────────────────────────────────────────────

  Future<List<int>> getNotifTime() async {
    final prefs = await SharedPreferences.getInstance();
    return [
      prefs.getInt('${_notifTimeKey}_h') ?? 8,
      prefs.getInt('${_notifTimeKey}_m') ?? 0,
    ];
  }

  Future<void> setNotifTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_notifTimeKey}_h', hour);
    await prefs.setInt('${_notifTimeKey}_m', minute);
  }

  // ─── Stats ──────────────────────────────────────────────────────────────────

  Future<Map<String, int>> getTriggerStats() async {
    final streak = await getStreak();
    final Map<String, int> stats = {};
    for (final r in streak.relapses) {
      if (r.trigger != null) {
        stats[r.trigger!] = (stats[r.trigger!] ?? 0) + 1;
      }
    }
    return stats;
  }

  Future<List<int>> getLast30DaysStreak() async {
    final streak = await getStreak();
    final now = DateTime.now();
    final List<int> days = List.filled(30, 1); // 1 = clean day

    for (final r in streak.relapses) {
      final daysAgo = now.difference(r.date).inDays;
      if (daysAgo < 30) {
        days[daysAgo] = 0; // relapse day
      }
    }
    return days;
  }
}

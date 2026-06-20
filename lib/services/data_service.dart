import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../models/habit_models.dart';

class DataService {
  static const _streakKey = 'streak_data';
  static const _notifTimeKey = 'notif_time';
  static const _habitsKey = 'daily_habits';

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

  // ─── Positive Habits ────────────────────────────────────────────────────────

  Future<Map<String, DailyHabits>> _getAllHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_habitsKey);
    if (json == null) return {};
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return decoded.map(
      (k, v) => MapEntry(k, DailyHabits.fromJson(v as Map<String, dynamic>)),
    );
  }

  Future<void> _saveAllHabits(Map<String, DailyHabits> all) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = all.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_habitsKey, jsonEncode(encoded));
  }

  Future<DailyHabits> getHabitsFor(DateTime date) async {
    final key = dateKeyFor(date);
    final all = await _getAllHabits();
    return all[key] ?? DailyHabits.empty(key);
  }

  Future<DailyHabits> togglePrayer(DateTime date, String prayerKey) async {
    final all = await _getAllHabits();
    final key = dateKeyFor(date);
    final current = all[key] ?? DailyHabits.empty(key);
    final newPrayers = Map<String, bool>.from(current.prayers);
    newPrayers[prayerKey] = !(newPrayers[prayerKey] ?? false);
    final updated = current.copyWith(prayers: newPrayers);
    all[key] = updated;
    await _saveAllHabits(all);
    return updated;
  }

  Future<DailyHabits> toggleQuran(DateTime date) async {
    final all = await _getAllHabits();
    final key = dateKeyFor(date);
    final current = all[key] ?? DailyHabits.empty(key);
    final updated = current.copyWith(quran: !current.quran);
    all[key] = updated;
    await _saveAllHabits(all);
    return updated;
  }

  Future<DailyHabits> toggleDhikr(DateTime date) async {
    final all = await _getAllHabits();
    final key = dateKeyFor(date);
    final current = all[key] ?? DailyHabits.empty(key);
    final updated = current.copyWith(dhikr: !current.dhikr);
    all[key] = updated;
    await _saveAllHabits(all);
    return updated;
  }

  /// Returns the last [days] DailyHabits, oldest first.
  Future<List<DailyHabits>> getHabitsHistory(int days) async {
    final all = await _getAllHabits();
    final now = DateTime.now();
    return List.generate(days, (i) {
      final d = now.subtract(Duration(days: days - 1 - i));
      final key = dateKeyFor(d);
      return all[key] ?? DailyHabits.empty(key);
    });
  }

  /// Current consecutive-day streak for a single habit key.
  /// habitKey is one of: fajr, dhuhr, asr, maghrib, isha, quran, dhikr
  Future<int> getHabitStreak(String habitKey) async {
    final all = await _getAllHabits();
    final now = DateTime.now();
    int streak = 0;
    for (int i = 0; i < 3650; i++) {
      final d = now.subtract(Duration(days: i));
      final key = dateKeyFor(d);
      final entry = all[key];
      bool done;
      if (entry == null) {
        done = false;
      } else if (habitKey == 'quran') {
        done = entry.quran;
      } else if (habitKey == 'dhikr') {
        done = entry.dhikr;
      } else {
        done = entry.prayers[habitKey] ?? false;
      }
      if (!done) {
        // allow "today" to be incomplete without breaking the streak display
        if (i == 0) continue;
        break;
      }
      streak++;
    }
    return streak;
  }
}

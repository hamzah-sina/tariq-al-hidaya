// ─── Streak Model ───────────────────────────────────────────────────────────
class StreakData {
  final DateTime startDate;
  final int bestStreak;
  final List<RelapseRecord> relapses;

  const StreakData({
    required this.startDate,
    required this.bestStreak,
    required this.relapses,
  });

  int get currentStreak {
    final now = DateTime.now();
    final diff = now.difference(startDate);
    return diff.inDays;
  }

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(),
    'bestStreak': bestStreak,
    'relapses': relapses.map((r) => r.toJson()).toList(),
  };

  factory StreakData.fromJson(Map<String, dynamic> json) => StreakData(
    startDate: DateTime.parse(json['startDate']),
    bestStreak: json['bestStreak'] ?? 0,
    relapses: (json['relapses'] as List? ?? [])
        .map((r) => RelapseRecord.fromJson(r))
        .toList(),
  );

  factory StreakData.initial() => StreakData(
    startDate: DateTime.now(),
    bestStreak: 0,
    relapses: [],
  );
}

// ─── Relapse Record ──────────────────────────────────────────────────────────
class RelapseRecord {
  final DateTime date;
  final String? trigger;
  final String? note;
  final int streakBeforeRelapse;

  const RelapseRecord({
    required this.date,
    this.trigger,
    this.note,
    required this.streakBeforeRelapse,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'trigger': trigger,
    'note': note,
    'streakBeforeRelapse': streakBeforeRelapse,
  };

  factory RelapseRecord.fromJson(Map<String, dynamic> json) => RelapseRecord(
    date: DateTime.parse(json['date']),
    trigger: json['trigger'],
    note: json['note'],
    streakBeforeRelapse: json['streakBeforeRelapse'] ?? 0,
  );
}

// ─── Trigger Model ───────────────────────────────────────────────────────────
class TriggerCategory {
  final String id;
  final String name;
  final String emoji;

  const TriggerCategory({
    required this.id,
    required this.name,
    required this.emoji,
  });

  static const List<TriggerCategory> defaults = [
    TriggerCategory(id: 'lonely', name: 'وحدة', emoji: '😔'),
    TriggerCategory(id: 'bored', name: 'ملل', emoji: '😐'),
    TriggerCategory(id: 'stressed', name: 'ضغط نفسي', emoji: '😰'),
    TriggerCategory(id: 'night', name: 'سهر ليلي', emoji: '🌙'),
    TriggerCategory(id: 'phone', name: 'تصفح عشوائي', emoji: '📱'),
    TriggerCategory(id: 'social', name: 'محتوى مثير', emoji: '📸'),
    TriggerCategory(id: 'sad', name: 'حزن', emoji: '😢'),
    TriggerCategory(id: 'other', name: 'أخرى', emoji: '❓'),
  ];
}

// ─── Quote Model ─────────────────────────────────────────────────────────────
class IslamicQuote {
  final String text;
  final String? source;
  final QuoteType type;

  const IslamicQuote({
    required this.text,
    this.source,
    required this.type,
  });
}

enum QuoteType { quran, hadith, wisdom }

// ─── Library Item ─────────────────────────────────────────────────────────────
class LibraryItem {
  final String id;
  final String title;
  final String author;
  final String description;
  final String category;
  final String? url;
  final LibraryType type;
  final String emoji;

  const LibraryItem({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    this.url,
    required this.type,
    required this.emoji,
  });
}

enum LibraryType { book, article, video }

// ─── Alternative Activity ─────────────────────────────────────────────────────
class AlternativeActivity {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int durationMinutes;
  final ActivityCategory category;

  const AlternativeActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.durationMinutes,
    required this.category,
  });
}

enum ActivityCategory { physical, spiritual, mental, social }

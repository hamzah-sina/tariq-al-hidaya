class DailyHabits {
  final String dateKey; // format: yyyy-MM-dd
  final Map<String, bool> prayers; // fajr, dhuhr, asr, maghrib, isha
  final bool quran;
  final bool dhikr;

  const DailyHabits({
    required this.dateKey,
    required this.prayers,
    required this.quran,
    required this.dhikr,
  });

  factory DailyHabits.empty(String dateKey) => DailyHabits(
        dateKey: dateKey,
        prayers: const {
          'fajr': false,
          'dhuhr': false,
          'asr': false,
          'maghrib': false,
          'isha': false,
        },
        quran: false,
        dhikr: false,
      );

  DailyHabits copyWith({
    Map<String, bool>? prayers,
    bool? quran,
    bool? dhikr,
  }) => DailyHabits(
        dateKey: dateKey,
        prayers: prayers ?? this.prayers,
        quran: quran ?? this.quran,
        dhikr: dhikr ?? this.dhikr,
      );

  int get completedCount =>
      prayers.values.where((v) => v).length + (quran ? 1 : 0) + (dhikr ? 1 : 0);

  int get totalCount => prayers.length + 2;

  factory DailyHabits.fromJson(Map<String, dynamic> j) => DailyHabits(
        dateKey: j['dateKey'] as String,
        prayers: Map<String, bool>.from(j['prayers'] as Map),
        quran: (j['quran'] as bool?) ?? false,
        dhikr: (j['dhikr'] as bool?) ?? false,
      );

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'prayers': prayers,
        'quran': quran,
        'dhikr': dhikr,
      };
}

const Map<String, String> prayerNamesArabic = {
  'fajr': 'الفجر',
  'dhuhr': 'الظهر',
  'asr': 'العصر',
  'maghrib': 'المغرب',
  'isha': 'العشاء',
};

String dateKeyFor(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

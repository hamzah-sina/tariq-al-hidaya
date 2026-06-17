import '../models/models.dart';

class AppData {
  // ─── Islamic Quotes ────────────────────────────────────────────────────────

  static const List<IslamicQuote> quotes = [
    IslamicQuote(
      text: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
      source: 'الطلاق: ٢',
      type: QuoteType.quran,
    ),
    IslamicQuote(
      text: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
      source: 'البقرة: ١٥٣',
      type: QuoteType.quran,
    ),
    IslamicQuote(
      text: 'وَالَّذِينَ جَاهَدُوا فِينَا لَنَهْدِيَنَّهُمْ سُبُلَنَا',
      source: 'العنكبوت: ٦٩',
      type: QuoteType.quran,
    ),
    IslamicQuote(
      text: 'قُل لِّلْمُؤْمِنِينَ يَغُضُّوا مِنْ أَبْصَارِهِمْ وَيَحْفَظُوا فُرُوجَهُمْ',
      source: 'النور: ٣٠',
      type: QuoteType.quran,
    ),
    IslamicQuote(
      text: 'إن استطعت أن لا تُمسي إلا وأنت بريء من غل لأخيك، فافعل',
      source: 'رواه الترمذي',
      type: QuoteType.hadith,
    ),
    IslamicQuote(
      text: 'شاب لا تعرف نفسه إلا بالطاعة أقوى من شيخ يتوب بعد معصية',
      source: 'حكمة',
      type: QuoteType.wisdom,
    ),
    IslamicQuote(
      text: 'كل يوم تصمد فيه هو شهادة لنفسك أنك أقوى من شهوتك',
      source: '',
      type: QuoteType.wisdom,
    ),
    IslamicQuote(
      text: 'النفس كالطفل — إن تتركه يشب على الرضاع، وإن تفطمه ينفطم',
      source: 'ابن الجوزي',
      type: QuoteType.wisdom,
    ),
    IslamicQuote(
      text: 'يا شباب، من استطاع منكم الباءة فليتزوج، فإنه أغض للبصر وأحصن للفرج',
      source: 'متفق عليه',
      type: QuoteType.hadith,
    ),
    IslamicQuote(
      text: 'إن الذنب لا يصغر إذا قابلته بعظمة من عصيت',
      source: 'ابن القيم',
      type: QuoteType.wisdom,
    ),
  ];

  // ─── Alternative Activities ───────────────────────────────────────────────

  static const List<AlternativeActivity> activities = [
    AlternativeActivity(
      id: 'dhikr',
      title: 'الذكر الفوري',
      description: 'سبحان الله ١٠٠ مرة — يطرد الوسواس ويهدئ النفس',
      emoji: '📿',
      durationMinutes: 5,
      category: ActivityCategory.spiritual,
    ),
    AlternativeActivity(
      id: 'cold_shower',
      title: 'دش بارد',
      description: 'أسرع طريقة لكسر الإغراء — ٣ دقائق تغير كل شيء',
      emoji: '🚿',
      durationMinutes: 3,
      category: ActivityCategory.physical,
    ),
    AlternativeActivity(
      id: 'pushups',
      title: 'تمارين فورية',
      description: '٢٠ ضغطة أو ٣٠ قرفصاء — حوّل الطاقة لشيء مفيد',
      emoji: '💪',
      durationMinutes: 5,
      category: ActivityCategory.physical,
    ),
    AlternativeActivity(
      id: 'walk',
      title: 'خرج مشي',
      description: 'اخرج من البيت الآن — تغيير البيئة يكسر الحلقة',
      emoji: '🚶',
      durationMinutes: 15,
      category: ActivityCategory.physical,
    ),
    AlternativeActivity(
      id: 'quran',
      title: 'تلاوة القرآن',
      description: 'افتح سورة الكهف أو يوسف — القرآن درع من الشيطان',
      emoji: '📖',
      durationMinutes: 10,
      category: ActivityCategory.spiritual,
    ),
    AlternativeActivity(
      id: 'prayer',
      title: 'صلاة النافلة',
      description: 'صلِّ ركعتين — النوافل تقرّب من الله وتبعد الوسواس',
      emoji: '🕌',
      durationMinutes: 8,
      category: ActivityCategory.spiritual,
    ),
    AlternativeActivity(
      id: 'read',
      title: 'قراءة كتاب',
      description: 'افتح أي كتاب مفيد وانشغل عقلك',
      emoji: '📚',
      durationMinutes: 20,
      category: ActivityCategory.mental,
    ),
    AlternativeActivity(
      id: 'call',
      title: 'اتصل بأحد',
      description: 'أي شخص تثق به — الوحدة تزيد الإغراء',
      emoji: '📞',
      durationMinutes: 10,
      category: ActivityCategory.social,
    ),
    AlternativeActivity(
      id: 'breathing',
      title: 'تمرين التنفس',
      description: 'شهيق ٤ ثواني، حبس ٤، زفير ٤ — كرر ١٠ مرات',
      emoji: '🌬️',
      durationMinutes: 5,
      category: ActivityCategory.mental,
    ),
  ];

  // ─── Library ───────────────────────────────────────────────────────────────

  static const List<LibraryItem> library = [
    // ── إسلامي ──
    LibraryItem(
      id: 'ibn_qayyim_ruh',
      title: 'إغاثة اللهفان في مصايد الشيطان',
      author: 'ابن القيم الجوزية',
      description: 'كتاب كلاسيكي في مجاهدة النفس وأساليب الشيطان لإيقاع الإنسان',
      category: 'إسلامي',
      type: LibraryType.book,
      emoji: '📗',
    ),
    LibraryItem(
      id: 'tawbah',
      title: 'التوابون',
      author: 'ابن قدامة المقدسي',
      description: 'قصص التائبين وكيف عادوا لله — يمنحك أملاً حقيقياً',
      category: 'إسلامي',
      type: LibraryType.book,
      emoji: '📘',
    ),
    LibraryItem(
      id: 'muhasabah',
      title: 'محاسبة النفس',
      author: 'ابن أبي الدنيا',
      description: 'كيف تحاسب نفسك يومياً وتُقوّم سلوكك',
      category: 'إسلامي',
      type: LibraryType.book,
      emoji: '📙',
    ),

    // ── علم نفسي ──
    LibraryItem(
      id: 'your_brain_porn',
      title: 'Your Brain on Porn',
      author: 'Gary Wilson',
      description: 'الكتاب الأشهر عالمياً في تأثير الإباحية على الدماغ — مبني على أبحاث علمية',
      category: 'علم الأعصاب',
      type: LibraryType.book,
      emoji: '🧠',
    ),
    LibraryItem(
      id: 'atomic_habits',
      title: 'العادات الذرية',
      author: 'جيمس كلير',
      description: 'كيف تكسر العادات السيئة وتبني عادات إيجابية خطوة بخطوة',
      category: 'تطوير ذات',
      type: LibraryType.book,
      emoji: '⚡',
    ),
    LibraryItem(
      id: 'dopamine_nation',
      title: 'Dopamine Nation',
      author: 'Anna Lembke',
      description: 'طبيبة نفسية تشرح علم الدوبامين وكيف يؤثر الإدمان الرقمي على الدماغ',
      category: 'علم الأعصاب',
      type: LibraryType.book,
      emoji: '🔬',
    ),
    LibraryItem(
      id: 'rewire',
      title: 'مقالة: كيف تُعيد برمجة دماغك',
      author: 'NoFap.com',
      description: 'شرح علمي لمفهوم إعادة توصيل الدماغ بعد الإقلاع',
      category: 'مقالة',
      url: 'https://www.nofap.com/rebooting/',
      type: LibraryType.article,
      emoji: '🔗',
    ),
    LibraryItem(
      id: 'urge_surfing',
      title: 'مقالة: Urge Surfing تقنية ركوب موجة الإغراء',
      author: 'Alan Marlatt',
      description: 'تقنية نفسية مثبتة لتجاوز لحظات الإغراء دون الاستسلام',
      category: 'مقالة',
      type: LibraryType.article,
      emoji: '🏄',
    ),
  ];

  // ─── Breathing Exercise Steps ─────────────────────────────────────────────

  static const List<Map<String, dynamic>> breathingSteps = [
    {'label': 'شهيق', 'seconds': 4, 'color': 0xFF4CAF50},
    {'label': 'ثبّت', 'seconds': 4, 'color': 0xFFD4AF37},
    {'label': 'زفير', 'seconds': 4, 'color': 0xFF2196F3},
    {'label': 'استرح', 'seconds': 2, 'color': 0xFF1B5E20},
  ];
}

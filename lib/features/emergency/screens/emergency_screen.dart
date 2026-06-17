import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/app_data.dart';
import '../../../models/models.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🆘 وقفة'),
        backgroundColor: const Color(AppColors.danger).withOpacity(0.2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('🛑', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text('توقّف لثلاثين ثانية',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(AppColors.gold)),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('الإغراء موجة — تأتي وتمضي.\nأنت أقوى منها إذا انتظرت.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
                    textAlign: TextAlign.center),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text('🌬️ تمرين التنفس',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(AppColors.primaryLight))),
          const SizedBox(height: 12),
          const _BreathingCard(),

          const SizedBox(height: 24),

          Text('📿 الذكر الفوري',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(AppColors.primaryLight))),
          const SizedBox(height: 12),
          const _DhikrEmergency(),

          const SizedBox(height: 24),

          Text('⚡ نشاط بديل الآن',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(AppColors.primaryLight))),
          const SizedBox(height: 12),

          ...AppData.activities.take(5).map((a) => _ActivityTile(activity: a)).toList(),
        ],
      ),
    );
  }
}

class _BreathingCard extends StatefulWidget {
  const _BreathingCard();
  @override
  State<_BreathingCard> createState() => _BreathingCardState();
}

class _BreathingCardState extends State<_BreathingCard> with SingleTickerProviderStateMixin {
  int _stepIndex = 0;
  int _secondsLeft = 4;
  int _cycleCount = 0;
  bool _running = false;
  Timer? _timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  final _steps = AppData.breathingSteps;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _animation = Tween(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _running = true;
      _stepIndex = 0;
      _secondsLeft = _steps[0]['seconds'] as int;
      _cycleCount = 0;
    });
    _controller.forward(from: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _stop() {
    _timer?.cancel();
    _controller.reset();
    setState(() => _running = false);
  }

  void _tick(Timer t) {
    setState(() {
      _secondsLeft--;
      if (_secondsLeft <= 0) {
        _stepIndex = (_stepIndex + 1) % _steps.length;
        if (_stepIndex == 0) _cycleCount++;
        _secondsLeft = _steps[_stepIndex]['seconds'] as int;
        if (_steps[_stepIndex]['label'] == 'شهيق') {
          _controller.forward(from: 0);
        } else if (_steps[_stepIndex]['label'] == 'زفير') {
          _controller.reverse();
        }
        if (_cycleCount >= 5) _stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_running ? _stepIndex : 0];
    final color = Color(step['color'] as int);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          if (_running) ...[
            ScaleTransition(
              scale: _animation,
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                  border: Border.all(color: color, width: 3),
                ),
                child: Center(
                  child: Text('$_secondsLeft',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(step['label'] as String,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color)),
            const SizedBox(height: 8),
            Text('الدورة ${_cycleCount + 1} من 5',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _stop,
              child: const Text('إيقاف', style: TextStyle(color: Colors.red)),
            ),
          ] else ...[
            Text('شهيق ٤ — ثبّت ٤ — زفير ٤',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('٥ دورات تكسر موجة الإغراء',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _start,
              child: const Text('ابدأ التمرين'),
            ),
          ],
        ],
      ),
    );
  }
}

class _DhikrEmergency extends StatelessWidget {
  const _DhikrEmergency();

  static const _dhikrs = [
    'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفَافَ',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(AppColors.gold).withOpacity(0.3)),
      ),
      child: Column(
        children: _dhikrs.map((d) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(AppColors.gold).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(d,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(AppColors.gold), height: 1.8),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl),
        )).toList(),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final AlternativeActivity activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(AppColors.surface),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(AppColors.primaryLight).withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Text(activity.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: Theme.of(context).textTheme.titleMedium),
                Text(activity.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(AppColors.primaryLight).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('${activity.durationMinutes}د',
                style: const TextStyle(color: Color(AppColors.primaryLight), fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

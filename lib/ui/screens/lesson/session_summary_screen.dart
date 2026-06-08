import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../models/learning/quiz_score.dart';

enum _FeedbackState { accuracy, speed, standard }

class SessionSummaryScreen extends StatefulWidget {
  final QuizScoreCalculator score;
  final double timeThresholdSeconds;

  const SessionSummaryScreen({
    super.key,
    required this.score,
    this.timeThresholdSeconds = 30,
  });

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  late _FeedbackState _state;
  late String _dynamicText;
  late String _sageAsset;
  final _random = Random();

  static const _accuracyTexts = [
    '¡Qué buena puntería!',
    'Precisión quirúrgica.',
    'Nivel experto alcanzado.',
    'Francotirador del conocimiento.',
    'Perfección casi absoluta.',
    'No dejaste margen de error.',
    'Impecable.',
  ];

  static const _speedTexts = [
    '¡Qué veloz!',
    'Rompiste el cronómetro.',
    'A la velocidad de la luz.',
    'Reflejos de acero.',
    'Nadie te alcanza hoy.',
    '¡Tiempo récord!',
    'Velocidad supersónica.',
  ];

  static const _standardTexts = [
    '¡Lección completada!',
    'Un paso más cerca de tu meta.',
    'El progreso es el camino.',
    'Buen trabajo constante.',
    'Sigue así, sumando días.',
    'Constancia ante todo.',
    'La disciplina da resultados.',
  ];

  static const _accuracyAssets = [
    'assets/mascot/emotions/sage_excited_wave.png',
    'assets/mascot/emotions/sage_happy_wings.png',
    'assets/mascot/emotions/sage_laughing.png',
  ];

  static const _speedAssets = [
    'assets/mascot/emotions/sage_curious.png',
    'assets/mascot/emotions/sage_shocked.png',
    'assets/mascot/emotions/sage_surprised_wings.png',
  ];

  static const _standardAssets = [
    'assets/mascot/emotions/sage_calm.png',
    'assets/mascot/emotions/sage_neutral.png',
    'assets/mascot/emotions/sage_whistling.png',
  ];

  _FeedbackState _determineState(double accuracy, double avgTime) {
    if (accuracy >= 90) return _FeedbackState.accuracy;
    if (avgTime < widget.timeThresholdSeconds && accuracy > 70) {
      return _FeedbackState.speed;
    }
    return _FeedbackState.standard;
  }

  String _pickRandom(List<String> list) => list[_random.nextInt(list.length)];

  int get _totalXp {
    const base = 15;
    final bonus = switch (_state) {
      _FeedbackState.accuracy => 10,
      _FeedbackState.speed => 5,
      _FeedbackState.standard => 0,
    };
    return base + bonus;
  }

  @override
  void initState() {
    super.initState();
    final accuracy = widget.score.accuracyPercent;
    final avgTime = widget.score.avgTimePerQuestion;
    _state = _determineState(accuracy, avgTime);
    _dynamicText = switch (_state) {
      _FeedbackState.accuracy => _pickRandom(_accuracyTexts),
      _FeedbackState.speed => _pickRandom(_speedTexts),
      _FeedbackState.standard => _pickRandom(_standardTexts),
    };
    _sageAsset = switch (_state) {
      _FeedbackState.accuracy => _pickRandom(_accuracyAssets),
      _FeedbackState.speed => _pickRandom(_speedAssets),
      _FeedbackState.standard => _pickRandom(_standardAssets),
    };
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _glowCtrl.repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 200), () {
        HapticFeedback.mediumImpact();
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        HapticFeedback.mediumImpact();
      });
    });
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  Color get _primaryColor => switch (_state) {
    _FeedbackState.accuracy => PremiumColors.streakOrange,
    _FeedbackState.speed => PremiumColors.splashBlue,
    _FeedbackState.standard => PremiumColors.primaryAccent,
  };

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.darkBg : PremiumColors.lightBg,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _glowCtrl,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    _primaryColor.withValues(alpha: 0.06 + _glowCtrl.value * 0.04),
                    dark ? PremiumColors.darkBg : PremiumColors.lightBg,
                    dark ? PremiumColors.darkBg : PremiumColors.lightBg,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  _buildMascot(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildDynamicText(),
                  const SizedBox(height: AppSpacing.xxl),
                  _StatsGrid(
                    totalXp: _totalXp,
                    accuracyPercent: widget.score.accuracyPercent,
                    timeSeconds: widget.score.timeSpentSeconds,
                    primaryColor: _primaryColor,
                  ),
                  const Spacer(flex: 3),
                  _buildButton(),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMascot() {
    return Image.asset(
      _sageAsset,
      height: 120,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const SizedBox(height: 120, width: 120),
    );
  }

  Widget _buildDynamicText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Text(
        _dynamicText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
          height: 1.3,
          shadows: [
            Shadow(
              color: _primaryColor.withValues(alpha: 0.25),
              blurRadius: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            context.goNamed('habit-transition');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'RECIBIR RECOMPENSA',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white.withValues(alpha: 0.8)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final int totalXp;
  final double accuracyPercent;
  final int timeSeconds;
  final Color primaryColor;

  const _StatsGrid({
    required this.totalXp,
    required this.accuracyPercent,
    required this.timeSeconds,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final valColor = dark ? Colors.white : Colors.black87;
    final minutes = (timeSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (timeSeconds % 60).toString().padLeft(2, '0');
    final timeFormatted = '$minutes:$secs';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Row(
        children: [
          Expanded(child: _StatBlock(
            icon: Icons.bolt_rounded,
            label: 'EXP',
            color: PremiumColors.streakOrange,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: totalXp.toDouble()),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, val, _) => Text(
                '+${val.toInt()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valColor),
              ),
            ),
          )),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _StatBlock(
            icon: Icons.gps_fixed_rounded,
            label: 'PRECISIÓN',
            color: PremiumColors.success,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: accuracyPercent),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, val, _) => Text(
                '${val.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valColor),
              ),
            ),
          )),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _StatBlock(
            icon: Icons.timer_outlined,
            label: 'TIEMPO',
            color: PremiumColors.splashBlue,
            child: Text(
              timeFormatted,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valColor),
            ),
          )),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Widget child;

  const _StatBlock({
    required this.icon,
    required this.label,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: dark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        border: Border.all(color: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

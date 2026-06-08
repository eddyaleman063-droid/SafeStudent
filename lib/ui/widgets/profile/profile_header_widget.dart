import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String displayName;
  final String? photoUrl;
  final int currentLevel;
  final int xp;
  final int nextLevelXp;

  const ProfileHeaderWidget({
    super.key,
    required this.displayName,
    this.photoUrl,
    required this.currentLevel,
    required this.xp,
    required this.nextLevelXp,
  });

  double get _levelProgress => nextLevelXp > 0 ? (xp % nextLevelXp) / nextLevelXp : 0.0;
  int get _xpInLevel => xp % nextLevelXp;

  String _rank(AppLocalizations l) {
    if (currentLevel >= 50) return l.rankCybersecurityLegend;
    if (currentLevel >= 30) return l.rankEliteDefender;
    if (currentLevel >= 20) return l.rankExperiencedWarrior;
    if (currentLevel >= 10) return l.rankActiveLearner;
    return l.rankNovice;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1A237E), Color(0xFF1B2433)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xxl),
          bottomRight: Radius.circular(AppRadius.xxl),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, AppSpacing.xxl),
          child: Column(
            children: [
              _buildAvatar(),
              const SizedBox(height: AppSpacing.lg),
              _buildName(l),
              const SizedBox(height: AppSpacing.xs),
              _buildRank(l),
              const SizedBox(height: AppSpacing.lg),
              _buildLevelBar(l),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: _levelProgress.clamp(0.0, 1.0),
            strokeWidth: 3.5,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4AC2DD)),
          ),
          Center(
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 2),
              ),
              child: ClipOval(
                child: photoUrl != null && photoUrl!.isNotEmpty
                    ? Image.network(photoUrl!, fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _fallbackAvatar())
                    : _fallbackAvatar(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4AC2DD),
              ),
              child: Center(
                child: Text(
                  '$currentLevel',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color: Colors.white.withValues(alpha: 0.1),
      child: const Icon(Icons.shield_rounded, size: 40, color: Colors.white54),
    );
  }

  Widget _buildName(AppLocalizations l) {
    return Text(
      displayName.isNotEmpty ? displayName : l.profileDefaultName,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRank(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        color: Colors.white.withValues(alpha: 0.1),
      ),
      child: Text(
        _rank(l),
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildLevelBar(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: Colors.white.withValues(alpha: 0.08),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.profileLevelValue(currentLevel),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              Text(
                '$_xpInLevel / $nextLevelXp XP',
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: _levelProgress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4AC2DD)),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

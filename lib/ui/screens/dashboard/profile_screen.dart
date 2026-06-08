import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/experience_service.dart';
import 'package:sagen/ui/widgets/profile/achievement_card.dart';
import 'package:sagen/ui/widgets/profile/flex_card_share_sheet.dart';
import 'package:sagen/ui/widgets/profile/profile_header_widget.dart';
import 'package:sagen/ui/widgets/profile/rewarded_ad_card.dart';
import 'package:sagen/ui/widgets/profile/settings_actions.dart';
import 'package:sagen/ui/widgets/profile/stat_card_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with AutomaticKeepAliveClientMixin {
  void _showFlexCard(BuildContext context, WidgetRef ref) {
    ExperienceService.instance.lightHaptic();
    final auth = ref.read(authProvider);
    final learning = ref.read(learningProvider);
    final streak = ref.read(streakProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FlexCardShareSheet(
        displayName: auth.displayName,
        photoUrl: auth.photoUrl,
        level: learning.currentLevel,
        xp: learning.totalXpEarned,
        streak: streak.currentStreak,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final displayName = ref.watch(authProvider.select((a) => a.displayName));
    final photoUrl = ref.watch(authProvider.select((a) => a.photoUrl));
    final learning = ref.watch(learningProvider);
    final currentStreak = ref.watch(streakProvider.select((s) => s.currentStreak));
    final achievements = ref.watch(achievementProvider);

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF1B2433) : PremiumColors.lightBg,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFlexCard(context, ref),
        backgroundColor: PremiumColors.splashBlue,
        child: const Icon(Icons.share_rounded, color: Colors.white),
      ),
      body: RepaintBoundary(
        child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeaderWidget(
              displayName: displayName,
              photoUrl: photoUrl,
              currentLevel: learning.currentLevel,
              xp: learning.totalXpEarned,
              nextLevelXp: learning.nextLevelXp,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, 0),
              child: Row(
                children: [
                  Expanded(
                    child: StatCardWidget(
                      icon: Icons.local_fire_department_rounded,
                      value: '$currentStreak',
                      label: AppLocalizations.of(context)!.profileStreak,
                      iconColor: PremiumColors.streakOrange,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: StatCardWidget(
                      icon: Icons.auto_awesome_rounded,
                      value: '${learning.totalXpEarned}',
                      label: AppLocalizations.of(context)!.profileXpLabel,
                      iconColor: PremiumColors.xpColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: StatCardWidget(
                      icon: Icons.diamond_rounded,
                      value: '${learning.totalGemsEarned}',
                      label: AppLocalizations.of(context)!.profileGems,
                      iconColor: PremiumColors.achievementEnd,
                      accentColor: const Color(0xFFFFD54F),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: RewardedAdCard(dark: dark),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xl, AppSpacing.xxl, 0),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, size: 18, color: PremiumColors.achievementStart),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    AppLocalizations.of(context)!.profileAchievements,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: dark ? Colors.white.withValues(alpha: 0.85) : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${achievements.unlockedCount}/${achievements.totalCount}',
                    style: TextStyle(fontSize: 13, color: dark ? Colors.white38 : Colors.black45),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, 0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => AchievementCard(achievement: achievements.achievements[i], dark: dark),
                childCount: achievements.totalCount,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.xxl, AppSpacing.xxl, 32),
              child: SettingsActions(dark: dark),
            ),
          ),
        ],
      ),
        ),
    );
  }
}



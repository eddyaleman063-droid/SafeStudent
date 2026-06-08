import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import '../../../core/theme/theme_constants.dart';
import '../../../services/experience_service.dart';
import '../../widgets/ranking/podium_widget.dart';
import '../../widgets/ranking/ranking_tile.dart';
import '../../widgets/ranking/current_user_rank_bar.dart';
import '../../widgets/profile/flex_card_widget.dart';
import '../../widgets/shimmer_loading.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> with AutomaticKeepAliveClientMixin {
  void _showFlexCard(BuildContext context, WidgetRef ref, LeaderboardEntry entry, int rank) {
    ExperienceService.instance.lightHaptic();
    final auth = ref.read(authProvider);
    final learning = ref.read(learningProvider);
    final streak = ref.read(streakProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RankingFlexCardShareSheet(
        displayName: entry.displayName,
        photoUrl: auth.photoUrl,
        level: learning.currentLevel,
        xp: entry.totalXp,
        streak: streak.currentStreak,
        rank: rank,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final currentUid = ref.watch(authProvider.select((a) => a.uid));

    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      floatingActionButton: leaderboardAsync.when(
        loading: () => null,
        error: (err, stack) => null,
        data: (entries) {
          final currentIndex = entries.indexWhere((e) => e.uid == currentUid);
          if (currentIndex < 0) return null;
          return FloatingActionButton(
            onPressed: () => _showFlexCard(context, ref, entries[currentIndex], currentIndex + 1),
            backgroundColor: PremiumColors.splashBlue,
            child: const Icon(Icons.share_rounded, color: Colors.white),
          );
        },
      ),
      body: SafeArea(
        child: leaderboardAsync.when(
          loading: () => const _RankingShimmer(),
          error: (err, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded, size: 48, color: dark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.3)),
                const SizedBox(height: AppSpacing.md),
                Text(AppLocalizations.of(context)!.rankingError, style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.5))),
              ],
            ),
          ),
          data: (entries) => _RankingContent(entries: entries, currentUid: currentUid),
        ),
      ),
    );
  }
}

class _RankingContent extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  final String? currentUid;

  const _RankingContent({required this.entries, required this.currentUid});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final top3 = entries.length > 3 ? entries.sublist(0, 3) : entries;
    final rest = entries.length > 3 ? entries.sublist(3) : <LeaderboardEntry>[];

    final currentIndex = entries.indexWhere((e) => e.uid == currentUid);
    final currentEntry = currentIndex >= 0 ? entries[currentIndex] : null;
    final isInTop50 = currentIndex >= 0;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  MediaQuery.of(context).padding.top + AppSpacing.xxl,
                  AppSpacing.xxl,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.rankingTitle,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white.withValues(alpha: 0.9) : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.rankingSubtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: dark ? Colors.white.withValues(alpha: 0.4) : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (top3.isNotEmpty)
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                child: PodiumWidget(top3: top3),
              )),
            if (rest.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = rest[index];
                      final rank = index + 4;
                      return RankingTileWidget(
                        rank: rank,
                        entry: entry,
                        isCurrentUser: entry.uid == currentUid,
                      );
                    },
                    childCount: rest.length,
                  ),
                ),
              ),
            if (isInTop50 && currentIndex >= 3)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.sm, AppSpacing.xxl, AppSpacing.xxl),
                  child: RankingTileWidget(
                    rank: currentIndex + 1,
                    entry: entries[currentIndex],
                    isCurrentUser: true,
                  ),
                ),
              ),
            if (!isInTop50)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.rankingEmptyMessage,
                      style: TextStyle(color: dark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.3), fontSize: 13),
                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        if (!isInTop50 && currentEntry != null && entries.isNotEmpty)
          Positioned(
            left: AppSpacing.xxl,
            right: AppSpacing.xxl,
            bottom: AppSpacing.xl,
              child: CurrentUserRankBar(
              rank: currentIndex + 1,
              totalXp: currentEntry.totalXp,
              xpToNext: entries.last.totalXp - currentEntry.totalXp,
            ),
          ),
      ],
    );
  }
}

class _RankingFlexCardShareSheet extends ConsumerStatefulWidget {
  final String displayName;
  final String? photoUrl;
  final int level;
  final int xp;
  final int streak;
  final int rank;

  const _RankingFlexCardShareSheet({
    required this.displayName,
    this.photoUrl,
    required this.level,
    required this.xp,
    required this.streak,
    required this.rank,
  });

  @override
  ConsumerState<_RankingFlexCardShareSheet> createState() => _RankingFlexCardShareSheetState();
}

class _RankingFlexCardShareSheetState extends ConsumerState<_RankingFlexCardShareSheet> {
  final _flexCardKey = GlobalKey<FlexCardWidgetState>();
  bool _sharing = false;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      margin: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        color: dark ? const Color(0xFF1B2433) : Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              color: dark ? Colors.white12 : Colors.black12,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: FlexCardWidget(
                key: _flexCardKey,
                displayName: widget.displayName,
                photoUrl: widget.photoUrl,
                level: widget.level,
                xp: widget.xp,
                streak: widget.streak,
                rank: widget.rank,
                subtitleText: AppLocalizations.of(context)!.rankingShareSubtitle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xl),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _sharing ? null : _share,
                icon: _sharing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.share_rounded, size: 18),
                label: Text(_sharing ? AppLocalizations.of(context)!.rankingSharing : AppLocalizations.of(context)!.rankingShareButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PremiumColors.splashBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: PremiumColors.splashBlue.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _share() async {
    setState(() => _sharing = true);
    final bytes = await _flexCardKey.currentState?.capture();
    if (bytes != null && mounted) {
      await ref.read(shareServiceProvider).shareImage(bytes, source: 'ranking');
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }
}

class _RankingShimmer extends StatelessWidget {
  const _RankingShimmer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, 0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerLoading(width: 80, height: 80, borderRadius: AppRadius.pill),
                SizedBox(width: AppSpacing.md),
                ShimmerLoading(width: 80, height: 80, borderRadius: AppRadius.pill),
                SizedBox(width: AppSpacing.md),
                ShimmerLoading(width: 80, height: 80, borderRadius: AppRadius.pill),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            ...List.generate(
              5,
              (i) => const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: ShimmerLoading(
                  width: double.infinity,
                  height: 56,
                  borderRadius: AppRadius.lg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

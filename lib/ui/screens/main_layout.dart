import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import '../../core/theme/theme_constants.dart';
import '../../services/experience_service.dart';
import '../../services/deep_link_service.dart';
import 'dashboard/dashboard_home_screen.dart';
import 'dashboard/store_screen.dart';
import 'dashboard/sage_chat_screen.dart';
import 'dashboard/ranking_screen.dart';
import 'dashboard/profile_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  final int initialTab;
  const MainLayout({super.key, this.initialTab = 0});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  late PageController _pageCtrl;
  bool _animating = false;
  StreamSubscription<int>? _tabSub;

  static List<_TabItem> tabs(BuildContext context) => [
    _TabItem(label: AppLocalizations.of(context)!.navHome, icon: Icons.home_rounded),
    _TabItem(label: AppLocalizations.of(context)!.navChest, icon: Icons.card_giftcard_rounded),
    _TabItem(label: AppLocalizations.of(context)!.navSage, icon: Icons.auto_awesome_rounded),
    _TabItem(label: AppLocalizations.of(context)!.navRanking, icon: Icons.leaderboard_rounded),
    _TabItem(label: AppLocalizations.of(context)!.navProfile, icon: Icons.person_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: widget.initialTab);
    _tabSub = DeepLinkService.instance.tabSwitchStream.listen((tab) {
      if (mounted) _onTabTap(tab);
    });
  }

  @override
  void dispose() {
    _tabSub?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    if (_animating || index == ref.read(dashboardProvider.notifier).activeTab) return;
    ExperienceService.instance.lightHaptic();
    setState(() => _animating = true);
    ref.read(dashboardProvider.notifier).setActiveTab(index);
    _pageCtrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    ).then((_) {
      if (!mounted) return;
      setState(() => _animating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(dashboardProvider.select((d) => d.activeTab));
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      body: Stack(
        children: [
          PageView(
            controller: _pageCtrl,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              DashboardHomeScreen(),
              StoreScreen(),
              SageChatScreen(),
              RankingScreen(),
              ProfileScreen(),
            ],
          ),
          Positioned(
            left: AppSpacing.xxl,
            right: AppSpacing.xxl,
            bottom: AppSpacing.lg,
            child: _PremiumNavBar(
              currentIndex: activeTab,
              onTap: _onTabTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  const _TabItem({required this.label, required this.icon});
}

class _PremiumNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _PremiumNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: dark ? PremiumColors.darkCard.withValues(alpha: 0.96) : Colors.white.withValues(alpha: 0.96),
        border: Border.all(
          color: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_MainLayoutState.tabs(context).length, (i) {
          final selected = i == currentIndex;
          final item = _MainLayoutState.tabs(context)[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: selected
                        ? PremiumColors.splashBlue
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 22,
                      color: selected
                          ? PremiumColors.splashBlue
                          : dark ? Colors.white38 : Colors.black38,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        color: selected
                            ? PremiumColors.splashBlue
                            : dark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

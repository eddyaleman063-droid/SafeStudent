import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/ui/widgets/shimmer_loading.dart';

class UserProfileScreen extends StatelessWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? PremiumColors.deepBackground : PremiumColors.lightBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: dark ? Colors.white70 : Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          final l = AppLocalizations.of(context)!;
          if (snapshot.hasError) {
            return Center(
              child: Text(l.profileError, style: TextStyle(color: dark ? Colors.white54 : Colors.black54)),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const _ProfileShimmer();
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = data['firstName'] as String? ?? l.profileDefaultFirstName;
          final lastName = data['lastName'] as String? ?? l.profileDefaultLastName;
          final totalXp = data['totalXp'] as int? ?? 0;
          final currentStreak = data['currentStreak'] as int? ?? 0;
          final level = (totalXp / 100).floor() + 1;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: PremiumColors.splashBlue, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: PremiumColors.splashBlue.withValues(alpha: 0.25),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${firstName[0]}${lastName[0]}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: PremiumColors.splashBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '$firstName $lastName',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _StatRow(label: l.profileLevel, value: '$level'),
                _StatRow(label: l.profileTotalXp, value: '$totalXp'),
                _StatRow(label: l.profileStreak, value: l.streakDays(currentStreak)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: dark ? Colors.white54 : Colors.black54)),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: dark ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerLoading(width: 88, height: 88, borderRadius: AppRadius.pill),
          SizedBox(height: AppSpacing.lg),
          ShimmerLoading(width: 140, height: 20),
          SizedBox(height: AppSpacing.xl),
          ShimmerLoading(width: 180, height: 14),
          SizedBox(height: AppSpacing.sm),
          ShimmerLoading(width: 120, height: 14),
          SizedBox(height: AppSpacing.sm),
          ShimmerLoading(width: 150, height: 14),
        ],
      ),
    );
  }
}

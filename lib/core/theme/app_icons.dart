import 'package:flutter/material.dart';

enum AppIconType {
  shieldHome,
  chestGift,
  podiumRank,
  sageSpark,
  personShield,
  fire,
  diamond,
  shield,
  iceCube,
  star,
  present,
  scroll,
  heart,
  bolt,
  infinity,
  energy,
  clock,
  trophy,
  book,
  sparkles,
  flame,
  gem,
}

class AppIcon extends StatelessWidget {
  final AppIconType type;
  final double size;
  final Color color;

  const AppIcon({
    super.key,
    required this.type,
    this.size = 24,
    this.color = Colors.white,
  });

  IconData get _iconData {
    switch (type) {
      case AppIconType.shieldHome:
        return Icons.home_rounded;
      case AppIconType.chestGift:
        return Icons.card_giftcard_rounded;
      case AppIconType.podiumRank:
        return Icons.leaderboard_rounded;
      case AppIconType.sageSpark:
        return Icons.auto_awesome_rounded;
      case AppIconType.personShield:
        return Icons.shield_rounded;
      case AppIconType.fire:
        return Icons.local_fire_department_rounded;
      case AppIconType.diamond:
        return Icons.diamond_rounded;
      case AppIconType.shield:
        return Icons.shield_rounded;
      case AppIconType.iceCube:
        return Icons.ac_unit_rounded;
      case AppIconType.star:
        return Icons.star_rounded;
      case AppIconType.present:
        return Icons.card_giftcard_rounded;
      case AppIconType.scroll:
        return Icons.article_rounded;
      case AppIconType.heart:
        return Icons.favorite_rounded;
      case AppIconType.bolt:
        return Icons.bolt_rounded;
      case AppIconType.infinity:
        return Icons.all_inclusive_rounded;
      case AppIconType.energy:
        return Icons.bolt_rounded;
      case AppIconType.clock:
        return Icons.access_time_rounded;
      case AppIconType.trophy:
        return Icons.emoji_events_rounded;
      case AppIconType.book:
        return Icons.auto_stories_rounded;
      case AppIconType.sparkles:
        return Icons.auto_awesome_rounded;
      case AppIconType.flame:
        return Icons.local_fire_department_rounded;
      case AppIconType.gem:
        return Icons.diamond_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(_iconData, size: size, color: color);
  }
}

extension AppIconTypeX on AppIconType {
  IconData get iconData => _iconDataForType(this);
}

IconData _iconDataForType(AppIconType type) {
  switch (type) {
    case AppIconType.shieldHome:
      return Icons.home_rounded;
    case AppIconType.chestGift:
      return Icons.card_giftcard_rounded;
    case AppIconType.podiumRank:
      return Icons.leaderboard_rounded;
    case AppIconType.sageSpark:
      return Icons.auto_awesome_rounded;
    case AppIconType.personShield:
      return Icons.shield_rounded;
    case AppIconType.fire:
      return Icons.local_fire_department_rounded;
    case AppIconType.diamond:
      return Icons.diamond_rounded;
    case AppIconType.shield:
      return Icons.shield_rounded;
    case AppIconType.iceCube:
      return Icons.ac_unit_rounded;
    case AppIconType.star:
      return Icons.star_rounded;
    case AppIconType.present:
      return Icons.card_giftcard_rounded;
    case AppIconType.scroll:
      return Icons.article_rounded;
    case AppIconType.heart:
      return Icons.favorite_rounded;
    case AppIconType.bolt:
      return Icons.bolt_rounded;
    case AppIconType.infinity:
      return Icons.all_inclusive_rounded;
    case AppIconType.energy:
      return Icons.bolt_rounded;
    case AppIconType.clock:
      return Icons.access_time_rounded;
    case AppIconType.trophy:
      return Icons.emoji_events_rounded;
    case AppIconType.book:
      return Icons.auto_stories_rounded;
    case AppIconType.sparkles:
      return Icons.auto_awesome_rounded;
    case AppIconType.flame:
      return Icons.local_fire_department_rounded;
    case AppIconType.gem:
      return Icons.diamond_rounded;
  }
}

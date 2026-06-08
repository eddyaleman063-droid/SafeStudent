// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chest_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChestRewardImpl _$$ChestRewardImplFromJson(Map<String, dynamic> json) =>
    _$ChestRewardImpl(
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      gems: (json['gems'] as num?)?.toInt() ?? 0,
      streakShields: (json['streakShields'] as num?)?.toInt(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      xpBoost: json['xpBoost'] as bool? ?? false,
      gemMultiplier: json['gemMultiplier'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChestRewardImplToJson(_$ChestRewardImpl instance) =>
    <String, dynamic>{
      'xp': instance.xp,
      'gems': instance.gems,
      'streakShields': instance.streakShields,
      'title': instance.title,
      'message': instance.message,
      'isPremium': instance.isPremium,
      'xpBoost': instance.xpBoost,
      'gemMultiplier': instance.gemMultiplier,
    };

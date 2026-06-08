// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationItemImpl _$$NotificationItemImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationItemImpl(
  id: json['id'] as String? ?? '',
  title: json['title'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  date: DateTime.parse(json['date'] as String),
  isRead: json['isRead'] as bool? ?? false,
);

Map<String, dynamic> _$$NotificationItemImplToJson(
  _$NotificationItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'date': instance.date.toIso8601String(),
  'isRead': instance.isRead,
};

const _$NotificationTypeEnumMap = {
  NotificationType.streak: 'streak',
  NotificationType.analysis: 'analysis',
  NotificationType.tip: 'tip',
  NotificationType.achievement: 'achievement',
  NotificationType.system: 'system',
};

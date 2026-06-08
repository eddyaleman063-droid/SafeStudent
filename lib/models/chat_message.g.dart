// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      role: $enumDecode(_$ChatRoleEnumMap, json['role']),
      text: json['text'] as String,
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'role': _$ChatRoleEnumMap[instance.role]!,
      'text': instance.text,
      'time': instance.time.toIso8601String(),
    };

const _$ChatRoleEnumMap = {
  ChatRole.user: 'user',
  ChatRole.assistant: 'assistant',
};

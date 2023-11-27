// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      id: json['id'] as int?,
      taskTitle: json['taskTitle'] as String,
      taskDescription: json['taskDescription'] as String,
      isCompleted: json['isCompleted'] as int,
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskTitle': instance.taskTitle,
      'taskDescription': instance.taskDescription,
      'isCompleted': instance.isCompleted,
    };

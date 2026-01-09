// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      id: json['id'] as String,
      subject: json['subject'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      classroom: json['classroom'] as String?,
      teacher: json['teacher'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'classroom': instance.classroom,
      'teacher': instance.teacher,
      'color': instance.color,
    };

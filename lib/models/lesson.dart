import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

/// Модель урока
@JsonSerializable()
class Lesson {
  /// Уникальный идентификатор урока
  final String id;

  /// Название предмета
  final String subject;

  /// Время начала (формат HH:mm)
  final String startTime;

  /// Время окончания (формат HH:mm)
  final String endTime;

  /// Номер кабинета (необязательно)
  final String? classroom;

  /// Имя учителя (необязательно)
  final String? teacher;

  /// Цвет для отображения урока (hex формат)
  final String? color;

  Lesson({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.classroom,
    this.teacher,
    this.color,
  });

  /// Создание копии урока с изменениями
  Lesson copyWith({
    String? id,
    String? subject,
    String? startTime,
    String? endTime,
    String? classroom,
    String? teacher,
    String? color,
  }) {
    return Lesson(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      classroom: classroom ?? this.classroom,
      teacher: teacher ?? this.teacher,
      color: color ?? this.color,
    );
  }

  /// JSON сериализация
  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);

  @override
  String toString() {
    return 'Lesson(subject: $subject, time: $startTime-$endTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lesson && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

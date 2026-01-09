import 'package:json_annotation/json_annotation.dart';
import 'lesson.dart';

part 'day_schedule.g.dart';

/// Дни недели
enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  /// Название дня на русском
  String get displayName {
    switch (this) {
      case WeekDay.monday:
        return 'Понедельник';
      case WeekDay.tuesday:
        return 'Вторник';
      case WeekDay.wednesday:
        return 'Среда';
      case WeekDay.thursday:
        return 'Четверг';
      case WeekDay.friday:
        return 'Пятница';
      case WeekDay.saturday:
        return 'Суббота';
      case WeekDay.sunday:
        return 'Воскресенье';
    }
  }

  /// Короткое название дня
  String get shortName {
    switch (this) {
      case WeekDay.monday:
        return 'Пн';
      case WeekDay.tuesday:
        return 'Вт';
      case WeekDay.wednesday:
        return 'Ср';
      case WeekDay.thursday:
        return 'Чт';
      case WeekDay.friday:
        return 'Пт';
      case WeekDay.saturday:
        return 'Сб';
      case WeekDay.sunday:
        return 'Вс';
    }
  }

  /// Получить день недели из DateTime
  static WeekDay fromDateTime(DateTime dateTime) {
    return WeekDay.values[dateTime.weekday - 1];
  }
}

/// Расписание на день
@JsonSerializable()
class DaySchedule {
  /// День недели
  @JsonKey(unknownEnumValue: WeekDay.monday)
  final WeekDay weekDay;

  /// Список уроков на этот день
  final List<Lesson> lessons;

  DaySchedule({
    required this.weekDay,
    required this.lessons,
  });

  /// Создание копии расписания с изменениями
  DaySchedule copyWith({
    WeekDay? weekDay,
    List<Lesson>? lessons,
  }) {
    return DaySchedule(
      weekDay: weekDay ?? this.weekDay,
      lessons: lessons ?? List.from(this.lessons),
    );
  }

  /// Добавить урок
  DaySchedule addLesson(Lesson lesson) {
    final updatedLessons = List<Lesson>.from(lessons)..add(lesson);
    // Сортируем уроки по времени начала
    updatedLessons.sort((a, b) => a.startTime.compareTo(b.startTime));
    return copyWith(lessons: updatedLessons);
  }

  /// Удалить урок
  DaySchedule removeLesson(String lessonId) {
    final updatedLessons = lessons.where((l) => l.id != lessonId).toList();
    return copyWith(lessons: updatedLessons);
  }

  /// Обновить урок
  DaySchedule updateLesson(Lesson lesson) {
    final updatedLessons = lessons.map((l) => l.id == lesson.id ? lesson : l).toList();
    // Сортируем уроки по времени начала
    updatedLessons.sort((a, b) => a.startTime.compareTo(b.startTime));
    return copyWith(lessons: updatedLessons);
  }

  /// JSON сериализация
  factory DaySchedule.fromJson(Map<String, dynamic> json) => _$DayScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$DayScheduleToJson(this);

  @override
  String toString() {
    return 'DaySchedule(${weekDay.displayName}, ${lessons.length} lessons)';
  }
}

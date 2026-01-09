import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/day_schedule.dart';

/// Сервис для работы с локальным хранилищем
class StorageService {
  static const String _scheduleKey = 'weekly_schedule';

  /// Сохранить расписание на неделю
  Future<void> saveSchedule(Map<WeekDay, DaySchedule> schedule) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> scheduleJson = {};

    schedule.forEach((day, daySchedule) {
      scheduleJson[day.name] = daySchedule.toJson();
    });

    await prefs.setString(_scheduleKey, json.encode(scheduleJson));
  }

  /// Загрузить расписание на неделю
  Future<Map<WeekDay, DaySchedule>> loadSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleString = prefs.getString(_scheduleKey);

    if (scheduleString == null) {
      // Возвращаем пустое расписание для всех дней недели
      return _createEmptySchedule();
    }

    try {
      final Map<String, dynamic> scheduleJson = json.decode(scheduleString);
      final Map<WeekDay, DaySchedule> schedule = {};

      scheduleJson.forEach((dayName, dayJson) {
        try {
          final weekDay = WeekDay.values.firstWhere((d) => d.name == dayName);
          schedule[weekDay] = DaySchedule.fromJson(dayJson);
        } catch (e) {
          // Игнорируем некорректные данные
        }
      });

      // Добавляем пустые дни, если их нет в сохраненных данных
      for (final day in WeekDay.values) {
        if (!schedule.containsKey(day)) {
          schedule[day] = DaySchedule(weekDay: day, lessons: []);
        }
      }

      return schedule;
    } catch (e) {
      // В случае ошибки возвращаем пустое расписание
      return _createEmptySchedule();
    }
  }

  /// Очистить все данные
  Future<void> clearSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scheduleKey);
  }

  /// Создать пустое расписание для всех дней недели
  Map<WeekDay, DaySchedule> _createEmptySchedule() {
    return {
      for (var day in WeekDay.values) day: DaySchedule(weekDay: day, lessons: [])
    };
  }
}

import 'package:flutter/foundation.dart';
import '../models/day_schedule.dart';
import '../models/lesson.dart';
import 'storage_service.dart';
import 'widget_service.dart';

/// Провайдер для управления расписанием
class ScheduleProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  Map<WeekDay, DaySchedule> _schedule = {};
  bool _isLoading = true;

  Map<WeekDay, DaySchedule> get schedule => _schedule;
  bool get isLoading => _isLoading;

  ScheduleProvider() {
    _loadSchedule();
  }

  /// Загрузить расписание из хранилища
  Future<void> _loadSchedule() async {
    _isLoading = true;
    notifyListeners();

    _schedule = await _storageService.loadSchedule();

    _isLoading = false;
    notifyListeners();
  }

  /// Получить расписание на конкретный день
  DaySchedule? getDaySchedule(WeekDay day) {
    return _schedule[day];
  }

  /// Получить расписание на сегодня
  DaySchedule? getTodaySchedule() {
    final today = WeekDay.fromDateTime(DateTime.now());
    return getDaySchedule(today);
  }

  /// Добавить урок в день
  Future<void> addLesson(WeekDay day, Lesson lesson) async {
    final daySchedule = _schedule[day];
    if (daySchedule != null) {
      _schedule[day] = daySchedule.addLesson(lesson);
      await _saveSchedule();
      notifyListeners();
    }
  }

  /// Удалить урок
  Future<void> removeLesson(WeekDay day, String lessonId) async {
    final daySchedule = _schedule[day];
    if (daySchedule != null) {
      _schedule[day] = daySchedule.removeLesson(lessonId);
      await _saveSchedule();
      notifyListeners();
    }
  }

  /// Обновить урок
  Future<void> updateLesson(WeekDay day, Lesson lesson) async {
    final daySchedule = _schedule[day];
    if (daySchedule != null) {
      _schedule[day] = daySchedule.updateLesson(lesson);
      await _saveSchedule();
      notifyListeners();
    }
  }

  /// Очистить все расписание
  Future<void> clearSchedule() async {
    await _storageService.clearSchedule();
    await _loadSchedule();
  }

  /// Сохранить расписание в хранилище
  Future<void> _saveSchedule() async {
    await _storageService.saveSchedule(_schedule);
    // Обновляем виджет после сохранения
    await WidgetService.updateWidget();
  }

  /// Перезагрузить расписание
  Future<void> reload() async {
    await _loadSchedule();
  }
}

import 'package:home_widget/home_widget.dart';
import '../models/day_schedule.dart';
import '../models/lesson.dart';
import 'storage_service.dart';

/// Сервис для работы с виджетами главного экрана
class WidgetService {
  static const String _widgetName = 'ScheduleWidgetProvider';

  /// Обновить данные виджета
  static Future<void> updateWidget() async {
    try {
      final storageService = StorageService();
      final schedule = await storageService.loadSchedule();
      final today = WeekDay.fromDateTime(DateTime.now());
      final todaySchedule = schedule[today];

      if (todaySchedule != null && todaySchedule.lessons.isNotEmpty) {
        // Отправляем данные для виджета
        await HomeWidget.saveWidgetData<String>('day_name', today.displayName);
        await HomeWidget.saveWidgetData<int>('lesson_count', todaySchedule.lessons.length);

        // Отправляем информацию о первых 3 уроках
        for (int i = 0; i < todaySchedule.lessons.length && i < 3; i++) {
          final lesson = todaySchedule.lessons[i];
          await HomeWidget.saveWidgetData<String>('lesson_${i}_subject', lesson.subject);
          await HomeWidget.saveWidgetData<String>('lesson_${i}_time', '${lesson.startTime} - ${lesson.endTime}');
          await HomeWidget.saveWidgetData<String>('lesson_${i}_classroom', lesson.classroom ?? '');
        }
      } else {
        // Нет уроков на сегодня
        await HomeWidget.saveWidgetData<String>('day_name', today.displayName);
        await HomeWidget.saveWidgetData<int>('lesson_count', 0);
      }

      // Обновляем виджет
      await HomeWidget.updateWidget(
        androidName: _widgetName,
        iOSName: 'ScheduleWidget',
      );
    } catch (e) {
      // Игнорируем ошибки при обновлении виджета
    }
  }

  /// Получить текущий урок
  static Lesson? getCurrentLesson(List<Lesson> lessons) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    for (final lesson in lessons) {
      if (currentTime.compareTo(lesson.startTime) >= 0 &&
          currentTime.compareTo(lesson.endTime) < 0) {
        return lesson;
      }
    }
    return null;
  }

  /// Получить следующий урок
  static Lesson? getNextLesson(List<Lesson> lessons) {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    for (final lesson in lessons) {
      if (currentTime.compareTo(lesson.startTime) < 0) {
        return lesson;
      }
    }
    return null;
  }
}

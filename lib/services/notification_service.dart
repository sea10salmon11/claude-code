import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/day_schedule.dart';
import '../models/lesson.dart';

/// Сервис для работы с уведомлениями
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Инициализировать сервис уведомлений
  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    _initialized = true;
  }

  /// Запросить разрешения на уведомления
  static Future<bool> requestPermissions() async {
    await initialize();

    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    final iosImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return true;
  }

  /// Показать уведомление с текущим расписанием
  static Future<void> showTodaySchedule(List<Lesson> lessons) async {
    await initialize();

    if (lessons.isEmpty) return;

    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // Найти текущий или следующий урок
    Lesson? nextLesson;
    for (final lesson in lessons) {
      if (currentTime.compareTo(lesson.startTime) < 0) {
        nextLesson = lesson;
        break;
      }
    }

    if (nextLesson != null) {
      final title = 'Следующий урок: ${nextLesson.subject}';
      final body = 'Начало в ${nextLesson.startTime}'
          '${nextLesson.classroom != null ? ', кабинет ${nextLesson.classroom}' : ''}';

      await _showNotification(
        id: 1,
        title: title,
        body: body,
      );
    } else {
      // Все уроки закончились
      await _showNotification(
        id: 1,
        title: 'Уроки на сегодня закончились',
        body: 'Завтра: ${lessons.length} уроков',
      );
    }
  }

  /// Показать расписание на день
  static Future<void> showDaySchedule(WeekDay day, List<Lesson> lessons) async {
    await initialize();

    if (lessons.isEmpty) {
      await _showNotification(
        id: 2,
        title: 'Расписание на ${day.displayName}',
        body: 'Нет уроков',
      );
      return;
    }

    final lessonsText = lessons.take(3).map((l) {
      return '${l.startTime} - ${l.subject}';
    }).join('\n');

    final moreCount = lessons.length > 3 ? ' и ещё ${lessons.length - 3}' : '';

    await _showNotification(
      id: 2,
      title: 'Расписание на ${day.displayName}',
      body: '$lessonsText$moreCount',
    );
  }

  /// Создать постоянное уведомление с расписанием
  static Future<void> createPersistentScheduleNotification(
    WeekDay day,
    List<Lesson> lessons,
  ) async {
    await initialize();

    if (lessons.isEmpty) return;

    final lessonsText = lessons.take(5).map((l) {
      final classroom = l.classroom != null ? ' (каб. ${l.classroom})' : '';
      return '${l.startTime} - ${l.subject}$classroom';
    }).join('\n');

    const androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Расписание',
      channelDescription: 'Постоянное уведомление с расписанием уроков',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      '${day.displayName}: ${lessons.length} уроков',
      lessonsText,
      details,
    );
  }

  /// Отменить постоянное уведомление
  static Future<void> cancelPersistentNotification() async {
    await _notifications.cancel(0);
  }

  /// Внутренний метод для показа уведомления
  static Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'schedule_updates',
      'Обновления расписания',
      channelDescription: 'Уведомления об изменениях в расписании',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details);
  }

  /// Отменить все уведомления
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}

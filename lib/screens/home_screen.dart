import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/day_schedule.dart';
import '../models/lesson.dart';
import '../services/schedule_provider.dart';
import '../services/notification_service.dart';
import '../widgets/lesson_card.dart';
import 'edit_lesson_screen.dart';

/// Главный экран приложения
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late WeekDay _currentDay;

  @override
  void initState() {
    super.initState();
    _currentDay = WeekDay.fromDateTime(DateTime.now());
    _tabController = TabController(
      length: WeekDay.values.length,
      vsync: this,
      initialIndex: _currentDay.index,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentDay = WeekDay.values[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание уроков'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: WeekDay.values.map((day) {
            return Tab(text: day.shortName);
          }).toList(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmation();
              } else if (value == 'show_notification') {
                _showTodayNotification(context);
              } else if (value == 'persistent_notification') {
                _togglePersistentNotification(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'show_notification',
                child: Row(
                  children: [
                    Icon(Icons.notifications_active),
                    SizedBox(width: 8),
                    Text('Показать на экране блокировки'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'persistent_notification',
                child: Row(
                  children: [
                    Icon(Icons.notification_add),
                    SizedBox(width: 8),
                    Text('Постоянное уведомление'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Очистить расписание'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: WeekDay.values.map((day) {
          return _DayScheduleView(weekDay: day);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addLesson(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addLesson(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLessonScreen(weekDay: _currentDay),
      ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить расписание'),
        content: const Text('Вы уверены, что хотите удалить все уроки?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<ScheduleProvider>().clearSchedule();
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _showTodayNotification(BuildContext context) async {
    final provider = context.read<ScheduleProvider>();
    final todaySchedule = provider.getTodaySchedule();

    if (todaySchedule == null || todaySchedule.lessons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет уроков на сегодня')),
      );
      return;
    }

    await NotificationService.requestPermissions();
    await NotificationService.showDaySchedule(
      WeekDay.fromDateTime(DateTime.now()),
      todaySchedule.lessons,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Расписание отправлено в уведомления'),
        ),
      );
    }
  }

  Future<void> _togglePersistentNotification(BuildContext context) async {
    final provider = context.read<ScheduleProvider>();
    final todaySchedule = provider.getTodaySchedule();

    if (todaySchedule == null || todaySchedule.lessons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет уроков на сегодня')),
      );
      return;
    }

    await NotificationService.requestPermissions();
    await NotificationService.createPersistentScheduleNotification(
      WeekDay.fromDateTime(DateTime.now()),
      todaySchedule.lessons,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Постоянное уведомление создано'),
          action: SnackBarAction(
            label: 'Отменить',
            onPressed: () {
              NotificationService.cancelPersistentNotification();
            },
          ),
        ),
      );
    }
  }
}

/// Виджет отображения расписания на день
class _DayScheduleView extends StatelessWidget {
  final WeekDay weekDay;

  const _DayScheduleView({required this.weekDay});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final daySchedule = provider.getDaySchedule(weekDay);
        final lessons = daySchedule?.lessons ?? [];

        if (lessons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Нет уроков на ${weekDay.displayName.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Нажмите + чтобы добавить урок',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return LessonCard(
              lesson: lesson,
              onTap: () => _editLesson(context, lesson),
              onDelete: () => _deleteLesson(context, provider, lesson),
            );
          },
        );
      },
    );
  }

  void _editLesson(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditLessonScreen(
          weekDay: weekDay,
          lesson: lesson,
        ),
      ),
    );
  }

  void _deleteLesson(BuildContext context, ScheduleProvider provider, Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить урок'),
        content: Text('Удалить урок "${lesson.subject}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              provider.removeLesson(weekDay, lesson.id);
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

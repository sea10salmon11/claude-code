import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/day_schedule.dart';
import '../models/lesson.dart';
import '../services/schedule_provider.dart';
import '../utils/constants.dart';

/// Экран редактирования/добавления урока
class EditLessonScreen extends StatefulWidget {
  final WeekDay weekDay;
  final Lesson? lesson;

  const EditLessonScreen({
    super.key,
    required this.weekDay,
    this.lesson,
  });

  @override
  State<EditLessonScreen> createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _classroomController;
  late TextEditingController _teacherController;

  Color _selectedColor = AppConstants.lessonColors[0];

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.lesson?.subject ?? '');
    _startTimeController = TextEditingController(text: widget.lesson?.startTime ?? '');
    _endTimeController = TextEditingController(text: widget.lesson?.endTime ?? '');
    _classroomController = TextEditingController(text: widget.lesson?.classroom ?? '');
    _teacherController = TextEditingController(text: widget.lesson?.teacher ?? '');

    if (widget.lesson?.color != null) {
      _selectedColor = colorFromHex(widget.lesson!.color!);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _classroomController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.lesson != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать урок' : 'Добавить урок'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveLesson,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Название предмета
            Autocomplete<String>(
              initialValue: TextEditingValue(text: _subjectController.text),
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return AppConstants.commonSubjects.where((subject) {
                  return subject.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                });
              },
              onSelected: (selection) {
                _subjectController.text = selection;
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                _subjectController = controller;
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Предмет *',
                    hintText: 'Например: Математика',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите название предмета';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Время начала и окончания
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Начало *',
                      hintText: '08:00',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () => _selectTime(context, _startTimeController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Выберите время';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _endTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Конец *',
                      hintText: '08:45',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    readOnly: true,
                    onTap: () => _selectTime(context, _endTimeController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Выберите время';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Кабинет
            TextFormField(
              controller: _classroomController,
              decoration: const InputDecoration(
                labelText: 'Кабинет',
                hintText: 'Например: 205',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.room),
              ),
            ),
            const SizedBox(height: 16),

            // Учитель
            TextFormField(
              controller: _teacherController,
              decoration: const InputDecoration(
                labelText: 'Учитель',
                hintText: 'Например: Иванов И.И.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 24),

            // Выбор цвета
            const Text(
              'Цвет урока',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppConstants.lessonColors.map((color) {
                final isSelected = color.value == _selectedColor.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTimeOfDay(controller.text) ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = _formatTimeOfDay(picked);
      });
    }
  }

  TimeOfDay? _parseTimeOfDay(String time) {
    if (time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _saveLesson() {
    if (_formKey.currentState!.validate()) {
      final lesson = Lesson(
        id: widget.lesson?.id ?? const Uuid().v4(),
        subject: _subjectController.text.trim(),
        startTime: _startTimeController.text.trim(),
        endTime: _endTimeController.text.trim(),
        classroom: _classroomController.text.trim().isEmpty
            ? null
            : _classroomController.text.trim(),
        teacher: _teacherController.text.trim().isEmpty
            ? null
            : _teacherController.text.trim(),
        color: colorToHex(_selectedColor),
      );

      final provider = context.read<ScheduleProvider>();
      if (widget.lesson != null) {
        provider.updateLesson(widget.weekDay, lesson);
      } else {
        provider.addLesson(widget.weekDay, lesson);
      }

      Navigator.pop(context);
    }
  }
}

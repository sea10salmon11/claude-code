import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../utils/constants.dart';

/// Карточка урока
class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const LessonCard({
    super.key,
    required this.lesson,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = lesson.color != null
        ? colorFromHex(lesson.color!)
        : AppConstants.lessonColors[0];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Цветная полоса слева
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),

              // Информация об уроке
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название предмета
                    Text(
                      lesson.subject,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Время
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.startTime} - ${lesson.endTime}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // Кабинет и учитель
                    if (lesson.classroom != null || lesson.teacher != null) ...[
                      const SizedBox(height: 4),
                      if (lesson.classroom != null)
                        Row(
                          children: [
                            const Icon(Icons.room, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Кабинет ${lesson.classroom}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      if (lesson.teacher != null)
                        Row(
                          children: [
                            const Icon(Icons.person, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                lesson.teacher!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ],
                ),
              ),

              // Кнопка удаления
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
